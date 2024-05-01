//
//  SearchTableViewCell.swift
//  Acupoint
//
//  Created by 林佑淳 on 2024/4/15.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
//    lazy var cellView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor.red
//        view.layer.cornerRadius = 10
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
    private var gradientLayer: CAGradientLayer?
    
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
//        label.textAlignment -
        label.font = UIFont(name: "ZenMaruGothic-Medium", size: 22)
        return label
    }()
    
    lazy var painNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "疼痛名稱"
        label.font = UIFont(name: "GenJyuuGothicX-Regular", size: 14)
        label.textColor = .gray
        return label
    }()

    //純code，UITableViewCell初始化方法
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupCell()
        self.selectionStyle = .none
        contentView.backgroundColor = .clear
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
    private let blurView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear // 確保 contentView 的背景色是透明的
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true // 設置為 true 以裁切超出圓角範圍的部分
        
        // 添加黑色陰影效果
        
        return view
    }()
    
    func setupCell() {
        // 創建一個新的 UIView 作為陰影容器
        let shadowView = UIView(frame: contentView.bounds)
        shadowView.backgroundColor = .clear
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.04
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
        shadowView.layer.shadowRadius = 4
        
        contentView.addSubview(shadowView)
        
        // 將 blurView 添加到陰影容器中
        
        shadowView.addSubview(blurView)
        
        contentView.addSubview(bookmarkBtn)
        contentView.addSubview(acupointNameLabel)
        contentView.addSubview(painNameLabel)
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            blurView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            blurView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            blurView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            blurView.topAnchor.constraint(equalTo: shadowView.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),
            
            bookmarkBtn.widthAnchor.constraint(equalToConstant: 30),
            bookmarkBtn.heightAnchor.constraint(equalToConstant: 30),
            bookmarkBtn.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            bookmarkBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            acupointNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            acupointNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            acupointNameLabel.widthAnchor.constraint(equalToConstant: 70),
            painNameLabel.centerYAnchor.constraint(equalTo: acupointNameLabel.centerYAnchor),
            painNameLabel.heightAnchor.constraint(equalToConstant: 60),
            painNameLabel.widthAnchor.constraint(equalToConstant: 200),
            painNameLabel.leadingAnchor.constraint(equalTo: acupointNameLabel.trailingAnchor, constant: 12),
            painNameLabel.trailingAnchor.constraint(equalTo: bookmarkBtn.leadingAnchor, constant: -12)
        ])
        
        gradientLayer = CAGradientLayer()
        gradientLayer?.colors = [UIColor(white: 0.95, alpha: 1.0).cgColor, UIColor.white.cgColor] // 設置漸層顏色從最淺的灰色到白色
        gradientLayer?.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer?.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer?.locations = [0, 0.5]// 調整 endPoint 以垂直方向漸變
        blurView.layer.insertSublayer(gradientLayer!, at: 0)
        
        contentView.backgroundColor = .red

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = blurView.bounds
    }
    func setupUI() {
//        contentView.addSubview(cellView)
        
        
        
        NSLayoutConstraint.activate([
           
//            cellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
//            cellView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
//            cellView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
//            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
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
