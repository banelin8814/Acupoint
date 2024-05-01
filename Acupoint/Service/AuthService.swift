import UIKit
import StoreKit
import FirebaseAuth // 用來與 Firebase Auth 進行串接用的
import AuthenticationServices // Sign in with Apple 的主體框架
import CryptoKit // 用來產生隨機字串 (Nonce) 的
import GoogleSignInSwift
import FirebaseCore
import GoogleSignIn // 導入 Google Sign-In SDK

//protocol AuthServiceProtocol {
//    func signInWithApple()
//    func signInWithGoogle(presenting: UIViewController, completion: @escaping (Result<String, Error>) -> Void)
//    func firebaseSignInWithApple(credential: AuthCredential, completion: @escaping (Result<Void, Error>) -> Void)
//}
//
//class AuthService: AuthServiceProtocol {
//    static let shared = AuthService()
//    
//    func signInWithApple() {
//        <#code#>
//    }
//    
//    func signInWithGoogle(presenting: UIViewController, completion: @escaping (Result<String, any Error>) -> Void) {
//        <#code#>
//    }
//    
//    func firebaseSignInWithApple(credential: AuthCredential, completion: @escaping (Result<Void, any Error>) -> Void) {
//        <#code#>
//    }
//}
