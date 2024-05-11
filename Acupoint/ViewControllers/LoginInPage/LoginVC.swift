import UIKit
import StoreKit
import FirebaseAuth // 用來與 Firebase Auth 進行串接用的
import AuthenticationServices // Sign in with Apple 的主體框架
import CryptoKit // 用來產生隨機字串 (Nonce) 的
import GoogleSignInSwift
import FirebaseCore
import GoogleSignIn // 導入 Google Sign-In SDK

protocol AddNameDelegate: AnyObject {
    func didAddUserName(_ item: String)
}

class LoginVC: BaseVC {
    
    lazy var appTitle: UILabel = {
        let label = UILabel()
        label.text = "ACUPOINT"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "ZenMaruGothic-Black", size: 40)
        label.textColor = .systemOrange
        return label
    }()
    
    lazy var descibeTitle: UILabel = {
        let label = UILabel()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "ZenMaruGothic-Black", size: 26)
        label.textColor = UIColor.BlueTitleColor
        return label
    }()
    
    lazy var skipButton: UIButton = {
        let button = UIButton()
        button.setTitle("跳 過", for: .normal)
        button.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = .black
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont(name: "ZenMaruGothic-Medium", size: 20)
            return outgoing
        }
        button.configuration = configuration
        return button
    }()
    
    private var signInWithAppleBtn = UIButton()
    
    private var signInGoogleBtn = UIButton()
    
    weak var addDelegate: AddNameDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle()
        setSkipBtn()
        setGoogleBtn()
        setSignInWithAppleBtn()
        //havnt login
        setDescibeTitle()
    }
   
    func setTitle() {
        view.addSubview(appTitle)
        appTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        appTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30).isActive = true
    }
    
    func setSkipBtn() {
        view.addSubview(skipButton)
        skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -10).isActive = true
        skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        skipButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        skipButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setGoogleBtn() {
        signInGoogleBtn.addAction(UIAction(handler: { [weak self] _ in
            self?.googleSignIn()
        }), for: .touchUpInside)
        view.addSubview(signInGoogleBtn)
        signInGoogleBtn.setTitle("Sign in with Google", for: .normal)
        signInGoogleBtn.setTitleColor(.black, for: .normal)
        signInGoogleBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        signInGoogleBtn.setImage(UIImage(named: "googleLogo"), for: .normal)
        signInGoogleBtn.layer.cornerRadius = 10
        signInGoogleBtn.layer.borderWidth = 0.8
        signInGoogleBtn.layer.borderColor = UIColor.gray.cgColor
        signInGoogleBtn.backgroundColor = .white
        signInGoogleBtn.contentHorizontalAlignment = .center
        signInGoogleBtn.translatesAutoresizingMaskIntoConstraints = false
        signInGoogleBtn.translatesAutoresizingMaskIntoConstraints = false
        signInGoogleBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signInGoogleBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80).isActive = true
        signInGoogleBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        signInGoogleBtn.widthAnchor.constraint(equalToConstant: 240).isActive = true
    }
    
    func setDescibeTitle() {
        view.addSubview(descibeTitle)
        descibeTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descibeTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30).isActive = true
//        descibeTitle.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        descibeTitle.widthAnchor.constraint(equalToConstant: 240).isActive = true

    }
    
    //MARK: - google
    private func googleSignIn() {
        // here for simplicity I used completion handler
        // feel free to use async function instead
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] result, error in
            if let error {
                // you can add error handling
                print("Error", error)
                return
            }
            guard let idToken = result?.user.idToken?.tokenString,
                  let accessToken = result?.user.accessToken.tokenString
            else {
                print("Invalid ID token or access token")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            Auth.auth().signIn(with: credential) { _, error in
                if let error {
                    
                    print("Error", error)
                    return
                }
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
    //MARK: - apple
    //SignInApple1
    func setSignInWithAppleBtn() {
        let signInWithAppleBtn = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
        view.addSubview(signInWithAppleBtn)
        signInWithAppleBtn.cornerRadius = 10
        signInWithAppleBtn.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        signInWithAppleBtn.translatesAutoresizingMaskIntoConstraints = false
        signInWithAppleBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        signInWithAppleBtn.widthAnchor.constraint(equalToConstant: 240).isActive = true
        signInWithAppleBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signInWithAppleBtn.bottomAnchor.constraint(equalTo: signInGoogleBtn.topAnchor, constant: -20).isActive = true
    }
    
    fileprivate var currentNonce: String?
    //SignInApple2
    @objc func handleAuthorizationAppleIDButtonPress() {
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
    
    //MARK: - toHomePage
    private func navigateToHomeViewController(with name: String) {
        
        let tabController = TabController()
        tabController.modalPresentationStyle = .fullScreen
        present(tabController, animated: true, completion: nil)
        
        guard let controllers = tabController.viewControllers else { return }
        for viewcontroller in controllers {
            if let navi = viewcontroller as? UINavigationController,
               let targetVC = navi.viewControllers.first as? HomeVC {
                    targetVC.userNameLabel.text = "你好 \(name)"
                AuthManager.shared.isLoggedIn = true
            }
        }
    }
    
    //    func updatedisplayName(for user: User, with appleIDCredential: ASAuthorizationAppleIDCredential, force: Bool = false) async {
    //
    //        if let currentDisplayName = Auth.auth().currentUser?.displayName, !currentDisplayName.isEmpty {
    //            // 有名字了
    //        } else {
    //            let changeRequest = user.createProfileChangeRequest()
    //            changeRequest.displayName = appleIDCredential.displayName()
    //            do {
    //                try await changeRequest.commitChanges()
    //                self.displayName = Auth.auth().currentUser?.displayName ?? ""
    //
    //            }
    //            catch {
    //                error.localizedDescription
    //            }
    //        }
    //    }
    
    //MARK: - skipButton
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
    //SignInApple4
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
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                           rawNonce: nonce,
                                                           fullName: appleIDCredential.fullName)
            
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    CustomFunc.customAlert(title: "使用者取消登入", message: error.localizedDescription, theVc: self, actionHandler: nil)
                    return
                }
                print("User is signed in to Firebase with Apple.")
                
                if let user = authResult?.user {
                    if let userName = Auth.auth().currentUser?.displayName {
                        //有名字
                        #if DEBUG
                        print("userName: \(userName)")
                        #else
                        // No debugging information in release build
                        #endif
                        print(userName)
                        self.navigateToHomeViewController(with: userName)
                    } else {
                        //沒有名字就改名字
                        let defaultName = "New User"
                        let changeRequest = user.createProfileChangeRequest()
                        changeRequest.displayName = defaultName
                        changeRequest.commitChanges { (error) in
                            if let error = error {
                                #if DEBUG
                                print("Fail to change display name: \(error.localizedDescription)")
                                #else
                                // No debugging information in release build
                                #endif
                            } else {
                                #if DEBUG
                                print("Updated displayName to: \(defaultName)")
                                #else
                                // No debugging information in release build
                                #endif
                                self.navigateToHomeViewController(with: defaultName)
                            }
                        }
                    }
                }
            }
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
    //SignInApple3
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}

