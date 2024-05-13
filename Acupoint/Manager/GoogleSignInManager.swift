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
                //之前已經revoke token，重新近入登入流程
                try await GIDSignIn.sharedInstance.restorePreviousSignIn() //previous revoke to the access token, then initiate the sign-in flow.
                // restores a locally cached user so it does not send any server requests if the tokens haven't expired
                //恢復本地快取的用戶，這樣如果令牌尚未過期，它就不會發送任何伺服器請求
                // 1.
                return try await GIDSignIn.sharedInstance.currentUser?.refreshTokensIfNeeded() // in case the access token has expired. 如果token過期
            } catch {
                // 2.
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
    // 4.
    func signOutFromGoogle() {
        GIDSignIn.sharedInstance.signOut()
    }
}
