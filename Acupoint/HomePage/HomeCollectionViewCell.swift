//
//  HomeCollectionViewCell.swift
//  Acupoint
//
//  Created by 林佑淳 on 2024/4/16.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        backgroundColor = .systemYellow
        layer.cornerRadius = 25
        layer.masksToBounds = true
    }
}
