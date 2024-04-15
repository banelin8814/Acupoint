import UIKit

class HomeVC: UIViewController {
    let searchTableView = UITableView()
    let faceVc = FaceVC()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "SearchTableViewCell")
        setupTableView()
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
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        faceAcupoints.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell() }
        cell.textLabel?.text = faceAcupoints[indexPath.row].name
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        FaceVC.thePoint = faceAcupoints[indexPath.row]
//        let faceVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FaceVC") as? FaceVC
//        faceVc.thePoint = faceAcupoints[IndexPath.row]
//        self.performSegue(withIdentifier: "toHeightForRowAt", sender: nil)
        print("didTap")
        faceVc.thePoint = faceAcupoints[indexPath.row]
        self.navigationController?.pushViewController(faceVc, animated: true)
    }
}
