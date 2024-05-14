import UIKit

class CommonCollectionViewCell: UICollectionViewCell {
    
    lazy var titleLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "助眠穴位"
        label.configureHeadingTwoLabel(withText: "")
        label.textColor = .white
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "頭痛")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLbl)
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setupCell(_ backgroundColor: UIColor, title: String, image: UIImage) {
        setupUI()
        imageView.image = image
        titleLbl.text = title
        contentView.backgroundColor = backgroundColor
        contentView.layer.cornerRadius = 25
        contentView.layer.masksToBounds = true
    }
    
    func setupUI() {
        NSLayoutConstraint.activate([
            titleLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLbl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
