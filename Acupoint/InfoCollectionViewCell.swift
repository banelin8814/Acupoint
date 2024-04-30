import UIKit

class InfoCollectionViewCell: UICollectionViewCell {
           
    let acupointNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configureHeadingOneLabel(withText: "")

        return label
    }()
    
    let introLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.contentMode = .topLeft
        label.configureTextTwoLabel(withText: "")
        return label
    }()
    
    let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemChromeMaterialDark)
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
        contentView.addSubview(introLabel)
        
        NSLayoutConstraint.activate([
            acupointNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            acupointNameLabel.heightAnchor.constraint(equalToConstant: 30),
            acupointNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            acupointNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            introLabel.topAnchor.constraint(equalTo: acupointNameLabel.bottomAnchor, constant: 8),
            introLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            introLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            introLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func configureFaceDataFromWikiVC(with acupoint: FaceAcupointModel) {
        acupointNameLabel.text = acupoint.name
        introLabel.text = "位置：\(acupoint.location)"
    }
    func configureFaceDataFromSearchVC(with acupoint: FaceAcupointModel) {
        acupointNameLabel.text = acupoint.name
        introLabel.text = "手法：\(acupoint.method)"
    }
    func configureHandDataFromWikiVC(with acupoint: HandAcupointModel) {
        acupointNameLabel.text = acupoint.name
        introLabel.text = "位置：\(acupoint.location)"
    }
    func configureHandDataFromSearchVC(with acupoint: HandAcupointModel) {
        acupointNameLabel.text = acupoint.name
        introLabel.text = "手法：\(acupoint.method)"
    }
    
}
