import UIKit
import StoreKit
import FirebaseAuth // 用來與 Firebase Auth 進行串接用的
import AuthenticationServices // Sign in with Apple 的主體框架
import CryptoKit // 用來產生隨機字串 (Nonce) 的
import GoogleSignInSwift
import FirebaseCore
import GoogleSignIn // 導入 Google Sign-In SDK

class LoginVC: UIViewController {
    
    lazy var skipButton: UIButton = {
        let button = UIButton()
        button.setTitle("跳過", for: .normal)
        button.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        
        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = .black
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont(name: "ZenMaruGothic-Medium", size: 16)
            return outgoing
        }
        button.configuration = configuration
        
        return button
    }()
    
    // signInWithApple
    var signInWithAppleBtn = UIButton()
    
    // signInWithGoogle
    private var signInGoogleButton = GIDSignInButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.hexStringToUIColor(theHex: "#F4F1E8")
        
        view.addSubview(skipButton)
        setSkipBtn()
        
        // signInWithGoogle
        setGoogleBtn()
        
        // signInWithApple
        setSignInWithAppleBtn()
        
    }
    
    func setSkipBtn() {
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -10).isActive = true
        skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        skipButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        skipButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setGoogleBtn() {
        signInGoogleButton.addAction(UIAction(handler: { [weak self] _ in
            self?.googleSignIn()
        }), for: .touchUpInside)
        view.addSubview(signInGoogleButton)
        
        // add AutoLayout for the button
        // here we just set the button to the center of the view
        signInGoogleButton.translatesAutoresizingMaskIntoConstraints = false
        signInGoogleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signInGoogleButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    
    // signInWithGoogle
    private func googleSignIn() {
        // here for simplicity I used completion handler
        // feel free to use async function instead
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] result, error in
            if let error {
                // you can add error handling
                print("Error", error)
                return
            }
            
            // you can add anything with user data if you like
            // here I save user name for HomeViewController
            guard let name = result?.user.profile?.name else {
                // you can add error handling
                print("Invalid user profile")
                return
            }
            
            self?.navigateToHomeViewController(with: name)
        }
    }
    
    private func navigateToHomeViewController(with name: String) {
        // here you can create a HomeViewController and display user name
        // then just redirect to HomeViewController if needed
    }
    
    // signInWithApple
    func setSignInWithAppleBtn() {
        let signInWithAppleBtn = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: chooseAppleButtonStyle())
        view.addSubview(signInWithAppleBtn)
        signInWithAppleBtn.cornerRadius = 25
        signInWithAppleBtn.addTarget(self, action: #selector(signInWithApple), for: .touchUpInside)
        signInWithAppleBtn.translatesAutoresizingMaskIntoConstraints = false
        signInWithAppleBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        signInWithAppleBtn.widthAnchor.constraint(equalToConstant: 280).isActive = true
        signInWithAppleBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signInWithAppleBtn.bottomAnchor.constraint(equalTo: signInGoogleButton.topAnchor, constant: -20).isActive = true
    }
    
    func chooseAppleButtonStyle() -> ASAuthorizationAppleIDButton.Style {
        return (UITraitCollection.current.userInterfaceStyle == .light) ? .black : .white // 淺色模式就顯示黑色的按鈕，深色模式就顯示白色的按鈕
    }
    
    // signInWithApple
    fileprivate var currentNonce: String?
    
    @objc func signInWithApple() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    // signInWithApple
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while(remainingLength > 0) {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if (errorCode != errSecSuccess) {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if (remainingLength == 0) {
                    return
                }
                
                if (random < charset.count) {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        return hashString
    }
    
    func firebaseSignInWithApple(credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (_, error) in
            if let error = error {
                CustomFunc.customAlert(title: "登入失敗", message: error.localizedDescription, theVc: self, actionHandler: nil)
                return
            }
            // 登入成功，執行相應的操作
            CustomFunc.customAlert(title: "登入成功", message: "歡迎使用我們的應用程式", theVc: self, actionHandler: nil)
        }
    }
    
    @objc func skipButtonTapped() {
        let tabController = TabController()
        tabController.modalPresentationStyle = .fullScreen
        self.present(tabController, animated: false, completion: nil)
    }
    
    func createSkipButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Skip", for: .normal)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blue.cgColor
        button.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        return button
    }
}

extension LoginVC: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        // 登入成功
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                CustomFunc.customAlert(title: "", message: "Unable to fetch identity token", theVc: self, actionHandler: nil)
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                CustomFunc.customAlert(title: "", message: "Unable to serialize token string from data\n\(appleIDToken.debugDescription)", theVc: self, actionHandler: nil)
                return
            }
            // 產生 Apple ID 登入的 Credential
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            // 與 Firebase Auth 進行串接
            firebaseSignInWithApple(credential: credential)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // 登入失敗，處理 Error
        switch error {
        case ASAuthorizationError.canceled:
            CustomFunc.customAlert(title: "使用者取消登入", message: "", theVc: self, actionHandler: nil)
            
        case ASAuthorizationError.failed:
            CustomFunc.customAlert(title: "授權請求失敗", message: "", theVc: self, actionHandler: nil)
            
        case ASAuthorizationError.invalidResponse:
            CustomFunc.customAlert(title: "授權請求無回應", message: "", theVc: self, actionHandler: nil)
            
        case ASAuthorizationError.notHandled:
            CustomFunc.customAlert(title: "授權請求未處理", message: "", theVc: self, actionHandler: nil)
            
        case ASAuthorizationError.unknown:
            CustomFunc.customAlert(title: "授權失敗，原因不知", message: "", theVc: self, actionHandler: nil)
            
        default:
            break
        }
    }
}

extension LoginVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}

class CustomFunc {
    static func customAlert(title: String, message: String, theVc: UIViewController, actionHandler: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            actionHandler?()
        }
        alertController.addAction(okAction)
        theVc.present(alertController, animated: true, completion: nil)
    }
}
