import UIKit

class SearchVC: UIViewController {
    
    private let searchTableView = UITableView()
    
    private let faceVC = FaceVC()
    private let handVC = HandVC()
    //    private let searchController = UISearchController(searchResultsController: nil)
    
//    var allAcupoints: [FaceAcupointModel]?
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "SearchTableViewCell")
        setupTableView()
        //        setupSearchController()
//        let service = SwiftDataService.shared
//        service.saveDefaultAcupoints(faceAcupoints)
        // 從 SwiftData 取得所有穴位資料
//        allAcupoints = service.fetchAcupoints()
    }
    
    func setupTableView() {
        view.addSubview(searchTableView)
        searchTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchTableView.topAnchor.constraint(equalTo: view.topAnchor),
            searchTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            searchTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    //    func setupSearchController() {
    //        self.searchController.searchResultsUpdater = self
    //        self.searchController.obscuresBackgroundDuringPresentation = false
    //        self.searchController.hidesNavigationBarDuringPresentation = false
    //        self.searchController.searchBar.searchBarStyle = .prominent
    //
    //        self.searchController.searchBar.placeholder = "輸入穴位，或疼痛部位"
    //        self.navigationItem.searchController = searchController
    //        self.definesPresentationContext = false
    //        self.navigationItem.hidesSearchBarWhenScrolling = true
    //        //        self.searchTableView.tableHeaderView = self.searchController.searchBar
    //        self.navigationItem.titleView = searchController.searchBar
    //    }
    //    func filterContent(for searchText: String) {
    //        filterResult = faceAcupoints.filter({ (filterArray) -> Bool in
    //            let words = filterArray
    //            let isMach = words.name.localizedCaseInsensitiveContains(searchText)
    //            return isMach
    //        })
    //    }
}

//extension SearchVC: UISearchResultsUpdating, UISearchBarDelegate {
//    func updateSearchResults(for searchController: UISearchController) {
//        if let searchText = searchController.searchBar.text {
//            if searchText.isEmpty {
//                filterResult = faceAcupoints
//            } else {
//                filterContent(for: searchText)
//            }
//            searchTableView.reloadData()
//        }
//    }
//}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        if (self.searchController.isActive) {
        //            return self.filterResult.count
        //        } else {
        if section == 0 {
            return faceAcupoints.count
        } else {
            return handAcupoints.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell() }
        //        if (self.searchController.isActive) {
        //            cell.textLabel?.text = filterResult[indexPath.row].name
        //            return cell
        //        } else {
        if indexPath.section == 0 {
            cell.textLabel?.text = faceAcupoints[indexPath.row].name
        } else {
            cell.textLabel?.text = handAcupoints[indexPath.row].name
        }
        return cell
        //        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        self.tabBarController?.tabBar.isHidden = true
        if indexPath.section == 0 {
            self.navigationController?.pushViewController(faceVC, animated: true)
            faceVC.thePoint = [faceAcupoints[indexPath.row]]
            
        } else {
            handVC.acupointIndex = indexPath.row
            handVC.handPoint = handAcupoints[indexPath.row]
            self.navigationController?.pushViewController(handVC, animated: true)
        }
        
    }
    
    @objc func saveAction(_ sender: UIButton) {
        //用convert得到button的indextPath：簡單說是用button的位置得到indexPath
        let buttonPosition = sender.convert(CGPoint.zero, to: searchTableView)
        guard let indexPath = searchTableView.indexPathForRow(at:buttonPosition) else {
            return
        }
        let name: String
        
           if indexPath.section == 0 {
               guard indexPath.row < faceAcupoints.count else {
                   return
               }
               let acupoint = faceAcupoints[indexPath.row]
               name = acupoint.name
           } else {
               guard indexPath.row < handAcupoints.count else {
                   return
               }
               let acupoint = handAcupoints[indexPath.row]
               name = acupoint.name
           }
        print("button被點了")
        SwiftDataService.shared.checkAcupointNames(name)

//        SwiftDataService.shared.saveAcupointName(name)
    }
}



//有名字就刪除，沒名字就儲存
