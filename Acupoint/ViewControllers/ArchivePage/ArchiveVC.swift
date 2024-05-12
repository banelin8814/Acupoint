import UIKit
import FirebaseAuth

class ArchiveVC: BaseVC {
        
    private let archiveTableView = UITableView()
    
    private let faceVC = FaceVC()
    private let handVC = HandVC()
    
//    var filterResult: [FaceAcupointModel] = []
    
    var archivePointName: [AcupointName]?
    // swiftdata
    let swiftDataService = SwiftDataService.shared
    //Data
    var acupointData = AcupointData.shared
    
    lazy var facePoints: [FaceAcupointModel] = {
        return acupointData.faceAcupoints
    }()
    
    lazy var handPoints: [HandAcupointModel] = {
           return acupointData.handAcupoints
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .white
        navigationItem.title = "收藏穴位"
        
        archiveTableView.separatorStyle = .singleLine
        archiveTableView.dataSource = self
        archiveTableView.delegate = self
        archiveTableView.register(ArchiveTableViewCell.self, forCellReuseIdentifier: "ArchiveTableViewCell")
        archiveTableView.backgroundColor = .backgroundColor
        setupTableView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
            self.archivePointName = self.swiftDataService.fetchAcupointNames()
            self.archiveTableView.reloadData()
    }
    
    func setupTableView() {
        view.addSubview(archiveTableView)
        archiveTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            archiveTableView.topAnchor.constraint(equalTo: view.topAnchor),
            archiveTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            archiveTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            archiveTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    //點擊bookmark
    @objc func deleteAction(_ sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: archiveTableView)
        guard let indexPath = archiveTableView.indexPathForRow(at: buttonPosition) else {
            return
        }
        
        let entityToDelete = archivePointName?[indexPath.row]
        
        if let entity = entityToDelete {
            SwiftDataService.shared.acupointNameContainer?.mainContext.delete(entity)
            do {
                try SwiftDataService.shared.acupointNameContainer?.mainContext.save()
                
                archivePointName?.remove(at: indexPath.row)
                
                archiveTableView.deleteRows(at: [indexPath], with: .fade)
                self.archiveTableView.reloadData()
                
                // 從 Firebase 中刪除穴位名字
                if let userId = Auth.auth().currentUser?.uid {
                    FirebaseManager.shared.deleteAcupointNameFromUserSubcollection(entity.name, userId: userId) { [weak self] result in
                        switch result {
                        case .success:
                            print("穴位從 Firebase 使用者子集合中刪除成功")
                        case .failure(let error):
                            print("穴位從 Firebase 使用者子集合中刪除失敗: \(error.localizedDescription)")
                            // 如果從 Firebase 中刪除失敗，您可以選擇是否需要將其重新加入到 SwiftData 中
                            // self?.swiftDataService.saveAcupointName(name)
                        }
                    }
                }
            } catch {
                print("Error deleting entity: \(error)")
            }
        }
    }
}

extension ArchiveVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return archivePointName?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArchiveTableViewCell", for: indexPath) as? ArchiveTableViewCell else { return UITableViewCell() }
        
        if let name = archivePointName?[indexPath.row].name {
//            cell.textLabel?.text = name
            cell.setupLbl(name)
        } else {
            cell.textLabel?.text = "non"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        self.tabBarController?.tabBar.isHidden = true
        if let index = facePoints.firstIndex(where: { $0.name == archivePointName?[indexPath.row].name }) {
            faceVC.selectedIndex = index
            faceVC.selectedFacePoint = [facePoints[index]]
            faceVC.currentDisplayMode = .specific(name: facePoints[indexPath.row].name)
            faceVC.selectedNameByCell = facePoints[index].name
            faceVC.collectionView.reloadData()
            self.navigationController?.pushViewController(faceVC, animated: true)
            self.tabBarController?.tabBar.isHidden = true
            
        } else if let index = handPoints.firstIndex(where: { $0.name == archivePointName?[indexPath.row].name }) {
            //Mark:更改進入handvc的邏輯

            handVC.numberOfAcupoints = 1
            handVC.currentDisplayMode = .specific(name: handPoints[index].name)
            handVC.handPoints = [handPoints[index]]
            handVC.acupointIndex = index
            
            
            handVC.handSideSegmentedControl.isHidden = true
            handVC.collectionView.reloadData()
            self.navigationController?.pushViewController(handVC, animated: true)
            self.tabBarController?.tabBar.isHidden = true
        } else {
            
        }
    }
}
