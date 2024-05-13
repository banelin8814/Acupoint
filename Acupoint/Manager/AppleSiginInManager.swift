import Foundation
import AuthenticationServices
import CryptoKit

class AppleSignInManager: NSObject {
    
    static let shared = AppleSignInManager()
    
    fileprivate static var currentNonce: String?

    static var nonce: String? {
            currentNonce ?? nil
        }
    
    private override init() {}

    private var continuation : CheckedContinuation<ASAuthorizationAppleIDCredential, Error>?

    func requestAppleAuthorization() async throws -> ASAuthorizationAppleIDCredential {
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation

            let appleIdProvider = ASAuthorizationAppleIDProvider()
            let request = appleIdProvider.createRequest()
//            requestAppleAuthorization(request)

            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()
        }
    }
}
//to handle the AppleID authorization response.
extension AppleSignInManager: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if case let appleIDCredential as ASAuthorizationAppleIDCredential = authorization.credential {
            continuation?.resume(returning: appleIDCredential)
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        continuation?.resume(throwing: error)
    }
}

