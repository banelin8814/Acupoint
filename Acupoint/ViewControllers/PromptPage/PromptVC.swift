import UIKit

class PromptVC: UIViewController {
    
    //    lazy var promptImageView: UIImageView = {
    //        let imageView = UIImageView()
    //        imageView.image = UIImage(named: "intro")
    //        imageView.contentMode = .scaleAspectFit
    //        imageView.translatesAutoresizingMaskIntoConstraints = false
    //        return imageView
    //    }()
    var timer: Timer?
    
    var isBackHand = false {
        didSet {
            if isBackHand {
                handSideLbl.configureHeadingThreeLabel(withText: "(手 背 穴 位)")
            } else {
                handSideLbl.configureHeadingThreeLabel(withText: "(手 心 穴 位)")
            }
        }
    }
    
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
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var promptPostionLbl: UILabel = {
        let label = UILabel()
        label.configureHeadingThreeLabel(withText: "")
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let handleView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var handSideLbl: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    weak var delegate: CanChangeCellSizeAnimate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        view.addSubview(promptNameLbl)
        view.addSubview(promptPostionLbl)
        view.addSubview(promptEffectLbl)
        view.addSubview(handleView)
        view.addSubview(handSideLbl)
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.animateDownward()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disAppear()
        timer?.invalidate()
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
            promptNameLbl.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -90),
            
            promptEffectLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            promptEffectLbl.topAnchor.constraint(equalTo: promptNameLbl.bottomAnchor, constant: 15),
            promptEffectLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            promptEffectLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            promptPostionLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            promptPostionLbl.topAnchor.constraint(equalTo: promptEffectLbl.bottomAnchor, constant: 15),
            promptPostionLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            promptPostionLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            handSideLbl.topAnchor.constraint(equalTo: promptPostionLbl.bottomAnchor, constant: 10),
            handSideLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            handleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            handleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            handleView.widthAnchor.constraint(equalToConstant: 60),
            handleView.heightAnchor.constraint(equalToConstant: 6)
            
        ])
    }
    func animateDownward() {
        UIView.animate(withDuration: 0.5) {
            self.view.frame.origin.y += 50
        } completion: { _ in
            UIView.animate(withDuration: 0.5) {
                self.view.frame.origin.y -= 50
            }
        }
    }
}
