import AuthenticationServices
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

enum AuthErrors: Error {
    case reauthenticateApple
    case reauthenticateGoogle
    case revokeAppleID
    case revokeGoogle
}

enum AuthState {
    // Anonymously authenticated in Firebase.
    case authenticated
    // Authenticated in Firebase using one of service providers, and not anonymous.
    case signedIn
    // Not authenticated in Firebase.
    case signedOut
}

class AuthManager {
    static let shared = AuthManager()
    
    var authState: AuthState = .signedOut
    
    // 1.
    func appleAuth(
        _ appleIDCredential: ASAuthorizationAppleIDCredential,
        nonce: String?
    ) async throws -> AuthDataResult? {
        guard let nonce = nonce else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
        }

        guard let appleIDToken = appleIDCredential.identityToken else {
            print("Unable to fetch identity token")
            return nil
        }

        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            return nil
        }

        // 2.
        let credentials = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                       rawNonce: nonce,
                                                       fullName: appleIDCredential.fullName)

        do { // 3.
            return try await authenticateUser(credentials: credentials)
        }
        catch {
            print("FirebaseAuthError: appleAuth(appleIDCredential:nonce:) failed. \(error)")
            throw error
        }
    }
    
    var handle: AuthStateDidChangeListenerHandle?
    //combine通知
    @Published var isLoggedIn: Bool = false
    
    func addLoginObserver(complition: @escaping (Bool) -> Void) {
        handle = Auth.auth().addStateDidChangeListener({ _, user in
            complition(user != nil)
        })
    }
    func googleAuth(_ user: GIDGoogleUser) async throws -> AuthDataResult? {
        guard let idToken = user.idToken?.tokenString else { return nil }
        
        // 1.
        let credentials = GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken: user.accessToken.tokenString
        )
        do {
            // 2.
            return try await authenticateUser(credentials: credentials)
        } catch {
            print("FirebaseAuthError: googleAuth(user:) failed. \(error)")
            throw error
        }
    }
    private func authenticateUser(credentials: AuthCredential) async throws -> AuthDataResult? {
        do {
            return try await Auth.auth().signIn(with: credentials)
        } catch {
            print("FirebaseAuthError: Failed to authenticate user. \(error)")
            throw error
        }
    }
    
    func addLoginObserver() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.isLoggedIn = user != nil
        }
    }
//
//    
    //用AppleID來reauthenticate
    private func reauthenticateAppleID(
        _ appleIDCredential: ASAuthorizationAppleIDCredential,
        for user: User
    ) async throws {
        do {
            // 1.Get the identityToken from the given appleIDCredential
            guard let appleIDToken = appleIDCredential.identityToken else { return }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else { return }
            let nonce = AppleSignInManager.nonce
            // 2.
            let credential = OAuthProvider.credential(
                withProviderID: "apple.com",
                idToken: idTokenString,
                rawNonce: nonce
            )
            try await user.reauthenticate(with: credential)
        } catch {
            throw AuthErrors.reauthenticateApple
        }
    }
    //用Google來reauthenticate
    private func reauthenticateGoogleAccount(for user: User) async throws {
        do {
            // 1.
            guard let googleUser = try await GoogleSignInManager.shared.signInWithGoogle() else {
                return
            }
            guard let idToken = googleUser.idToken?.tokenString else { return }
            // 2.
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: googleUser.accessToken.tokenString
            )
            try await user.reauthenticate(with: credential)
        } catch {
            throw AuthErrors.reauthenticateGoogle
        }
    }
    
    //revoke AppleID
    private func revokeAppleIDToken(_ appleIDCredential: ASAuthorizationAppleIDCredential) async throws {
        guard let authorizationCode = appleIDCredential.authorizationCode else { return }
        guard let authCodeString = String(data: authorizationCode, encoding: .utf8) else { return }

        do {
            try await Auth.auth().revokeToken(withAuthorizationCode: authCodeString)
        } catch {
            throw AuthErrors.revokeAppleID
        }
    }
    //revokeGoogleAccount
    private func revokeGoogleAccount() async throws {
        do {
            try await GIDSignIn.sharedInstance.disconnect()
        } catch {
            throw AuthErrors.revokeGoogle
        }
    }
    
    func removeLoginObserver() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    //下面一整段是都要檢查AppleID and the Google credentials
    private func verifySignInWithAppleID() async -> Bool {
            let appleIDProvider = ASAuthorizationAppleIDProvider()

            guard let providerData = Auth.auth().currentUser?.providerData,
                  let appleProviderData = providerData.first(where: { $0.providerID == "apple.com" }) else {
                return false
            }

            do {
                // 1.
                let credentialState = try await appleIDProvider.credentialState(forUserID: appleProviderData.uid)
                return credentialState != .revoked && credentialState != .notFound
            } catch {
                return false
            }
        }

        private func verifyGoogleSignIn() async -> Bool {
            guard let providerData = Auth.auth().currentUser?.providerData,
                  providerData.contains(where: { $0.providerID == "google.com" }) else { return false }

            do {
                // 2.
                try await GIDSignIn.sharedInstance.restorePreviousSignIn()
                return true
            } catch {
                return false
            }
        }

        private func verifySignInProvider() async {
            guard let providerData = Auth.auth().currentUser?.providerData else { return }
            // 3.
            var isAppleCredentialRevoked = false
            var isGoogleCredentialRevoked = false

            if providerData.contains(where: { $0.providerID == "apple.com" }) {
                isAppleCredentialRevoked = await !verifySignInWithAppleID()
            }

            if providerData.contains(where: { $0.providerID == "google.com" }) {
                isGoogleCredentialRevoked = await !verifyGoogleSignIn()
            }

            // 4.
            if isAppleCredentialRevoked && isGoogleCredentialRevoked {
                if authState != .signedIn {
                    do {
                        try self.signOut()
                        authState = .signedOut
                    } catch {
                        print("FirebaseAuthError: verifySignInProvider() failed. \(error)")
                    }
                }
            }
        }
    func signOut() throws {
        do {
            try Auth.auth().signOut()
        } catch {
            throw error
        }
    }
}

extension AuthManager {
    func deleteUserAccount() async throws {
        guard let user = Auth.auth().currentUser,
              let lastSignInDate = user.metadata.lastSignInDate else { return }
        
        // 1.Check if the user has signed-in in the past five minutes.
        let needsReAuth = !lastSignInDate.isWithinPast(minutes: 5)
        
        // 2.刪除帳號之前是否要重新認證且撤銷token
        let providers = user.providerData.map { $0.providerID }

        do {
            if providers.contains("apple.com") {
                // 3.
                let appleIDCredential = try await AppleSignInManager.shared.requestAppleAuthorization()
                
                if needsReAuth {
                    try await reauthenticateAppleID(appleIDCredential, for: user)
                }
                try await revokeAppleIDToken(appleIDCredential)
            }
            
            if providers.contains("google.com") {
                if needsReAuth {
                    try await reauthenticateGoogleAccount(for: user)
                }
                try await revokeGoogleAccount()
            }
            
            // 5.
            try await user.delete() //徹底刪除帳號
            // 6.
            //updateState(user: user) //更新UI
        } catch {
            print("FirebaseAuthError: Failed to delete auth user. \(error)")
            throw error
        }
    }
}

extension Date {
    func isWithinPast(minutes: Int) -> Bool {
        let noww = Date.now
        let timeAgo = Date.now.addingTimeInterval(-1 * TimeInterval(60 * minutes))
        let range = timeAgo...noww
        return range.contains(self)
    }
}

