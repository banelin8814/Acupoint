import UIKit
import ARKit
import SwiftData
import CHGlassmorphismView

class FaceVC: UIViewController, ARSCNViewDelegate {
    
    private let sceneVw = ARSCNView(frame: UIScreen.main.bounds)
    
    var dotNode = SCNNode()
    
    //data
    var acupoitData = AcupointData.shared
    //全部
    lazy var facePoints: [FaceAcupointModel] = {
        return acupoitData.faceAcupoints
    }()
    //特定點
    lazy var selectedFacePoint: [FaceAcupointModel] = {
        return selectedFacePoint.self
    }()
    //特定的index
    lazy var selectedIndex: Int = 0
    
    var currentPage = 0 {
        didSet {
            if oldValue != currentPage {
                getNameByIndex(currentPage)
            }
        }
    }
    
    var selectedNameByCell: String = "" {
        didSet {
            
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        // 在这里设置 layout 的属性
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        
        collectionView.register(InfoCollectionViewCell.self, forCellWithReuseIdentifier: "InfoCollectionViewCell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = collectionViewLayoutFromProtocol(collectionView: collectionView)
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
        updateCurrentPage(collectionView: collectionView)
        
        let configuration = ARFaceTrackingConfiguration()
        sceneVw.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        //        //動畫
//        let indexPath = IndexPath(item: 1, section: 0)
//        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseInOut, animations: {
//            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
//        }, completion: nil)
    }
    
    
    override func viewDidLayoutSubviews() {
        setUpUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //intro Page
        let promptVC = PromptVC()
        if selectedFacePoint.count == 1 {
            promptVC.handSideLbl.isHidden = true
            promptVC.promptNameLbl.text = facePoints[selectedIndex].name
            promptVC.promptPostionLbl.text = facePoints[selectedIndex].location
            promptVC.promptEffectLbl.text = facePoints[selectedIndex].effect
            //            promptVC.promptImageView.loadGif(name: "face-animation")
            present(promptVC, animated: true, completion: nil)
            promptVC.delegate = self
        }
        
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
        if !selectedFacePoint.isEmpty {
            
            for point in selectedFacePoint {
                
                let positions = point.position
                
                for position in positions {
                    
                    let dotGeometry = SCNSphere(radius: 0.004)
                    
                    if point.name == selectedNameByCell {
                        dotGeometry.firstMaterial?.diffuse.contents = UIColor.white
                    } else {
                        dotGeometry.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.6)
                    }
                    dotNode = SCNNode(geometry: dotGeometry)
                    
                    let vertices = faceAnchor.geometry.vertices
                    let vertex = vertices[position]
                    
                    dotNode.position = SCNVector3(vertex.x, vertex.y, vertex.z)
                    faceNode.addChildNode(dotNode)
                    
                }
            }
        }
        return faceNode
    }
    
    func setUpUI() {
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            collectionView.heightAnchor.constraint(equalToConstant: 150)
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
        
        if indexPath.row == 0 {
                self.dismissAnimate()
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

extension FaceVC: NameSelectionDelegate, CurrentPageUpdatable {
    
    func getNameByIndex(_ index: Int) {
        let acupoint = facePoints[index]
        selectedNameByCell = acupoint.name
        //更新
        let configuration = ARFaceTrackingConfiguration()
        sceneVw.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        print(acupoint.name)
    }
    
}
//動畫
extension FaceVC: CanDismissAnimate {}
