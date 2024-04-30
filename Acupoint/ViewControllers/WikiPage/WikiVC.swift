import UIKit

struct AcupointGenre: Hashable {
    let title: String
    let genre: Section
}

enum Section: CaseIterable {
    case face
    case hand
}

class WikiVC: BaseVC {
    
    lazy var commonPointLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configureHeadingOneLabel(withText: "穴位小百科")
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .backgroundColor
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight] //父視圖大小發生變化時如何自動調整自身的大小。
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = true
        //        tableView.sec
        tableView.delegate = self
        return tableView
    }()
    //dataSource接受兩個泛型類型參數:Section(章節)和AcupointGenre(數據模型)。
    private var dataSource: UITableViewDiffableDataSource<Section, AcupointGenre>?
    
    private let faceVC = FaceVC()
    private let handVC = HandVC()
    
    var acupoitData = AcupointData.shared
    
    lazy var facePoints: [FaceAcupointModel] = {
        return acupoitData.faceAcupoints
    }()
    
    lazy var handPoints: [HandAcupointModel] = {
        return acupoitData.handAcupoints
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.addSubview(commonPointLbl)
        
        configDataSource()
        setupUI()
    }
    
    func setupUI() {
        NSLayoutConstraint.activate([
            commonPointLbl.heightAnchor.constraint(equalToConstant: 40),
            commonPointLbl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            commonPointLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            tableView.topAnchor.constraint(equalTo: commonPointLbl.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    //    func configDataSource() {
    //
    //        dataSource = UITableViewDiffableDataSource<Section, AcupointGenre>(tableView: tableView) { (tableView, indexPath, model) -> UITableViewCell? in
    //            let cell = tableView.dequeueReusableCell(withIdentifier: "WikiVCTableViewCell", for: indexPath)
    //            cell.textLabel?.text = model.title
    //            return cell
    //        }
    //        tableView.register(WikiVCTableViewCell.self, forCellReuseIdentifier: "WikiVCTableViewCell")
    //
    //        // 創建snapshot
    //        var snapshot = NSDiffableDataSourceSnapshot<Section, AcupointGenre>()
    //        snapshot.appendSections(Section.allCases) //加入所有section
    //
    //        let hand = [AcupointGenre(title: "臉部", genre: .hand)] //第一個section  genre就是拿來辨認是哪個section的
    //        let face = [AcupointGenre(title: "手部", genre: .hand)] //第二個section
    //
    //        snapshot.appendItems(hand, toSection: .face) // 把item加到對應section
    //        snapshot.appendItems(face, toSection: .hand)
    //
    //        dataSource.apply(snapshot, animatingDifferences: false)
    //    }
    func configDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, AcupointGenre>(tableView: tableView) { (tableView, indexPath, model) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WikiVCTableViewCell", for: indexPath) as? WikiVCTableViewCell else { return WikiVCTableViewCell() }
            cell.indexPath = indexPath
            // 根據 model 的屬性設置 cell 的內容
            cell.titleLabel.text = model.title
            
            // 可以根據 model 的 genre 屬性設置不同的樣式或內容
            switch model.genre {
            case .face:
                cell.mainVw.image = UIImage(named: "臉部")
            case .hand:
                cell.mainVw.image = UIImage(named: "手部")
            }
            return cell
        }
        
        tableView.register(WikiVCTableViewCell.self, forCellReuseIdentifier: "WikiVCTableViewCell")
        
        // 創建 snapshot
        var snapshot = NSDiffableDataSourceSnapshot<Section, AcupointGenre>()
        snapshot.appendSections(Section.allCases)
        
        let hand = [AcupointGenre(title: "臉 部", genre: .face)]
        let face = [AcupointGenre(title: "手 部", genre: .hand)]
        
        snapshot.appendItems(hand, toSection: .face)
        snapshot.appendItems(face, toSection: .hand)
        
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}


extension WikiVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.navigationController?.pushViewController(faceVC, animated: true)
            self.tabBarController?.tabBar.isHidden = true
            
            faceVC.selectedFacePoint = facePoints
            faceVC.currentDisplayMode = .allPoint
            faceVC.collectionView.reloadData()
            
        } else {
            handVC.currentDisplayMode = .allPoint
            handVC.handSideSegmentedControl.isHidden = false
//            handVC.handPoints = self.handPoints
            handVC.numberOfAcupoints = self.handPoints.count
            self.navigationController?.pushViewController(handVC, animated: true)
            self.tabBarController?.tabBar.isHidden = true
            
        }
    }
}
