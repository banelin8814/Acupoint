import UIKit
import StoreKit

class HomeVC: UIViewController {
    
    let archiveVC = ArchiveVC()
    
    lazy var userAvatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "貂蟬")
        return imageView
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "貂蟬"
        label.font = UIFont.systemFont(ofSize: 18)
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
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200))
           
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)

            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupUserAvatarImageView()
        setupUserNameLabel()
        setupCollectionView()
        setupArchiveBtn()
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: "HomeCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        assignbackground()

    }
    
    func assignbackground(){
            let background = UIImage(named: "background.png")
            var imageView : UIImageView!
            imageView = UIImageView(frame: view.bounds)
            imageView.contentMode =  .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.image = background
            imageView.center = view.center
            view.addSubview(imageView)
            self.view.sendSubviewToBack(imageView)
        }

    func setupUserAvatarImageView() {
        view.addSubview(userAvatarImageView)
        
        NSLayoutConstraint.activate([
            userAvatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            userAvatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userAvatarImageView.widthAnchor.constraint(equalToConstant: 70),
            userAvatarImageView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    func setupUserNameLabel() {
        view.addSubview(userNameLabel)
        NSLayoutConstraint.activate([
            userNameLabel.centerYAnchor.constraint(equalTo: userAvatarImageView.centerYAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: userAvatarImageView.trailingAnchor, constant: 10)
        ])
    }
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.backgroundColor = .clear
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: userAvatarImageView.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20)
        ])
    }
    
    func setupArchiveBtn() {
        view.addSubview(bookmarkBtn)
        NSLayoutConstraint.activate([
            bookmarkBtn.centerYAnchor.constraint(equalTo: userAvatarImageView.centerYAnchor),
            bookmarkBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
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
            // 使用 cell 進行設定
            return cell
        } else {
            return HomeCollectionViewCell()
        }
    }
}

//import SwiftUI
//
//struct CollectionViewController_Previews: PreviewProvider {
//    static var previews: some View {
//        Container().edgesIgnoringSafeArea(.all)
//    }
//    struct Container: UIViewControllerRepresentable {
//        func makeUIViewController(context: Context) -> UIViewController {
//            UINavigationController(rootViewController: HomeVC())
//        }
//        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
//        typealias UViewControllerType = UIViewController
//    }
//}
