import UIKit

class HandVCCollectionViewCell: UICollectionViewCell {
    
    let acupointNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .white

        return label
    }()
    
    let acupointLocationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0 // 設為0表示自動換行
        label.lineBreakMode = .byWordWrapping // 以單詞為單位換行
        label.contentMode = .topLeft
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    private let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()
 

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        contentView.layer.cornerRadius = 30
        contentView.layer.masksToBounds = true
        
        // Add blur view as a subview
        contentView.insertSubview(blurView, at: 0)
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: contentView.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        // Set background color with transparency
//        blurView.backgroundColor = UIColor.white.withAlphaComponent(0.001)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.addSubview(acupointNameLabel)
        contentView.addSubview(acupointLocationLabel)
        
        NSLayoutConstraint.activate([
            acupointNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            acupointNameLabel.heightAnchor.constraint(equalToConstant: 30),
            acupointNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            acupointNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            acupointLocationLabel.topAnchor.constraint(equalTo: acupointNameLabel.bottomAnchor, constant: 8),
            acupointLocationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            acupointLocationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            acupointLocationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    func configure(with acupoint: HandAcupointModel) {
        acupointNameLabel.text = acupoint.name
        acupointLocationLabel.text = "位置：\(acupoint.location)"
    }
}
