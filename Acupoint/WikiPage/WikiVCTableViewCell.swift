import UIKit

class WikiVCTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupCell()
        self.selectionStyle = .none
    }
    
    func setupCell() {
//        contentView.preservesSuperviewLayoutMargins = false
//        以確保 cell 的內容視圖的 layoutMargins 不受 tableView 的 layoutMargins 的影響。
//        layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
//        contentView.layer.cornerRadius = 30
//        contentView.layer.masksToBounds = true
        backgroundColor = .clear
        contentView.backgroundColor = .white
    }

}
