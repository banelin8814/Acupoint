import UIKit

class SearchVC: UIViewController {
    
    private let searchTableView = UITableView()
    
    private let faceVC = FaceVC()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    var filterResult: [Acupoint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "SearchTableViewCell")
        setupTableView()
        setupSearchController()
        
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
    
    func setupSearchController() {
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.searchBarStyle = .prominent
        
        self.searchController.searchBar.placeholder = "輸入穴位，或疼痛部位"
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = false
        self.navigationItem.hidesSearchBarWhenScrolling = true
//        self.searchTableView.tableHeaderView = self.searchController.searchBar
        self.navigationItem.titleView = searchController.searchBar
    }
    func filterContent(for searchText: String) {
        filterResult = faceAcupoints.filter({ (filterArray) -> Bool in
            let words = filterArray
            let isMach = words.name.localizedCaseInsensitiveContains(searchText)
            return isMach
        })
    }
}

extension SearchVC: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            if searchText.isEmpty {
                filterResult = faceAcupoints
            } else {
                filterContent(for: searchText)
            }
            searchTableView.reloadData()
        }
    }
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.searchController.isActive) {
            return self.filterResult.count
        } else {
            return faceAcupoints.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell() }
        if (self.searchController.isActive) {
            cell.textLabel?.text =
            self.filterResult[indexPath.row].name
            return cell
        } else {
            cell.textLabel?.text =
            faceAcupoints[indexPath.row].name
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tabBarController?.tabBar.isHidden = true
        faceVC.thePoint = faceAcupoints[indexPath.row]
        self.navigationController?.pushViewController(faceVC, animated: true)
    }
}
import SwiftUI

struct SearchViewController_Previews: PreviewProvider {
    static var previews: some View {
        Container().edgesIgnoringSafeArea(.all)
    }
    struct Container: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            UINavigationController(rootViewController: SearchVC())
        }
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
        typealias UViewControllerType = UIViewController
    }
}
