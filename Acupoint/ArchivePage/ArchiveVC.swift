import UIKit

class ArchiveVC: UIViewController {
    
    private let archiveTableView = UITableView()
    
    private let faceVC = FaceVC()
    private let handVC = HandVC()
    
//    var filterResult: [FaceAcupointModel] = []
    
    var archivePointName: [AcupointName]?
    // swiftdata
    let service = SwiftDataService.shared
    //Data
    var acupoitData = AcupointData.shared
    
    lazy var facePoints: [FaceAcupointModel] = {
        return acupoitData.faceAcupoints
    }()
    
    lazy var handPoints: [HandAcupointModel] = {
           return acupoitData.handAcupoints
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        archiveTableView.dataSource = self
        archiveTableView.delegate = self
        archiveTableView.register(ArchiveTableViewCell.self, forCellReuseIdentifier: "ArchiveTableViewCell")

        setupTableView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
            self.archivePointName = self.service.fetchAcupointNames()
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
    
    
    @objc func deleteAction(_ sender: UIButton) {

        let buttonPosition = sender.convert(CGPoint.zero, to: archiveTableView)
        guard let indexPath = archiveTableView.indexPathForRow(at:buttonPosition) else {
            return
        }
        
        let entityTODelete = archivePointName?[indexPath.row]
        
        if let entity = entityTODelete {
            SwiftDataService.shared.acupointNameContainer?.mainContext.delete(entity)
            
            do {
                try SwiftDataService.shared.acupointNameContainer?.mainContext.save()
                
                archivePointName?.remove(at: indexPath.row)
                
                archiveTableView.deleteRows(at: [indexPath], with: .fade)
                self.archiveTableView.reloadData()

                
            } catch {
                print("Error deleting entity: \(error)")
            }
        }
    }
}

extension ArchiveVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return archivePointName?.count ?? 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArchiveTableViewCell", for: indexPath) as? ArchiveTableViewCell else { return UITableViewCell() }
        
        if let name = archivePointName?[indexPath.row].name {
            cell.textLabel?.text = name
        } else {
            cell.textLabel?.text = "non"
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        self.tabBarController?.tabBar.isHidden = true
        if let index = facePoints.firstIndex(where: { $0.name == archivePointName?[indexPath.row].name }) {
            faceVC.selectedIndex = indexPath.row
            faceVC.selectedFacePoint = [facePoints[index]]
            faceVC.currentDisplayMode = .specific(name: facePoints[indexPath.row].name)
            faceVC.collectionView.reloadData()
            self.navigationController?.pushViewController(faceVC, animated: true)
            self.tabBarController?.tabBar.isHidden = true
            
        } else if let index = handPoints.firstIndex(where: { $0.name == archivePointName?[indexPath.row].name }) {
            //負責給collectionView內容
            handVC.currentDisplayMode = .specific(name: handPoints[index].name)
            //負責指定一個點給handPoints if handPoints.count == 1
            handVC.handPoints = [handPoints[index]]
            //負責給畫點的位置 selectedAcupointPosition = handAcupoints[self.acupointIndex].position
            handVC.acupointIndex = index
            handVC.handSideSegmentedControl.isHidden = true
            handVC.collectionView.reloadData()
            self.navigationController?.pushViewController(handVC, animated: true)
            self.tabBarController?.tabBar.isHidden = true
        } else {
            
        }
    }
}
