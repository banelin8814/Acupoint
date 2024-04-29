import UIKit

extension UIView {
    
    func applyBlackGradient(startAlpha: CGFloat, endAlpha: CGFloat) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.black.withAlphaComponent(startAlpha).cgColor,
                                UIColor.black.withAlphaComponent(endAlpha).cgColor]
        gradientLayer.locations = [0.0, 1.0]
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func applyWhiteGradient(startAlpha: CGFloat, endAlpha: CGFloat) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.white.withAlphaComponent(startAlpha).cgColor,
                                UIColor.white.withAlphaComponent(endAlpha).cgColor]
        gradientLayer.locations = [0.0, 1.0]
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
