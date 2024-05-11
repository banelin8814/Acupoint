import UIKit

class DetailVC: UIViewController {
    
    var acupoitData = AcupointData.shared
    
    lazy var facePoints: [FaceAcupointModel] = {
        acupoitData.faceAcupoints
    }()
    
    lazy var handPoints: [HandAcupointModel] = {
        acupoitData.handAcupoints
    }()
    
    var theName: String?
    
    var index: Int = 0 {
        didSet {
            setupUI()
        }
    }
    
    var isHandPoint = false
    
    let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemChromeMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()
    
    let acupointNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configureHeadingOneLabel(withText: "")
        label.textColor = .white
        return label
    }()
    
    let effectLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configureTextOneLabel(withText: "")
        label.textColor = .white
        return label
    }()
    
    let methodLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configureTextOneLabel(withText: "")
        label.textColor = .white
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configureTextOneLabel(withText: "")
        label.textColor = .white
        return label
    }()
    
    let noticeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configureTextTwoLabel(withText: "")
        label.textColor = .white
        return label
    }()
    
    private let handleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(blurView)
        view.addSubview(acupointNameLabel)
        view.addSubview(effectLabel)
        view.addSubview(methodLabel)
        view.addSubview(locationLabel)
        view.addSubview(noticeLabel)
        view.addSubview(handleView)
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            acupointNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            acupointNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            acupointNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            acupointNameLabel.heightAnchor.constraint(equalToConstant: 60),
            
            effectLabel.topAnchor.constraint(equalTo: acupointNameLabel.bottomAnchor, constant: 20),
            effectLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            effectLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            methodLabel.topAnchor.constraint(equalTo: effectLabel.bottomAnchor, constant: 20),
            methodLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            methodLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            locationLabel.topAnchor.constraint(equalTo: methodLabel.bottomAnchor, constant: 20),
            locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            noticeLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 20),
            noticeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            noticeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            handleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            handleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            handleView.widthAnchor.constraint(equalToConstant: 50),
            handleView.heightAnchor.constraint(equalToConstant: 6)
        ])
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGesture)
        
        facePoints = acupoitData.faceAcupoints
        handPoints = acupoitData.handAcupoints
        
    }
    
    override func viewWillLayoutSubviews() {
        setupUI()
    }
    
    func setupUI() {
        acupointNameLabel.text = theName
        if isHandPoint {
            print(acupointNameLabel.text)
            if let index = handPoints.firstIndex(where: { $0.name == theName }) {
                let thePoint = handPoints[index]
                acupointNameLabel.text = thePoint.name
                effectLabel.text = "功效：\(thePoint.effect)"
                methodLabel.text = "手法：\(thePoint.method)"
                locationLabel.text = "位置：\(thePoint.location)"
                noticeLabel.text = "注意事項：\n\(thePoint.notice)"
            }
        } else {
            if let index = facePoints.firstIndex(where: { $0.name == theName }) {
                let thePoint = facePoints[index]
                acupointNameLabel.text = thePoint.name
                effectLabel.text = "功效：\(thePoint.effect)"
                methodLabel.text = "手法：\(thePoint.method)"
                locationLabel.text = "位置：\(thePoint.location)"
                noticeLabel.text = "注意事項：\n\(thePoint.notice)"
            }
        }
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        if translation.y > 0 {
            view.transform = CGAffineTransform(translationX: 0, y: translation.y)
        }
        
        if gesture.state == .ended {
            if translation.y > 100 {
                dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.view.transform = .identity
                }
            }
        }
    }
}
