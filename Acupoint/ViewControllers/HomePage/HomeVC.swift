import UIKit
import GoogleSignIn
import Firebase

class HomeVC: BaseVC, AddNameDelegate {
    
    func didAddUserName(_ item: String) {
        userNameLabel.text = item
        print(item)
    }
    
    let screenHeight = UIScreen.main.bounds.size.height
    
    let acupointData = AcupointData.shared
    
    let mainImageData: [String] = ["頭痛", "失眠", "美顏","眼睛疲勞"]
    let mainTitleData: [String] = ["頭 痛", "助 眠", "美 顏","眼 睛 疲 勞"]
    let cellImage: [String] = ["頭痛大圖", "助眠大圖", "美顏大圖", "眼睛疲勞大圖"]
    
    
    lazy var commonPointLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configureHeadingOneLabel(withText: "常見穴位")
        return label
    }()
    
    //    lazy var userAvatarImageView: UIImageView = {
    //        let imageView = UIImageView()
    //        imageView.translatesAutoresizingMaskIntoConstraints = false
    //        imageView.configureCircleView(forImage: "頭貼", size: 70)
    //        return imageView
    //    }()
    
    var userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configureHeadingThreeLabel(withText: "你好")
        return label
    }()
    
    let menuButton: UIButton = {
        let button = UIButton()
//        button.setTitle("尚未設定", for: .normal)
        button.setImage(UIImage(named: "Hamburger_icon"), for: .normal)
        button.contentMode = .scaleAspectFit
//        button.tintColor = .black
        button.showsMenuAsPrimaryAction = true
        button.translatesAutoresizingMaskIntoConstraints = false
       
        return button
    }()
   
    
    
        lazy var signOutBtn: UIButton = {
            let button = UIButton()
            button.setTitle("尚未設定", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitleColor(.black, for: .normal)
            if AuthManager.shared.isLoggedIn {
                button.setTitle("登出", for: .normal)
                button.addTarget(self, action: #selector(signOutButtonTapped), for: .touchUpInside)
            } else {
                button.setTitle("請登入", for: .normal)
//                button.addTarget(self, action: #selector(havntLoginYet), for: .touchUpInside)
            }
            return button
        }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: "HomeCollectionViewCell")
        func collectionViewLayout() -> UICollectionViewLayout {
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            var groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            if screenHeight > 800 {
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .fractionalHeight(0.18))
            } else {
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .fractionalHeight(0.18))
            }
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
            
            let section = NSCollectionLayoutSection(group: group)
            if screenHeight > 800 {
                section.interGroupSpacing = 20
            } else {
                section.interGroupSpacing = 12
            }
            let layout = UICollectionViewCompositionalLayout(section: section)
            return layout
        }
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let thevc2 = LoginVC()
        thevc2.addDelegate = self
        
        //        view.addSubview(userAvatarImageView)
        view.addSubview(userNameLabel)
        //        view.addSubview(signOutBtn)
        view.addSubview(menuButton)
        view.addSubview(collectionView)
        view.addSubview(commonPointLbl)
        setUIMenu()
    }
    
    override func viewDidLayoutSubviews() {
        setUpUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setUpUI() {
        NSLayoutConstraint.activate([
            //            userAvatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            //            userAvatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            //            userAvatarImageView.widthAnchor.constraint(equalToConstant: 70),
            //            userAvatarImageView.heightAnchor.constraint(equalToConstant: 70),
            
            userNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            userNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            userNameLabel.trailingAnchor.constraint(equalTo: menuButton.leadingAnchor, constant: 10),
            //            userNameLabel.widthAnchor.constraint(equalToConstant: 180),
            
            menuButton.centerYAnchor.constraint(equalTo: userNameLabel.centerYAnchor),
            menuButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            menuButton.heightAnchor.constraint(equalToConstant: 25),
            menuButton.widthAnchor.constraint(equalToConstant: 25),
            
            commonPointLbl.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 12),
            commonPointLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            commonPointLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            
            collectionView.topAnchor.constraint(equalTo: commonPointLbl.bottomAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
            
            //            signOutBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            //            signOutBtn.centerYAnchor.constraint(equalTo: userNameLabel.centerYAnchor)
        ])
    }
    
    func setUIMenu() {
        if AuthManager.shared.isLoggedIn == false {
            let action1 = UIAction(title: "登入", handler: { _ in
                self.havntLoginYet()
            })
            let menu = UIMenu(title: "帳號管理", children: [action1])
            menuButton.menu = menu
            
        } else {
            let action1 = UIAction(title: "登出", handler: { _ in
                self.signOutButtonTapped()
            })
            let action2 = UIAction(title: "刪除帳號", handler: { _ in
                self.deleteActionTriggered()
            })
            let menu = UIMenu(title: "帳號管理", children: [action1, action2])
            menuButton.menu = menu
        }
      
    }
    
    func deleteActionTriggered() {
        let controller = UIAlertController(title: "確定要刪除帳號？", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "是的", style: .default) { (_) in
                Task {
                    do {
                        try await AuthManager.shared.deleteUserAccount()
                    } catch {
                        print(error)
                        // errorMessage = error.localizedDescription
                    }
                }
            }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(okAction)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }

     func havntLoginYet() {
        let loginPage = LoginVC()
        present(loginPage, animated: true, completion: nil)
    }
    
    @objc func signOutButtonTapped() {
        
        let controller = UIAlertController(title: "確定要登出？", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "是的", style: .default) { (_) in
            do {
                try Auth.auth().signOut()
                AuthManager.shared.isLoggedIn = false
            } catch {
                print(error)
                //        errorMessage = error.localizedDescription
            }
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(okAction)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //用if let寫cell
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell {
            cell.mainVw.image = UIImage(named: mainImageData[indexPath.row])
            cell.titleLabel.text =  mainTitleData[indexPath.row]
            // 使用 cell 進行設定
            return cell
        } else {
            return HomeCollectionViewCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let commonVC = CommonVC()
        commonVC.index = indexPath.row
        commonVC.imageView.image = UIImage(named: cellImage[indexPath.row])
        commonVC.titleLbl.text =  acupointData.commonAcupoint[indexPath.row].categoryName
        commonVC.contentLbl.text = acupointData.commonAcupoint[indexPath.row].description
        
        if let navigationController = self.navigationController {
            navigationController.pushViewController(commonVC, animated: true)
        } else {
            print("Navigation controller is nil. Unable to push CommonVC.")
        }
    }
}



