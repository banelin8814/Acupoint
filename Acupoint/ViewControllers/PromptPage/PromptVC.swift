import UIKit

class PromptVC: UIViewController {

//    lazy var promptImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: "intro")
//        imageView.contentMode = .scaleAspectFit
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
    
    lazy var promptNameLbl: UILabel = {
        let label = UILabel()
        label.configureHeadingOneLabel(withText: "")
        label.textColor = UIColor.BlueTitleColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var promptEffectLbl: UILabel = {
        let label = UILabel()
        label.configureHeadingThreeLabel(withText: "")
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var promptPostionLbl: UILabel = {
        let label = UILabel()
        label.configureHeadingThreeLabel(withText: "")
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let handleView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    weak var delegate: CanDismissAnimate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        view.addSubview(promptNameLbl)
        view.addSubview(promptPostionLbl)
        view.addSubview(promptEffectLbl)
        view.addSubview(handleView)
        setupUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disAppear()
    }
    
    func disAppear() {
        if isBeingDismissed {
            delegate?.dismissAnimate()
        }
    }
    
    func setupUI() {
        
        NSLayoutConstraint.activate([
//            promptImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            promptImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
//            promptImageView.widthAnchor.constraint(equalToConstant: 200),
//            promptImageView.heightAnchor.constraint(equalToConstant: 200),
            promptNameLbl.heightAnchor.constraint(equalToConstant: 50),
            promptNameLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            promptNameLbl.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
            
            promptEffectLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            promptEffectLbl.topAnchor.constraint(equalTo: promptNameLbl.bottomAnchor, constant: 15),
            promptEffectLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            promptEffectLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            promptPostionLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            promptPostionLbl.topAnchor.constraint(equalTo: promptEffectLbl.bottomAnchor, constant: 15),
            promptPostionLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            promptPostionLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
          
            handleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            handleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            handleView.widthAnchor.constraint(equalToConstant: 60),
            handleView.heightAnchor.constraint(equalToConstant: 6)
        ])
    }
}


