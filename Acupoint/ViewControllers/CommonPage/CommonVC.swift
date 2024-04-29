//
//  CommonVC.swift
//  Acupoint
//
//  Created by 林佑淳 on 2024/4/26.
//

import UIKit

class CommonVC: UIViewController {
    
    let cellColors: [String] = ["dc9646", "406f7e", "d47764", "93b9b2"]
    
    let cellTitle: [String] = ["太陽穴", "太陽穴", "太陽穴", "太陽穴"]
    
    let screenHeight = UIScreen.main.bounds.size.height

    lazy var titleLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "助眠穴位"
        label.font = UIFont(name: "ZenMaruGothic-Medium", size: 30)
        label.textColor = .white
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "頭痛")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var contentLbl: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "穴位按摩能調節自律神經系統，減少交感神經活動，提高副交感神經活動，幫助我們放鬆入睡。給自己的穴位來個放鬆的按摩吧，讓這些神奇的穴道帶你進入甜美夢鄉！"
        label.font = UIFont(name: "GenJyuuGothicX-Medium", size: 16)
        label.backgroundColor = .clear
        return label
    }()


    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.register(CommonCollectionViewCell.self, forCellWithReuseIdentifier: "CommonCollectionViewCell")
        
        func collectionViewLayout() -> UICollectionViewLayout {

            let galleryItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                        heightDimension: .fractionalHeight(1.0)))
            galleryItem.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
            let galleryGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.58),
                                                                                            heightDimension: .fractionalHeight(1)),
                                                                  subitems: [galleryItem])
            let gallerySection = NSCollectionLayoutSection(group: galleryGroup)
            gallerySection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
            gallerySection.orthogonalScrollingBehavior = .continuous
            let layout = UICollectionViewCompositionalLayout(section: gallerySection)
            return layout
            
        }
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        view.addSubview(imageView)
        view.addSubview(contentLbl)
        view.addSubview(titleLbl)
        setupUI()
        view.backgroundColor = UIColor.hexStringToUIColor(theHex: "#F4F1E8")
    }
    
    func setupUI() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: screenHeight * 0.35),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            titleLbl.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 20),
            titleLbl.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -20),
            
            contentLbl.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            contentLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            contentLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            contentLbl.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -20),
            
            collectionView.heightAnchor.constraint(equalToConstant: screenHeight * 0.26),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
}

extension CommonVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //用if let寫cell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommonCollectionViewCell", for: indexPath) as? CommonCollectionViewCell else {
            return CommonCollectionViewCell() }
//        cell.backgroundColor = UIColor.hexStringToUIColor(theHex: colors[indexPath.row])
        var theColor = UIColor.hexStringToUIColor(theHex: cellColors[indexPath.row])
//
        cell.setupCell(theColor, cellTitle[indexPath.row])
        // 使用 cell 進行設定
        return cell
        
    }
}
