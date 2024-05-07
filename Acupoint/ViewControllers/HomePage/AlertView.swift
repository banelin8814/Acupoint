import UIKit

class AlertView: UIView {
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configureHeadingTwoLabel(withText: "按摩注意事項")
        return label
    }()
    
    lazy var contantLabel: UILabel = {
        let label = UILabel()
        label.configureTextTwoLabel(withText: """
                1.出血傾向或服用抗凝血劑者，避免力道大的按摩
                2.局部感染發炎處，應避開按摩
                3.過度虛弱、空腹或無力時，避免按摩，以免反應過激
                4.全身性發炎或自體免疫疾病，須注意按摩力道
                """)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    lazy var container: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(container)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.frame = UIScreen.main.bounds
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animateOut)))
        setupUI()
    }
    
    @objc func animateOut() {
        UIView.animate(withDuration: 0.9, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.container.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
            self.alpha = 0
        }) {(complete) in
                if complete {
                    self.removeFromSuperview()
                }
            }
    }
    
    func setupUI() {
        container.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        container.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        container.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7).isActive = true
        container.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.45).isActive = true
        container.addSubview(titleLabel)
        container.addSubview(contantLabel)
        titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 20).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20).isActive = true
        contantLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15).isActive = true
        contantLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        contantLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20).isActive = true
        contantLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
