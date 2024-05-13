import UIKit
import FirebaseAuth

class SearchVC: BaseVC {
    
    private let searchTableView = UITableView()
    
    private let faceVC = FaceVC()
    private let handVC = HandVC()
    private let archiveVC = ArchiveVC()
    
    let acupoitData = AcupointData.shared
    let swiftDataService = SwiftDataService.shared
    let firebaseManager = FirebaseManager.shared
    
    var archivePointNames: [AcupointName]?
    
    lazy var facePoints: [FaceAcupointModel] = {
        return acupoitData.faceAcupoints
    }()
    
    lazy var handPoints: [HandAcupointModel] = {
        return acupoitData.handAcupoints
    }()
    
    let searchController = UISearchController()
    //combine
    @Published var isArchiveEnable: Bool = false
    
    var searchResults: [Any] = [] //因為有兩種model所以放Any
    
    lazy var bookmarkBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(archiveButtonTapped), for: .touchUpInside)
        button.tintColor = .black
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //combine
        AuthManager.shared.$isLoggedIn
            .assign(to: &$isArchiveEnable)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "ZenMaruGothic-Medium", size: 38) ?? 38,
            .foregroundColor: UIColor.black
        ]
        navigationController?.navigationBar.largeTitleTextAttributes = attributes
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .black
        
        navigationItem.title = "尋找穴位"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
        //5/8:先準備上架，不把加入進去bookmarkButton，之後再加回來5/8
        let bookmarkButton = UIBarButtonItem(customView: bookmarkBtn)
        navigationItem.rightBarButtonItem = bookmarkButton
        
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchTableView.separatorStyle = .none
        searchTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "SearchTableViewCell")
        searchTableView.backgroundColor = .backgroundColor
        
        setupTableView()
        setupSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDataFromFirebaseToSwiftData()
        navigationController?.navigationBar.prefersLargeTitles = true
        self.archivePointNames = self.swiftDataService.fetchAcupointNames()
        searchTableView.reloadData()
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "輸入穴位，或疼痛部位"
        searchController.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func setupTableView() {
        view.addSubview(searchTableView)
        searchTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            searchTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc func archiveButtonTapped() {
        if isArchiveEnable {
            self.navigationController?.pushViewController(archiveVC, animated: true)
        } else {
            popUpLoginPage()
        }
    }
}

extension SearchVC: UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            searchResults = facePoints.filter { $0.name.contains(searchText) || $0.effect.contains(searchText)}
            searchResults += handPoints.filter { $0.name.contains(searchText) || $0.effect.contains(searchText)}
        } else {
            searchResults.removeAll()
        }
        self.archivePointNames = self.swiftDataService.fetchAcupointNames()
        searchTableView.reloadData()
    }
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return searchResults.count
        } else {
            if section == 0 {
                return facePoints.count
            } else {
                return handPoints.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell() }
        
        cell.loginDelegate = self
        cell.searchDelegate = self
        cell.contentView.backgroundColor = .backgroundColor
        cell.selectionStyle = .none
        
        if searchController.isActive {
            if let result = searchResults[indexPath.row] as? FaceAcupointModel {
                cell.acupointNameLabel.text = result.name
                cell.painNameLabel.text = result.effect
                
            } else  if let result = searchResults[indexPath.row] as? HandAcupointModel {
                cell.acupointNameLabel.text = result.name
                cell.painNameLabel.text = result.effect
            }
        } else {
            if indexPath.section == 0 {
                cell.acupointNameLabel.text = facePoints[indexPath.row].name
                cell.painNameLabel.text = facePoints[indexPath.row].effect
            } else {
                cell.acupointNameLabel.text = handPoints[indexPath.row].name
                cell.painNameLabel.text = handPoints[indexPath.row].effect
            }
        }
        
        if let archivePointName = archivePointNames,
           let acupointName = cell.acupointNameLabel.text,
           archivePointName.contains(where: { $0.name == acupointName }) {
            cell.bookmarkBtn.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        } else {
            cell.bookmarkBtn.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if searchController.isActive {
            return 1
        } else {
            return 2
        }
    }
    //Mark:更改進入handvc的邏輯
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if searchController.isActive {
//            if let result = searchResults as? [FaceAcupointModel] {
//                if let index = facePoints.firstIndex(where: { $0.name == result[indexPath.row].name }) {
//                    self.navigationController?.pushViewController(faceVC, animated: true)
//                    faceVC.selectedFacePoint = [facePoints[index]]
//                    faceVC.selectedIndex = index
//                    //getNameByIndex會從indexPath.row得到名字
//                    //            faceVC.getNameByIndex(indexPath.row)
//                    faceVC.selectedNameByCell = facePoints[index].name
//                    faceVC.currentDisplayMode = .specific(name: facePoints[index].name)
//                    faceVC.collectionView.reloadData()
//                    self.tabBarController?.tabBar.isHidden = true
//                }
//            } else if let result = searchResults as? [HandAcupointModel] {
//                //Mark:更改進入handvc的邏輯
//                if let index = handPoints.firstIndex(where: { $0.name == result[indexPath.row].name }) {
//                    handVC.acupointIndex = index
//                    handVC.currentDisplayMode = .specific(name: handPoints[index].name)
//                    handVC.numberOfAcupoints = 1                    
//                    handVC.collectionView.reloadData()
//                    handVC.handSideSegmentedControl.isHidden = true
//                    self.navigationController?.pushViewController(handVC, animated: true)
//                    self.tabBarController?.tabBar.isHidden = true
//                }
//            }
//        } else {
        if searchController.isActive {
                if let result = searchResults[indexPath.row] as? FaceAcupointModel {
                    if let index = facePoints.firstIndex(where: { $0.name == result.name }) {
                        self.navigationController?.pushViewController(faceVC, animated: true)
                        faceVC.selectedFacePoint = [facePoints[index]]
                        faceVC.selectedIndex = index
                        faceVC.selectedNameByCell = facePoints[index].name
                        faceVC.currentDisplayMode = .specific(name: facePoints[index].name)
                        faceVC.collectionView.reloadData()
                        self.tabBarController?.tabBar.isHidden = true
                    }
                } else if let result = searchResults[indexPath.row] as? HandAcupointModel {
                    if let index = handPoints.firstIndex(where: { $0.name == result.name }) {
                        handVC.acupointIndex = index
                        handVC.currentDisplayMode = .specific(name: handPoints[index].name)
                        handVC.numberOfAcupoints = 1
                        handVC.collectionView.reloadData()
                        handVC.handSideSegmentedControl.isHidden = true
                        self.navigationController?.pushViewController(handVC, animated: true)
                        self.tabBarController?.tabBar.isHidden = true
                    }
                }
            } else {
            if indexPath.section == 0 {
                self.navigationController?.pushViewController(faceVC, animated: true)
                faceVC.selectedFacePoint = [facePoints[indexPath.row]]
                faceVC.selectedIndex = indexPath.row
                //getNameByIndex會從indexPath.row得到名字
                //            faceVC.getNameByIndex(indexPath.row)
                faceVC.selectedNameByCell = facePoints[indexPath.row].name
                faceVC.currentDisplayMode = .specific(name: facePoints[indexPath.row].name)
                faceVC.collectionView.reloadData()
                self.tabBarController?.tabBar.isHidden = true
            } else {
                //Mark:更改進入handvc的邏輯
                handVC.acupointIndex = indexPath.row
                handVC.currentDisplayMode = .specific(name: handPoints[indexPath.row].name)
                handVC.numberOfAcupoints = 1
                
                
                handVC.collectionView.reloadData()
                handVC.handSideSegmentedControl.isHidden = true
                self.navigationController?.pushViewController(handVC, animated: true)
                self.tabBarController?.tabBar.isHidden = true
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "面部穴位"
        } else {
            return "手部穴位"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if searchController.isActive {
            return 0
        } else {
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func saveAction(_ sender: UIButton) {
        if AuthManager.shared.isLoggedIn {
            if isArchiveEnable {
                
                var name: String?
                if searchController.isActive {
                    let buttonPosition = sender.convert(CGPoint.zero, to: searchTableView)
                    guard let indexPath = searchTableView.indexPathForRow(at:buttonPosition) else {
                        return
                    }
                    if let result = searchResults[indexPath.row] as? FaceAcupointModel {
                        name = result.name
                    } else if let result = searchResults[indexPath.row] as? HandAcupointModel {
                        name = result.name
                    }
                } else {
                    //用convert得到button的indextPath：簡單說是用button的位置得到indexPath
                    let buttonPosition = sender.convert(CGPoint.zero, to: searchTableView)
                    guard let indexPath = searchTableView.indexPathForRow(at:buttonPosition) else {
                        return
                    }
                    if indexPath.section == 0 {
                        guard indexPath.row < facePoints.count else {
                            return
                        }
                        let acupoint = facePoints[indexPath.row]
                        name = acupoint.name
                    } else {
                        guard indexPath.row < handPoints.count else {
                            return
                        }
                        let acupoint = handPoints[indexPath.row]
                        name = acupoint.name
                    }
                }
                if let name = name, let userId = Auth.auth().currentUser?.uid {
                    // 檢查穴位名字是否已經存在於使用者的子集合中
                    FirebaseManager.shared.fetchAcupointNamesFromUserSubcollection(userId: userId) { [weak self] result in
                        switch result {
                        case .success(let acupointNames):
                            if acupointNames.contains(name) {
                                // 如果存在，則從 Firebase 和 SwiftData 中刪除
                                FirebaseManager.shared.deleteAcupointNameFromUserSubcollection(name, userId: userId) { result in
                                    switch result {
                                    case .success:
                                        print("穴位從 Firebase 使用者子集合中刪除成功")
                                        SwiftDataService.shared.checkAcupointNames(name)
                                        self?.fetchDataFromFirebaseToSwiftData()
//                                        self?.searchTableView.reloadData()
                                    case .failure(let error):
                                        print("穴位從 Firebase 使用者子集合中刪除失敗: \(error.localizedDescription)")
                                    }
                                }
                            } else {
                                // 如果不存在，則儲存到 Firebase 和 SwiftData 中
                                FirebaseManager.shared.saveAcupointNameToUserSubcollection(name, userId: userId) { result in
                                    switch result {
                                    case .success:
                                        print("穴位保存到 Firebase 使用者子集合成功")
                                        SwiftDataService.shared.checkAcupointNames(name)
                                        self?.fetchDataFromFirebaseToSwiftData()
                                    case .failure(let error):
                                        print("穴位保存到 Firebase 使用者子集合失敗: \(error.localizedDescription)")
                                    }
                                }
                            }
                        case .failure(let error):
                            print("從 Firebase 獲取使用者的儲存穴位失敗: \(error.localizedDescription)")
                        }
                    }
                }
            } else {
                print("pleaseLogin")
            }
        } else {
            let loginPage = LoginVC()
            present(loginPage, animated: true, completion: nil)
        }
    }
    
    func fetchDataFromFirebaseToSwiftData() {
        if AuthManager.shared.isLoggedIn {
            if let userId = Auth.auth().currentUser?.uid {
                FirebaseManager.shared.fetchAcupointNamesFromUserSubcollection(userId: userId) { result in
                    switch result {
                    case .success(let acupointNames):
                        SwiftDataService.shared.deleteAllAcupointNames()
                        for name in acupointNames {
                            SwiftDataService.shared.saveAcupointName(name)
                        }
                        self.archivePointNames = self.swiftDataService.fetchAcupointNames()
                        self.searchTableView.reloadData()
                    case .failure(let error):
                        print("從firebase獲得使用者的儲存的穴位: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}

extension SearchVC: SearchTableViewCellDelegate {
    func reuse() {
        searchTableView.reloadData()
    }
    
    func searchTableViewCell(_ cell: UITableViewCell, _ button: UIButton) {
        saveAction(button)
    }
}

extension SearchVC: LoginDelegate {
    func popUpLoginPage() {
        let loginVC = LoginVC()
        loginVC.descibeTitle.text = "請登入使用收藏功能"
        loginVC.appTitle.isHidden = true
        present(loginVC, animated: true, completion: nil)
    }
}
