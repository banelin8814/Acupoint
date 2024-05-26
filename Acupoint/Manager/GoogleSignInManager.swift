import Foundation
import FirebaseAuth
import AuthenticationServices
import GoogleSignIn

class GoogleSignInManager {
    
    static let shared = GoogleSignInManager()
    
    private init() {}
    
    @MainActor
    func signInWithGoogle() async throws -> GIDGoogleUser? {
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            do {

                try await GIDSignIn.sharedInstance.restorePreviousSignIn()

                return try await GIDSignIn.sharedInstance.currentUser?.refreshTokensIfNeeded()
                
            } catch {

                return try await googleSignInFlow()
            }
        } else {
            return try await googleSignInFlow()
        }
    }
    
    @MainActor
    private func googleSignInFlow() async throws -> GIDGoogleUser? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return nil }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { return nil }
        
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
        return result.user
    }

    func signOutFromGoogle() {
        GIDSignIn.sharedInstance.signOut()
    }
}
