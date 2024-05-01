//
//  ArchiveTableViewCell.swift
//  Acupoint
//
//  Created by 林佑淳 on 2024/4/19.
//

import UIKit

class ArchiveTableViewCell: UITableViewCell {
    
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
        bookmarkBtn.addTarget(nil, action: #selector(SearchTableViewCell.archiveButtonTapped), for: .touchUpInside)
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupArchiveBtn() {
        contentView.addSubview(bookmarkBtn)
        NSLayoutConstraint.activate([
            bookmarkBtn.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            bookmarkBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
}
