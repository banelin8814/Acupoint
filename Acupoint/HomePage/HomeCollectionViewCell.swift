import UIKit
import CHGlassmorphismView

class HomeCollectionViewCell: UICollectionViewCell {
    
    private var gradientLayer: CAGradientLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        contentView.backgroundColor = .clear // 確保 contentView 的背景色是透明的
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let mainVw: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear // 確保 contentView 的背景色是透明的
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true // 設置為 true 以裁切超出圓角範圍的部分
        view.image = UIImage(named: "失眠")
        view.contentMode = .scaleAspectFill
        // 添加黑色陰影效果
    
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "失眠"
        label.font = UIFont(name: "GenJyuuGothicX-Medium", size: 22)
        label.textColor = .white
        return label
    }()
    
    func setupCell() {
        // 創建一個新的 UIView 作為陰影容器
       contentView.addSubview(mainVw)
        contentView.addSubview(titleLabel)

        // 將 blurView 添加到陰影容器中
        NSLayoutConstraint.activate([
            mainVw.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainVw.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainVw.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainVw.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: mainVw.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        
    }
}
