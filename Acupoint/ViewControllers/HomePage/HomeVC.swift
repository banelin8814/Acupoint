import UIKit

class HomeVC: BaseVC {
  
    let archiveVC = ArchiveVC()
    
    let screenHeight = UIScreen.main.bounds.size.height
    
    let acupointData = AcupointData.shared
    
    let mainImageData: [String] = ["頭痛", "失眠", "美顏","眼睛疲勞"]
    let mainTitleData: [String] = ["頭 痛", "助 眠", "美 顏","眼 睛 疲 勞"]
    
    
    lazy var commonPointLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configureHeadingOneLabel(withText: "常見穴位")
        return label
    }()
    
    lazy var userAvatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.configureCircleView(forImage: "曹操", size: 70)
        return imageView
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Bane"
        label.font = UIFont(name: "GenJyuuGothicX-Medium", size: 22)
        return label
    }()
    
    lazy var bookmarkBtn: UIButton = {
        let button = UIButton()
        //        let bookmarkTapped = false
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(archiveButtonTapped), for: .touchUpInside)
        button.tintColor = .black
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
        view.addSubview(userAvatarImageView)
        view.addSubview(userNameLabel)
        view.addSubview(bookmarkBtn)
        view.addSubview(collectionView)
        view.addSubview(commonPointLbl)
        
    }
    
    override func viewDidLayoutSubviews() {
        setUpUI()
    }
  
    func setUpUI() {
        NSLayoutConstraint.activate([
            userAvatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            userAvatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userAvatarImageView.widthAnchor.constraint(equalToConstant: 70),
            userAvatarImageView.heightAnchor.constraint(equalToConstant: 70),
            
            commonPointLbl.topAnchor.constraint(equalTo: userAvatarImageView.bottomAnchor, constant: 12),
            commonPointLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            commonPointLbl.widthAnchor.constraint(equalToConstant: 120),
            
            userNameLabel.centerYAnchor.constraint(equalTo: userAvatarImageView.centerYAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: userAvatarImageView.trailingAnchor, constant: 22),
            
            bookmarkBtn.centerYAnchor.constraint(equalTo: userAvatarImageView.centerYAnchor),
            bookmarkBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            collectionView.topAnchor.constraint(equalTo: commonPointLbl.bottomAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
    
    @objc func archiveButtonTapped() {
        self.navigationController?.pushViewController(archiveVC, animated: true)
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
    
        commonVC.titleLbl.text =  acupointData.commonAcupoint[indexPath.row].categoryName
        commonVC.contentLbl.text = acupointData.commonAcupoint[indexPath.row].description
        
        if let navigationController = self.navigationController {
            navigationController.pushViewController(commonVC, animated: true)
        } else {
            print("Navigation controller is nil. Unable to push CommonVC.")
        }
    }
}
//
