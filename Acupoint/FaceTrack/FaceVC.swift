import UIKit
import ARKit
import CHGlassmorphismView

class FaceVC: UIViewController, ARSCNViewDelegate {
    
    private let sceneVw = ARSCNView(frame: UIScreen.main.bounds)
    
    lazy var faceOutLineVw = UIImageView()
    
    var dotNode = SCNNode()
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back", for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var introTitle: UILabel = {
        let label = UILabel()
        label.text = "迎香穴"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        return label
    }()
    lazy var introContent: UITextView = {
        let textVw = UITextView()
        textVw.textAlignment = .left
        textVw.textColor = UIColor.white
        textVw.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        textVw.backgroundColor = .clear
        let attributedString = NSMutableAttributedString(string: """
        手法：用手指指尖，點壓按摩迎香穴
        
        頻率：1次約 1分鐘
        
        注意：若有疼痛，請勿按壓
        """)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        textVw.attributedText = attributedString
        textVw.textContainerInset.left = 0
        return textVw
    }()
    
    let frossGlass = CHGlassmorphismView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard ARWorldTrackingConfiguration.isSupported else { return }
        
        view.addSubview(sceneVw)
        
        sceneVw.delegate = self
        
        sceneVw.session.run(ARFaceTrackingConfiguration(), options: [.resetTracking, .removeExistingAnchors])
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.addSubview(sceneVw)
        
        let configuration = ARFaceTrackingConfiguration()
        sceneVw.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    override func viewDidLayoutSubviews() {
        view.addSubview(backButton)
        //        view.bringSubviewToFront(backButton)
        view.addSubview(faceOutLineVw)
        view.addSubview(frossGlass)
        view.addSubview(introTitle)
        view.addSubview(introContent)
        addImageView()
        setIntroView()
        setUpText()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneVw.session.pause()
        
        sceneVw.removeFromSuperview()
    }
    
    func addImageView() {
        faceOutLineVw.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            faceOutLineVw.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            faceOutLineVw.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 85),
            faceOutLineVw.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1.1),
            faceOutLineVw.heightAnchor.constraint(equalTo: faceOutLineVw.widthAnchor)
        ])
        faceOutLineVw.image = UIImage(named: "faceOutline")
    }
    
    func setIntroView() {
        frossGlass.setTheme(theme: .light)
        frossGlass.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            backButton.topAnchor.constraint(equalTo: view.topAnchor,constant: 40),
            frossGlass.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            frossGlass.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            frossGlass.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.28),
            frossGlass.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        frossGlass.setCornerRadius(40)
        frossGlass.setDistance(20)
        frossGlass.setBlurDensity(with: 0.5)
    }
    
    func setUpText() {
        introTitle.translatesAutoresizingMaskIntoConstraints = false
        introContent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            introTitle.leadingAnchor.constraint(equalTo: frossGlass.leadingAnchor, constant: 20),
            introTitle.topAnchor.constraint(equalTo: frossGlass.topAnchor, constant: 20),
            introContent.leadingAnchor.constraint(equalTo: frossGlass.leadingAnchor, constant: 20),
            introContent.trailingAnchor.constraint(equalTo: frossGlass.trailingAnchor, constant: -20),
            introContent.bottomAnchor.constraint(equalTo: frossGlass.bottomAnchor, constant: -20),
            introContent.topAnchor.constraint(equalTo: introTitle.bottomAnchor, constant: 10)
        ])
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        guard let faceAnchor = anchor as? ARFaceAnchor, let device = sceneVw.device else { return nil }
        
        let faceGeometry = ARSCNFaceGeometry(device: device)
        
        let faceNode = SCNNode(geometry: faceGeometry)
        
        faceNode.geometry?.firstMaterial?.transparency = 0.0
        
        let mouthTopCenter = [746,311]
        
        let features = [mouthTopCenter]
        
        for feature in features {
            for vertexIndex in feature {
                let dotGeometry = SCNSphere(radius: 0.005)
                dotGeometry.firstMaterial?.diffuse.contents = UIColor.red
                dotNode = SCNNode(geometry: dotGeometry)
                let vertices = faceAnchor.geometry.vertices
                let vertex = vertices[vertexIndex]
                dotNode.position = SCNVector3(vertex.x, vertex.y, vertex.z)
                faceNode.addChildNode(dotNode)
            }
        }
        return faceNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let viewTouchLocation = touch.location(in: sceneVw)
        
        let hitTestResults = sceneVw.hitTest(viewTouchLocation, options: nil)
        
        for result in hitTestResults {
            if let planeNode = result.node as? SCNNode, planeNode == dotNode {
                print("match")
                break
            }
        }
    }
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
}
