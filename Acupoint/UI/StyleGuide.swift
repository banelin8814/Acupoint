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
    static let BlueTitleColor = UIColor(hex: "406f7e")
    static let lightSubtitleTextColor: UIColor = UIColor.white.withAlphaComponent(0.8)
    static let darkTitleTextColor: UIColor = .black
    static let lightTitleTextColor: UIColor = .white
    static let darkSubtitleTextColor: UIColor = .gray
}

extension UILabel {
    func configureHeadingOneLabel(withText text: String) {
        configureZenMaruGothic(withText: text, alignment: .left, lines: 1, size: 42)
    }

    func configureHeadingTwoLabel(withText text: String) {
        configureZenMaruGothic(withText: text, alignment: .left, lines: 1, size: 32)
    }

    func configureHeadingThreeLabel(withText text: String) {
        configureZenMaruGothic(withText: text, alignment: .left, lines: 1, size: 26)
    }

    func configureTextOneLabel(withText text: String) {
        configureGenJyuuGothicX(withText: text, alignment: .left, lines: 0, size: 20)
    }

    func configureTextTwoLabel(withText text: String) {
        configureGenJyuuGothicX(withText: text, alignment: .left, lines: 0, size: 18)
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
