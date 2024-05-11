import UIKit

class InitialSignInVC: BaseVC {
    
    lazy var appImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Logo")
        image.layer.cornerRadius = 24
        image.layer.masksToBounds = true
        return image
    }()
    
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("開 始", for: .normal)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = UIFont(name: "ZenMaruGothic-Medium", size: 28)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 18
        button.layer.masksToBounds = true
        return button
    }()
    
    lazy var skipButton: UIButton = {
        let button = UIButton()
        button.setTitle("跳 過", for: .normal)
        button.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        
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
    
    lazy var discribeLbl: UILabel = {
        let label = UILabel()
        label.configureHeadingTwoLabel(withText: "找到自己的穴位!")
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.hexStringToUIColor(theHex: "#F4F1E8")
        view.addSubview(loginButton)
        view.addSubview(skipButton)
        view.addSubview(appImage)
        view.addSubview(discribeLbl)
        setupUI()
    }
    
    func setupUI() {
        
        appImage.translatesAutoresizingMaskIntoConstraints = false
        appImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        appImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80).isActive = true
        appImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        appImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        discribeLbl.translatesAutoresizingMaskIntoConstraints = false
        discribeLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        discribeLbl.topAnchor.constraint(equalTo: appImage.bottomAnchor, constant: 20).isActive = true
        discribeLbl.widthAnchor.constraint(equalToConstant: 260).isActive = true
        discribeLbl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: discribeLbl.bottomAnchor, constant: 40).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 160).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -10).isActive = true
        skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        skipButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        skipButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func loginButtonTapped() {
        let loginVC = LoginVC()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: false, completion: nil)
    }
    
    @objc func skipButtonTapped() {
        let tabController = TabController()
        tabController.modalPresentationStyle = .fullScreen
        present(tabController, animated: false, completion: nil)
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
