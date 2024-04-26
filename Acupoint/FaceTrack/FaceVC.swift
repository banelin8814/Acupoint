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
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false

        collectionView.register(InfoCollectionViewCell.self, forCellWithReuseIdentifier: "InfoCollectionViewCell")
        func collectionViewLayout() -> UICollectionViewLayout {
            let galleryItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                        heightDimension: .fractionalHeight(1.0)))
            galleryItem.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
            let galleryGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85),
                                                                                            heightDimension: .fractionalHeight(1)),
                                                                  subitem: galleryItem, count: 1)
            let gallerySection = NSCollectionLayoutSection(group: galleryGroup)
            gallerySection.orthogonalScrollingBehavior = .groupPagingCentered
            let layout = UICollectionViewCompositionalLayout(section: gallerySection)
            return layout
        }
        return collectionView
    }()
    
    private var container: ModelContainer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard ARWorldTrackingConfiguration.isSupported else { return }
        
        view.addSubview(sceneVw)
        view.addSubview(collectionView)
        
        sceneVw.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARFaceTrackingConfiguration()
        sceneVw.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        //intro Page
        let introVC = IntroVC()
        if selectedFacePoint.count == 1 {
            introVC.introNameLbl.text = facePoints[selectedIndex].name
            introVC.introPostionLbl.text = facePoints[selectedIndex].positionDescibition
        } else {
            introVC.introNameLbl.text = ""
            introVC.introPostionLbl.text = "滑動畫面選擇穴位"
        }
        introVC.introImageView.loadGif(name: "face-animation")
        present(introVC, animated: true, completion: nil)
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
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        guard let faceAnchor = anchor as? ARFaceAnchor, let device = sceneVw.device else { return nil }
        
        let faceGeometry = ARSCNFaceGeometry(device: device)
        
        let faceNode = SCNNode(geometry: faceGeometry)
        
        faceNode.geometry?.firstMaterial?.transparency = 0.0
        //確定有點再畫
        if !selectedFacePoint.isEmpty  {
            
            for point in selectedFacePoint {
                
                let positions = point.position
                
                for position in positions {
                    
                    let dotGeometry = SCNSphere(radius: 0.004)
                    
                    if point.name == selectedNameByCell {
                        dotGeometry.firstMaterial?.diffuse.contents = UIColor.systemRed
                    } else {
                        dotGeometry.firstMaterial?.diffuse.contents = UIColor.white
                    }
                    dotNode = SCNNode(geometry: dotGeometry)
                    
                    let vertices = faceAnchor.geometry.vertices
                    let vertex = vertices[position]
                    
                    dotNode.position = SCNVector3(vertex.x, vertex.y, vertex.z)
                    faceNode.addChildNode(dotNode)
                    
                    let nodeId = UUID()
                    dotNode.name = nodeId.uuidString
                    acupointNodes[nodeId] = point
                }
            }
        }
        return faceNode
    }
    
    var acupointNodes: [UUID: FaceAcupointModel] = [:]
    var previousTouchedNode: SCNNode?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let viewTouchLocation = touch.location(in: sceneVw)
        
        let hitTestResults = sceneVw.hitTest(viewTouchLocation, options: nil)
        
        for result in hitTestResults {
            if let nodeId = UUID(uuidString: result.node.name ?? ""),
               let acupoint = acupointNodes[nodeId] {
                selectedFacePoint = [acupoint]
                
                // 將原本被點擊的節點顏色恢復為原始顏色（黃色）
                if let previousNode = previousTouchedNode {
                    previousNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white
                }
                
                // 修改當前被點擊節點的材質顏色為紅色
                result.node.geometry?.firstMaterial?.diffuse.contents = UIColor.green
                
                // 記錄當前被點擊的節點
                previousTouchedNode = result.node
                
                break
            }
        }
    }
    
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let configuration = ARFaceTrackingConfiguration()
        sceneVw.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        if indexPath.item == 0 {
            let acupoint = facePoints[0]
            selectedNameByCell = acupoint.name
        } else {
            let acupoint = facePoints[indexPath.item - 1]
            selectedNameByCell = acupoint.name
        }
    }
    //    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    //           let visibleCells = collectionView.visibleCells
    //           if let currentCell = visibleCells.first as? InfoCollectionViewCell {
    //               if let labelText = currentCell.acupointNameLabel.text {
    //                   selectedNameByCell = labelText
    //                   updateAcupointPositions()
    //                   print("Current label text: \(labelText)")
    //               }
    //           }
    //       }
}
