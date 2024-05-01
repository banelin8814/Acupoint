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
    func configureHeadingOneLabel(withText text: String) {
        configureZenMaruGothic(withText: text, alignment: .left, lines: 1, size: 30)
    }
    
    func configureHeadingTwoLabel(withText text: String) {
        configureZenMaruGothic(withText: text, alignment: .left, lines: 1, size: 24)
    }
    
    func configureHeadingThreeLabel(withText text: String) {
        configureZenMaruGothic(withText: text, alignment: .left, lines: 1, size: 21)
    }
    
    func configureTextOneLabel(withText text: String) {
        configureGenJyuuGothicX(withText: text, alignment: .left, lines: 0, size: 18)
    }
    
    func configureTextTwoLabel(withText text: String) {
        configureGenJyuuGothicX(withText: text, alignment: .left, lines: 0, size: 15)
    }

    private func configureZenMaruGothic(withText newText: String, alignment: NSTextAlignment, lines: Int, size: CGFloat) {
        text = newText
        font = UIFont(name: "ZenMaruGothic-Medium", size: size)
        textAlignment = alignment
        numberOfLines = lines
        lineBreakMode = .byTruncatingTail
    }
    private func configureGenJyuuGothicX(withText newText: String, alignment: NSTextAlignment, lines: Int, size: CGFloat) {
        text = newText
        font = UIFont(name: "GenJyuuGothicX-Medium", size: size)
        textAlignment = alignment
        numberOfLines = lines
        lineBreakMode = .byTruncatingTail
    }
    
}

extension UIImageView {
    func configureCircleView(forImage: String, size: CGFloat) {
        image = UIImage(named: forImage)
        contentMode = .scaleAspectFill
        layer.masksToBounds = true
        layer.cornerRadius = size / 2
        clipsToBounds = true
    }
}
