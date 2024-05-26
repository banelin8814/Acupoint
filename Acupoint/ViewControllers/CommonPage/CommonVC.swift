import UIKit

class CommonVC: BaseVC {
    
    private let faceVC = FaceVC()
    private let handVC = HandVC()
    
    let acupointData = AcupointData.shared
    
    lazy var facePoints: [FaceAcupointModel] = {
        return acupointData.faceAcupoints
    }()
    
    lazy var handPoints: [HandAcupointModel] = {
           return acupointData.handAcupoints
    }()
    
    var index: Int = 1
    
    let cellColors: [String] = ["dc9646", "406f7e", "d47764", "93b9b2"]
        
    let screenHeight = UIScreen.main.bounds.size.height

    lazy var titleLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configureHeadingOneLabel(withText: "")
        label.textColor = .white
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "頭痛")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var contentLbl: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configureTextOneLabel(withText: "")
        label.backgroundColor = .clear
        return label
    }()

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.register(CommonCollectionViewCell.self, forCellWithReuseIdentifier: "CommonCollectionViewCell")
        
        func collectionViewLayout() -> UICollectionViewLayout {

            let galleryItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                        heightDimension: .fractionalHeight(1.0)))
            galleryItem.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
            let galleryGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.58),
                                                                                            heightDimension: .fractionalHeight(1)),
                                                                  subitems: [galleryItem])
            let gallerySection = NSCollectionLayoutSection(group: galleryGroup)
            gallerySection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
            gallerySection.orthogonalScrollingBehavior = .continuous
            let layout = UICollectionViewCompositionalLayout(section: gallerySection)
            return layout
            
        }
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        if imageView.superview == nil {
               view.addSubview(imageView)
               view.addSubview(collectionView)
               view.addSubview(contentLbl)
               view.addSubview(titleLbl)
               setupUI()
           }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if imageView.superview == nil {
            view.addSubview(imageView)
            view.addSubview(titleLbl)
            setupUI()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        避免在返回時出現重疊或殘影
        imageView.removeFromSuperview()
    }
    
    func setupUI() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: -10),
            imageView.heightAnchor.constraint(equalToConstant: screenHeight * 0.35),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            titleLbl.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 20),
            titleLbl.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -20),
            
            contentLbl.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            contentLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            contentLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            contentLbl.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -20),
            
            collectionView.heightAnchor.constraint(equalToConstant: screenHeight * 0.26),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
}

extension CommonVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(index)
        return acupointData.commonAcupoint[index].acupoints.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //用if let寫cell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommonCollectionViewCell", for: indexPath) as? CommonCollectionViewCell else {
            return CommonCollectionViewCell() }
        //        cell.backgroundColor = UIColor.hexStringToUIColor(theHex: colors[indexPath.row])
        let theColor = UIColor.hexStringToUIColor(theHex: cellColors[indexPath.row])
        cell.setupCell(theColor, title: acupointData.commonAcupoint[index].acupoints[indexPath.row].name, image: UIImage(named: acupointData.commonAcupoint[index].acupoints[indexPath.row].image)!)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let index = facePoints.firstIndex(where: { $0.name == acupointData.commonAcupoint[index].acupoints[indexPath.row].name }) {
            self.navigationController?.pushViewController(faceVC, animated: true)
            faceVC.selectedFacePoint = [facePoints[index]]
            faceVC.selectedIndex = index
            faceVC.currentDisplayMode = .specific(name: facePoints[index].name)
            faceVC.selectedNameByCell = facePoints[index].name
            faceVC.collectionView.reloadData()
            self.tabBarController?.tabBar.isHidden = true
        }

        if let index = handPoints.firstIndex(where: { $0.name == acupointData.commonAcupoint[index].acupoints[indexPath.row].name }) {
            handVC.acupointIndex = index
            handVC.currentDisplayMode = .specific(name: handPoints[index].name)
            handVC.numberOfAcupoints = 1
            
            handVC.collectionView.reloadData()
            handVC.handSideSegmentedControl.isHidden = true
            self.navigationController?.pushViewController(handVC, animated: true)
            self.tabBarController?.tabBar.isHidden = true
        }
    }
}
