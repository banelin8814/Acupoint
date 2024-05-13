import UIKit

class WikiVCTableViewCell: UITableViewCell {
    
    var indexPath: IndexPath?
    
    
    let mainVw: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
        // 確保 contentView 的背景色是透明的
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true // 設置為 true 以裁切超出圓角範圍的部分
        view.image = UIImage(named: "")
        view.contentMode = .scaleAspectFill
        // 添加黑色陰影效果
        
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        // 創建一個新的 UIView 作為陰影容器
        contentView.addSubview(mainVw)
        contentView.addSubview(titleLabel)
        contentView.backgroundColor = .backgroundColor
        
        // 將 blurView 添加到陰影容器中
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
        
        // 在这里根据 indexPath 设置 titleLabel 的位置
        if indexPath.section == 0 {
            // 第一个 section，titleLabel 靠左
            NSLayoutConstraint.activate([
                titleLabel.heightAnchor.constraint(equalToConstant: 60),
                titleLabel.topAnchor.constraint(equalTo: mainVw.topAnchor, constant: 20),
                titleLabel.leadingAnchor.constraint(equalTo: mainVw.leadingAnchor, constant: 20)
            ])
        } else {
            // 第二个 section，titleLabel 靠右
            NSLayoutConstraint.activate([
                titleLabel.heightAnchor.constraint(equalToConstant: 60),
                titleLabel.topAnchor.constraint(equalTo: mainVw.topAnchor, constant: 20),
                titleLabel.trailingAnchor.constraint(equalTo: mainVw.trailingAnchor, constant: -20)
            ])
        }
    }
}
