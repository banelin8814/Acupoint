import UIKit

class ArchiveTableViewCell: UITableViewCell {
    
    lazy var titleLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "ZenMaruGothic-Medium", size: 22)
        label.textColor = .black
        return label
    }()
    
//    lazy var descirbeLbl: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont(name: "GenJyuuGothicX-Regular", size: 14)
//        label.textColor = .black
//        return label
//    }()


    lazy var bookmarkBtn: UIButton = {
        let button = UIButton()
        //        let bookmarkTapped = false
        button.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        return button
    }()
    
    //純code，UITableViewCell初始化方法
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .backgroundColor
        setupArchiveBtn()
        bookmarkBtn.addTarget(nil, action: #selector(ArchiveVC.deleteAction(_:)), for: .touchUpInside)
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupArchiveBtn() {
        contentView.addSubview(titleLbl)
        contentView.addSubview(bookmarkBtn)
//        contentView.addSubview(descirbeLbl)

        NSLayoutConstraint.activate([
            bookmarkBtn.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            bookmarkBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleLbl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
//            descirbeLbl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            descirbeLbl.leadingAnchor.constraint(equalTo: titleLbl.trailingAnchor, constant: 20),
//            descirbeLbl.trailingAnchor.constraint(equalTo: bookmarkBtn.leadingAnchor, constant: -20)
//            descirbeLbl.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        ])
    }
    
    func setupLbl(_ name: String) {
        titleLbl.text = name
    }
}
