import UIKit

class WikiVCTableViewCell: UITableViewCell {
    
    var indexPath: IndexPath?
    
    let mainVw: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.image = UIImage(named: "")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.configureHeadingOneLabel(withText: "")
        label.textColor = .white
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        contentView.addSubview(mainVw)
        contentView.addSubview(titleLabel)
        contentView.backgroundColor = .backgroundColor
        NSLayoutConstraint.activate([
            mainVw.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            mainVw.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainVw.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            mainVw.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    func configure(withTitle title: String, image: UIImage?, indexPath: IndexPath) {
        self.indexPath = indexPath
        titleLabel.text = title
        mainVw.image = image
        
        if indexPath.section == 0 {
            NSLayoutConstraint.activate([
                titleLabel.heightAnchor.constraint(equalToConstant: 60),
                titleLabel.topAnchor.constraint(equalTo: mainVw.topAnchor, constant: 20),
                titleLabel.leadingAnchor.constraint(equalTo: mainVw.leadingAnchor, constant: 20)
            ])
        } else {
            NSLayoutConstraint.activate([
                titleLabel.heightAnchor.constraint(equalToConstant: 60),
                titleLabel.topAnchor.constraint(equalTo: mainVw.topAnchor, constant: 20),
                titleLabel.trailingAnchor.constraint(equalTo: mainVw.trailingAnchor, constant: -20)
            ])
        }
    }
}
