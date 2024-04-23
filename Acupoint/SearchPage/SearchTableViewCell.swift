//
//  SearchTableViewCell.swift
//  Acupoint
//
//  Created by 林佑淳 on 2024/4/15.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    lazy var bookmarkBtn: UIButton = {
        let button = UIButton()
        //        let bookmarkTapped = false
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(archiveButtonTapped), for: .touchUpInside)
        button.addTarget(nil, action: #selector(SearchVC.saveAction(_:)), for: .touchUpInside)

        button.tintColor = .black
        return button
    }()
    
    lazy var acupointNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "穴位名稱"
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    lazy var painNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "疼痛名稱"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    //純code，UITableViewCell初始化方法
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        
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
    
    func setupUI() {
        contentView.addSubview(bookmarkBtn)
        contentView.addSubview(acupointNameLabel)
        contentView.addSubview(painNameLabel)

        NSLayoutConstraint.activate([
            bookmarkBtn.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            bookmarkBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            acupointNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            acupointNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            painNameLabel.centerYAnchor.constraint(equalTo: acupointNameLabel.centerYAnchor),
            painNameLabel.heightAnchor.constraint(equalToConstant: 60),
            painNameLabel.widthAnchor.constraint(equalToConstant: 200),
            painNameLabel.leadingAnchor.constraint(equalTo: acupointNameLabel.trailingAnchor, constant: 10),
//            painNameLabel.trailingAnchor.constraint(equalTo: bookmarkBtn.leadingAnchor, constant: -12)

        ])
    }
    
    @objc func archiveButtonTapped() {
        bookmarkBtn.isSelected.toggle()
        if bookmarkBtn.isSelected {
            bookmarkBtn.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            //儲存
        } else {
            bookmarkBtn.setImage(UIImage(systemName: "bookmark"), for: .normal)
            //刪除
        }
    }
}
