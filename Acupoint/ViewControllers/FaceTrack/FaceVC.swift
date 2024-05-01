import UIKit
import ARKit
import SwiftData
import CHGlassmorphismView

class FaceVC: UIViewController, ARSCNViewDelegate {
    
    private let sceneVw = ARSCNView(frame: UIScreen.main.bounds)
    
    var dotNode = SCNNode()

    //data
    var acupoitData = AcupointData.shared
    
    lazy var facePoints: [FaceAcupointModel] = {
        return acupoitData.faceAcupoints
    }()
    
    lazy var selectedFacePoint: [FaceAcupointModel] = {
        return selectedFacePoint.self
    }()
    
    lazy var selectedIndex: Int = {
        return selectedIndex.self
    }()
    
    var selectedNameByCell: String?
//    private var container: ModelContainer?
    //偵測
    private var currentPage: Int = 0 {
        didSet {
            if oldValue != currentPage {
                getNameByIndex(currentPage)
            }
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        
        collectionView.register(InfoCollectionViewCell.self, forCellWithReuseIdentifier: "InfoCollectionViewCell")
        func collectionViewLayout() -> UICollectionViewLayout {
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                 heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
            let galleryGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85),
                                                                                                     heightDimension: .fractionalHeight(1)),
                                                                  subitems: [item])
            let gallerySection = NSCollectionLayoutSection(group: galleryGroup)
            gallerySection.orthogonalScrollingBehavior = .groupPagingCentered
            
            gallerySection.visibleItemsInvalidationHandler = { [weak self] items, contentOffset, environment in
                guard let self = self else { return }
                self.updateCurrentPage()
            }
            
            let layout = UICollectionViewCompositionalLayout(section: gallerySection)
            return layout
        }
        return collectionView
    }()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //不能畫動滑面回到上一頁
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        guard ARWorldTrackingConfiguration.isSupported else { return }
        
        view.addSubview(sceneVw)
        view.addSubview(collectionView)
        
        sceneVw.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //偵測
        updateCurrentPage()
        
        let configuration = ARFaceTrackingConfiguration()
        sceneVw.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        //intro Page
        let introVC = PromptVC()
        if selectedFacePoint.count == 1 {
            introVC.promptNameLbl.text = facePoints[selectedIndex].name
            introVC.promptPostionLbl.text = facePoints[selectedIndex].location
            introVC.promptImageView.loadGif(name: "face-animation")
            present(introVC, animated: true, completion: nil)
        }
    }
    
    override func viewDidLayoutSubviews() {

        setUpUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneVw.session.pause()
        self.tabBarController?.tabBar.isHidden = false
        
    }
    //左右滑動的index，丟近array
    func getNameByIndex(_ index: Int) {
        let acupoint = facePoints[index]
        selectedNameByCell = acupoint.name
        //更新
        let configuration = ARFaceTrackingConfiguration()
        sceneVw.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
//        print(acupoint.name)
    }
    
    //偵測
    private func updateCurrentPage() {
        let centerPoint = CGPoint(x: collectionView.frame.size.width / 2 + collectionView.contentOffset.x,
                                  y: collectionView.frame.size.height / 2 + collectionView.contentOffset.y)
        
        if let indexPath = collectionView.indexPathForItem(at: centerPoint) {
            currentPage = indexPath.item
        }
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        guard let faceAnchor = anchor as? ARFaceAnchor, let device = sceneVw.device else { return nil }
        
        let faceGeometry = ARSCNFaceGeometry(device: device)
        
        let faceNode = SCNNode(geometry: faceGeometry)
        
        faceNode.geometry?.firstMaterial?.transparency = 0.0
        //確定有點再畫
        if !selectedFacePoint.isEmpty {
            
            for point in selectedFacePoint {
                
                let positions = point.position
                
                for position in positions {
                    
                    let dotGeometry = SCNSphere(radius: 0.004)
                    
                    print("現在的穴位\(point.name)，指定的穴位\(selectedNameByCell)")
                    if point.name == selectedNameByCell {
                        dotGeometry.firstMaterial?.diffuse.contents = UIColor.white
                    } else {
                        dotGeometry.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.55)
                    }
                    dotNode = SCNNode(geometry: dotGeometry)
                    
                    let vertices = faceAnchor.geometry.vertices
                    let vertex = vertices[position]
                    
                    dotNode.position = SCNVector3(vertex.x, vertex.y, vertex.z)
                    faceNode.addChildNode(dotNode)
                    
//                    let nodeId = UUID()
//                    dotNode.name = nodeId.uuidString
//                    acupointNodes[nodeId] = point
                }
            }
        }
        return faceNode
    }
    
//    var acupointNodes: [UUID: FaceAcupointModel] = [:]
//    var previousTouchedNode: SCNNode?
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        
//        let viewTouchLocation = touch.location(in: sceneVw)
//        
//        let hitTestResults = sceneVw.hitTest(viewTouchLocation, options: nil)
//        
//        for result in hitTestResults {
//            if let nodeId = UUID(uuidString: result.node.name ?? ""),
//               let acupoint = acupointNodes[nodeId] {
//                selectedFacePoint = [acupoint]
//                
//                // 將原本被點擊的節點顏色恢復為原始顏色（黃色）
//                if let previousNode = previousTouchedNode {
//                    previousNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white
//                }
//                
//                // 修改當前被點擊節點的材質顏色為紅色
//                result.node.geometry?.firstMaterial?.diffuse.contents = UIColor.green
//                
//                // 記錄當前被點擊的節點
//                previousTouchedNode = result.node
//                
//                break
//            }
//        }
//    }
    
    func setUpUI() {
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            collectionView.heightAnchor.constraint(equalToConstant: 130)
        ])
    }
    
    enum DisplayMode {
        case allPoint
        case specific(name: String)
    }
    
    var currentDisplayMode: DisplayMode = .allPoint
    
}

extension FaceVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch currentDisplayMode {
        case .allPoint:
            return facePoints.count
        case .specific:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoCollectionViewCell", for: indexPath) as? InfoCollectionViewCell else { return InfoCollectionViewCell()}
        
        switch currentDisplayMode {
        case .allPoint:
            cell.configureFaceDataFromWikiVC(with: facePoints[indexPath.row])
            
        case .specific:
            cell.configureFaceDataFromSearchVC(with: selectedFacePoint[0])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //animation
        let detailVC = DetailVC()
        detailVC.isHandPoint = false
        if let cell = collectionView.cellForItem(at: indexPath) as? InfoCollectionViewCell {
            detailVC.theName = cell.acupointNameLabel.text
        }
        detailVC.modalPresentationStyle = .custom
        present(detailVC, animated: true, completion: nil)
    }
}


