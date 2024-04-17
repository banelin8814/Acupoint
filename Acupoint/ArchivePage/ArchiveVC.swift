import UIKit

class ArchiveVC: UIViewController {
    
    private let archiveTableView = UITableView()
    
    private let faceVC = FaceVC()
    
    var filterResult: [FaceAcupoint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        archiveTableView.dataSource = self
        archiveTableView.delegate = self
        archiveTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "SearchTableViewCell")
        setupTableView()
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
}

extension ArchiveVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return saveData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        cell.textLabel?.text = saveData[indexPath.row].name
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tabBarController?.tabBar.isHidden = true
        faceVC.thePoint = saveData[indexPath.row]
        self.navigationController?.pushViewController(faceVC, animated: true)
    }
}
