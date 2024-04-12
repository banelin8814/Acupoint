import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    private let sceneView = ARSCNView(frame: UIScreen.main.bounds)
    
    lazy var thisImageView = UIImageView()
    
    var dotNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard ARWorldTrackingConfiguration.isSupported else { return }
        
        view.addSubview(sceneView)
        
        sceneView.delegate = self
        
        sceneView.session.run(ARFaceTrackingConfiguration(), options: [.resetTracking, .removeExistingAnchors])
  
        view.addSubview(thisImageView)
        addImageView()
       
    }
    func addImageView(){
        thisImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            thisImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            thisImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            thisImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1.2),
            thisImageView.heightAnchor.constraint(equalTo: thisImageView.widthAnchor)
        ])
        thisImageView.image = UIImage(named: "faceOutline")
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        guard let faceAnchor = anchor as? ARFaceAnchor, let device = sceneView.device else { return nil }
        
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
        guard let touch = touches.first as? UITouch else { return }
        
        let viewTouchLocation = touch.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(viewTouchLocation, options: nil)
        
        for result in hitTestResults {
            if let planeNode = result.node as? SCNNode, planeNode == dotNode {
                print("match")
                break
            }
        }
    }
}

