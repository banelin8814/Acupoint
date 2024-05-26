import UIKit
import ARKit
import SwiftData
import CHGlassmorphismView

class FaceVC: UIViewController, ARSCNViewDelegate {
    
    private let sceneVw = ARSCNView(frame: UIScreen.main.bounds)
    
    var dotNode = SCNNode()
    
    var acupoitData = AcupointData.shared

    lazy var facePoints: [FaceAcupointModel] = {
        return acupoitData.faceAcupoints
    }()

    lazy var selectedFacePoint: [FaceAcupointModel] = {
        return selectedFacePoint.self
    }()

    lazy var selectedIndex: Int = 0
    
    var currentDisplayMode: DisplayMode = .allPoint
    
    var currentPage = 0 {
        didSet {
            if oldValue != currentPage {
                getNameByIndex(currentPage)
            }
        }
    }
    
    var selectedNameByCell: String = ""
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()

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

        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        guard ARWorldTrackingConfiguration.isSupported else { return }
        
        view.addSubview(sceneVw)
        view.addSubview(collectionView)
        
        sceneVw.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateCurrentPage(collectionView: collectionView)
        
        let configuration = ARFaceTrackingConfiguration()
        sceneVw.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        let promptVC = PromptVC()
        if selectedFacePoint.count == 1 {
            promptVC.promptNameLbl.text = facePoints[selectedIndex].name
            promptVC.promptPostionLbl.text = facePoints[selectedIndex].location
            promptVC.promptEffectLbl.text = facePoints[selectedIndex].effect
            present(promptVC, animated: true, completion: nil)
        }
    }
    
    override func viewDidLayoutSubviews() {
        setUpUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let promptVC = PromptVC()
        if selectedFacePoint.count == 1 {
            promptVC.handSideLbl.isHidden = true
            promptVC.promptNameLbl.text = facePoints[selectedIndex].name
            promptVC.promptPostionLbl.text = facePoints[selectedIndex].location
            promptVC.promptEffectLbl.text = facePoints[selectedIndex].effect
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

        let configuration = ARFaceTrackingConfiguration()
        sceneVw.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        print(acupoint.name)
    }
    
}

extension FaceVC: CanChangeCellSizeAnimate {}
