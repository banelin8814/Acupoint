import UIKit
import ARKit

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
               NSLayoutConstraint.activate([
                   backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                   backButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -50)
               ])
        view.bringSubviewToFront(backButton)
        
        view.addSubview(faceOutLineVw)
        
        addImageView()
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
            faceOutLineVw.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            faceOutLineVw.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1.2),
            faceOutLineVw.heightAnchor.constraint(equalTo: faceOutLineVw.widthAnchor)
        ])
        faceOutLineVw.image = UIImage(named: "faceOutline")
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        guard let faceAnchor = anchor as? ARFaceAnchor, let device = sceneVw.device else { return nil }
        
        let faceGeometry = ARSCNFaceGeometry(device: device)
        
        let faceNode = SCNNode(geometry: faceGeometry)
        
        faceNode.geometry?.firstMaterial?.transparency = 0.0
        
        let mouthTopCenter = [17]
        
        let features = [mouthTopCenter]
        
        for feature in features {
            for vertexIndex in feature {
                let dotGeometry = SCNSphere(radius: 0.01)
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
