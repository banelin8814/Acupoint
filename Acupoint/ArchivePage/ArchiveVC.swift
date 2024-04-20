import UIKit

class ArchiveVC: UIViewController {
    
    private let archiveTableView = UITableView()
    
    private let faceVC = FaceVC()
    private let handVC = HandVC()
    
    var filterResult: [FaceAcupointModel] = []
    
    var theName: [AcupointName]?
    
    let service = SwiftDataService.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        archiveTableView.dataSource = self
        archiveTableView.delegate = self
        archiveTableView.register(ArchiveTableViewCell.self, forCellReuseIdentifier: "ArchiveTableViewCell")

        setupTableView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
            self.theName = self.service.fetchAcupointNames()
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
        
        let entityTODelete = theName?[indexPath.row]
        
        if let entity = entityTODelete {
            SwiftDataService.shared.acupointNameContainer?.mainContext.delete(entity)
            
            do {
                try SwiftDataService.shared.acupointNameContainer?.mainContext.save()
                
                theName?.remove(at: indexPath.row)
                
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
        return theName?.count ?? 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArchiveTableViewCell", for: indexPath) as? ArchiveTableViewCell else { return UITableViewCell() }
                
        if let name = theName?[indexPath.row].name {
            cell.textLabel?.text = name
        } else {
            cell.textLabel?.text = "non"
        }
        return cell
        
    }
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
////            archiveTableView.deselectRow(at: indexPath, animated: true)
//            
//
//            
//        } else if editingStyle == .insert {
//            print("++++")
//        }
//    }
    
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        //        self.tabBarController?.tabBar.isHidden = true
//        if indexPath.section == 0 {
//            self.navigationController?.pushViewController(faceVC, animated: true)
//            faceVC.thePoint = [faceAcupoints[indexPath.row]]
//            self.tabBarController?.tabBar.isHidden = true
//            
//        } else {
//            handVC.acupointIndex = indexPath.row
//            handVC.handPoint = [handAcupoints[indexPath.row]]
//            self.navigationController?.pushViewController(handVC, animated: true)
//            self.tabBarController?.tabBar.isHidden = true
//        }
//        
//    }
}
