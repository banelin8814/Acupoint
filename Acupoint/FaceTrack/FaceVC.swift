import UIKit
import ARKit
import SwiftData
import CHGlassmorphismView

class FaceVC: UIViewController, ARSCNViewDelegate {
    
    //    var isSaved = false
    
    private let sceneVw = ARSCNView(frame: UIScreen.main.bounds)
    
    lazy var faceOutLineVw = UIImageView()
    
    var thePoint: [FaceAcupointModel]? {
        didSet {
            if let thePoint = thePoint {
                introTitle.text = thePoint[0].name
                methodLbl.text = "手法： \(thePoint[0].method)"
                frequencyLbl.text = "频率： \(thePoint[0].frequency)"
                noticeLbl.text = "注意： \(thePoint[0].notice)"
            }
        }
    }
    
    var dotNode = SCNNode()
    
    lazy var introTitle: UILabel = {
        let label = UILabel()
        label.text = thePoint?[0].name
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var methodLbl: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var frequencyLbl: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var noticeLbl: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var frossGlass = CHGlassmorphismView()
    
    lazy var bookmarkBtn: UIButton = {
        let button = UIButton()
        //        let bookmarkTapped = false
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.setImage(UIImage(systemName: "bookmark.fill"), for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        //        button.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    
    private var container: ModelContainer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard ARWorldTrackingConfiguration.isSupported else { return }
        
        view.addSubview(sceneVw)
        
        sceneVw.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARFaceTrackingConfiguration()
        sceneVw.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    override func viewDidLayoutSubviews() {
        
        view.addSubview(faceOutLineVw)
        view.addSubview(frossGlass)
        view.addSubview(introTitle)
        view.addSubview(methodLbl)
        view.addSubview(frequencyLbl)
        view.addSubview(noticeLbl)
        view.addSubview(bookmarkBtn)
        addImageView()
        setIntroView()
        setUpText()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.addSubview(sceneVw)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneVw.session.pause()
        sceneVw.removeFromSuperview()
        
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        //        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    func addImageView() {
        faceOutLineVw.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            faceOutLineVw.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            faceOutLineVw.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 75),
            faceOutLineVw.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1.3),
            faceOutLineVw.heightAnchor.constraint(equalTo: faceOutLineVw.widthAnchor)
        ])
        faceOutLineVw.image = UIImage(named: "faceOutline")
    }
    
    func setIntroView() {
        frossGlass.setTheme(theme: .dark)
        frossGlass.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            //            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            //            backButton.topAnchor.constraint(equalTo: view.topAnchor,constant: 40),
            frossGlass.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            frossGlass.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 3),
            frossGlass.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.28),
            frossGlass.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        frossGlass.setCornerRadius(40)
        frossGlass.setDistance(5)
        frossGlass.setBlurDensity(with: 0.65)
    }
    
    func setUpText() {
        NSLayoutConstraint.activate([
            introTitle.leadingAnchor.constraint(equalTo: frossGlass.leadingAnchor, constant: 20),
            introTitle.topAnchor.constraint(equalTo: frossGlass.topAnchor, constant: 20),
            methodLbl.leadingAnchor.constraint(equalTo: frossGlass.leadingAnchor, constant: 20),
            methodLbl.trailingAnchor.constraint(equalTo: frossGlass.trailingAnchor, constant: -20),
            methodLbl.topAnchor.constraint(equalTo: introTitle.topAnchor, constant: 40),
            frequencyLbl.leadingAnchor.constraint(equalTo: frossGlass.leadingAnchor, constant: 20),
            frequencyLbl.trailingAnchor.constraint(equalTo: frossGlass.trailingAnchor, constant: -20),
            frequencyLbl.topAnchor.constraint(equalTo: methodLbl.topAnchor, constant: 20),
            noticeLbl.leadingAnchor.constraint(equalTo: frossGlass.leadingAnchor, constant: 20),
            noticeLbl.trailingAnchor.constraint(equalTo: frossGlass.trailingAnchor, constant: -20),
            noticeLbl.topAnchor.constraint(equalTo: frequencyLbl.topAnchor, constant: 20),
            bookmarkBtn.topAnchor.constraint(equalTo: frossGlass.topAnchor, constant: 20),
            bookmarkBtn.trailingAnchor.constraint(equalTo: frossGlass.trailingAnchor, constant: -20)
        ])
    }
    
    
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        guard let faceAnchor = anchor as? ARFaceAnchor, let device = sceneVw.device else { return nil }
        
        let faceGeometry = ARSCNFaceGeometry(device: device)
        
        let faceNode = SCNNode(geometry: faceGeometry)
        
        faceNode.geometry?.firstMaterial?.transparency = 0.0
        
        if let points = thePoint {
            
            for point in points {
                
                let positions = point.position
                
                for position in positions {
                    
                    let dotGeometry = SCNSphere(radius: 0.005)
                    dotGeometry.firstMaterial?.diffuse.contents = UIColor.systemYellow
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
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        
//        let viewTouchLocation = touch.location(in: sceneVw)
//        
//        let hitTestResults = sceneVw.hitTest(viewTouchLocation, options: nil)
//        
//        for result in hitTestResults {
//            if let planeNode = result.node as? SCNNode, planeNode == dotNode {
//                print("match")
//                break
//            }
//        }
//    }
    var acupointNodes: [UUID: FaceAcupointModel] = [:]

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let viewTouchLocation = touch.location(in: sceneVw)
        
        let hitTestResults = sceneVw.hitTest(viewTouchLocation, options: nil)
        
        for result in hitTestResults {
            if let nodeId = UUID(uuidString: result.node.name ?? ""),
               let acupoint = acupointNodes[nodeId] {
                thePoint = [acupoint]
                break
            }
        }
    }
}

