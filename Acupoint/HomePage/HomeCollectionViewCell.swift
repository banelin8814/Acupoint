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
    
    private let blurView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear // 確保 contentView 的背景色是透明的
        view.layer.cornerRadius = 25
        view.layer.masksToBounds = true // 設置為 true 以裁切超出圓角範圍的部分
        
        // 添加黑色陰影效果
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.02
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        
        return view
    }()
    
    func setupCell() {
        // 創建一個新的 UIView 作為陰影容器
        let shadowView = UIView(frame: contentView.bounds)
        shadowView.backgroundColor = .clear
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.02
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
        shadowView.layer.shadowRadius = 4
        
        contentView.addSubview(shadowView)
        
        // 將 blurView 添加到陰影容器中
        shadowView.addSubview(blurView)
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: shadowView.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor)
        ])
        
        gradientLayer = CAGradientLayer()
        gradientLayer?.colors = [UIColor(white: 0.95, alpha: 1.0).cgColor, UIColor.white.cgColor] // 設置漸層顏色從最淺的灰色到白色
        gradientLayer?.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer?.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer?.locations = [0, 0.5]// 調整 endPoint 以垂直方向漸變
        blurView.layer.insertSublayer(gradientLayer!, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = blurView.bounds
    }
}
