//
//  WikiVC.swift
//  Acupoint
//
//  Created by 林佑淳 on 2024/4/18.
//

import UIKit

struct AcupointGenre: Hashable {
    let title: String
    let genre: Section
}

enum Section: CaseIterable {
    case face
    case hand
}

class WikiVC: UIViewController {
    
    private var tableView: UITableView!
    //dataSource接受兩個泛型類型參數:Section(章節)和AcupointGenre(數據模型)。
    private var dataSource: UITableViewDiffableDataSource<Section, AcupointGenre>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight] //父視圖大小發生變化時如何自動調整自身的大小。
        view.addSubview(tableView)
        configDataSource()
        tableView.separatorStyle = .none
        tableView.delegate = self
    }
    
    func configDataSource() {
        
        dataSource = UITableViewDiffableDataSource<Section, AcupointGenre>(tableView: tableView) { (tableView, indexPath, model) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "WikiVCTableViewCell", for: indexPath)
            cell.textLabel?.text = model.title
            return cell
        }
        tableView.register(WikiVCTableViewCell.self, forCellReuseIdentifier: "WikiVCTableViewCell")
        
        // 創建snapshot
        var snapshot = NSDiffableDataSourceSnapshot<Section, AcupointGenre>()
        snapshot.appendSections(Section.allCases) //加入所有section
        
        let hand = [AcupointGenre(title: "臉部", genre: .hand)] //第一個section  genre就是拿來辨認是哪個section的
        let face = [AcupointGenre(title: "手部", genre: .hand)] //第二個section
        
        snapshot.appendItems(hand, toSection: .face) // 把item加到對應section
        snapshot.appendItems(face, toSection: .hand)
        
        dataSource.apply(snapshot, animatingDifferences: false)
        
    }
}

extension WikiVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height * 0.2
    }
}
