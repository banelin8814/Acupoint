import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    private var gradientLayer: CAGradientLayer?
    
    let mainVw: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.image = UIImage(named: "失眠")
        view.contentMode = .scaleAspectFill
    
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configureHeadingTwoLabel(withText: "失眠")
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        contentView.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {

        contentView.addSubview(mainVw)
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            mainVw.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainVw.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainVw.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainVw.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: mainVw.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])
    }
}
