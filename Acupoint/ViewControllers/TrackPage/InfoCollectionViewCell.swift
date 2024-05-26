import UIKit

class InfoCollectionViewCell: UICollectionViewCell {
    
    let acupointNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configureHeadingTwoLabel(withText: "")
        
        return label
    }()
    
    let introLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.configureTextOneLabel(withText: "")
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
        
        contentView.insertSubview(blurView, at: 0)
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: contentView.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.addSubview(acupointNameLabel)
        contentView.addSubview(introLabel)
        
        NSLayoutConstraint.activate([
            acupointNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            acupointNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            acupointNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            acupointNameLabel.heightAnchor.constraint(equalToConstant: 40),
            introLabel.topAnchor.constraint(equalTo: acupointNameLabel.bottomAnchor, constant: 5),
            introLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            introLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
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
