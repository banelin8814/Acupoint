import UIKit

enum BackgroundType: String {
    case light
    case dark
    
    var titleTextColor: UIColor {
        switch self {
        case .dark:
            return .lightTitleTextColor
        case .light:
            return .darkTitleTextColor
        }
    }
    
    var subtitleTextColor: UIColor {
        switch self {
        case .dark:
            return .lightSubtitleTextColor
        case .light:
            return .darkSubtitleTextColor
        }
    }
}

extension UIColor {
    static let backgroundColor = UIColor(hex: "#F4F1E8")
    static let lightSubtitleTextColor: UIColor = UIColor.white.withAlphaComponent(0.8)
    static let lightTitleTextColor: UIColor = .white
    static let darkSubtitleTextColor: UIColor = .gray
    static let darkTitleTextColor: UIColor = .black
}

extension UILabel {
    func configureHeaderLabel(withText text: String) {
        configure(withText: text, alignment: .left, lines: 1)
    }


    private func configure(withText newText: String, alignment: NSTextAlignment, lines: Int) {
        text = newText
        font = UIFont(name: "ZenMaruGothic-Medium", size: 30.0)
        textAlignment = alignment
        numberOfLines = lines
        lineBreakMode = .byTruncatingTail
    }
}

extension UIImageView {
    func configureCircleView(forImage: String, size: CGFloat) {
        image = UIImage(named: forImage)
        contentMode = .scaleAspectFit
        layer.masksToBounds = true
        layer.cornerRadius = size / 2
        clipsToBounds = true
    }
}
