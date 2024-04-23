import UIKit
import CHGlassmorphismView

class HomeCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private let blurView: CHGlassmorphismView = {
        let blurView = CHGlassmorphismView()
        blurView.setTheme(theme: .light)
        blurView.setBlurDensity(with: 0.5)
        blurView.setDistance(2)
        return blurView
    }()
     
    func setupCell() {
//        layer.cornerRadius = 25
//        layer.masksToBounds = true
        blurView.translatesAutoresizingMaskIntoConstraints = false
        contentView.insertSubview(blurView, at: 0)
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: contentView.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
