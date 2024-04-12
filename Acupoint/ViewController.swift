import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    private let sceneView = ARSCNView(frame: UIScreen.main.bounds)

    var dotNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard ARWorldTrackingConfiguration.isSupported else { return }

           view.addSubview(sceneView)

           sceneView.delegate = self

//           sceneView.showsStatistics = true // 顯示統計信息

           sceneView.session.run(ARFaceTrackingConfiguration(), options: [.resetTracking, .removeExistingAnchors])

    }

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {

        guard let faceAnchor = anchor as? ARFaceAnchor, let device = sceneView.device else { return nil }

        let faceGeometry = ARSCNFaceGeometry(device: device)

        let faceNode = SCNNode(geometry: faceGeometry)

        faceNode.geometry?.firstMaterial?.transparency = 0.0

//        let mouthTopLeft = Array(250...256)
          let mouthTopCenter = [17]
//          let mouthTopRight = Array(685...691).reversed()
//          let mouthRight = [684]
//          let mouthBottomRight = [682, 683,700,709,710,725]
//          let mouthBottomCenter = [25]
//          let mouthBottomLeft = [265,274,290,275,247,248]
//          let mouthLeft = [249]
//          let mouthClockwise : [Int] = mouthLeft +
//                                         mouthTopLeft + mouthTopCenter +
//                                         mouthTopRight + mouthRight +
//                                         mouthBottomRight + mouthBottomCenter +
//                                         mouthBottomLeft
//          let eyeTopLeft = Array(1090...1101)
//          let eyeBottomLeft = Array(1102...1108) + Array(1085...1089)
//          let eyeTopRight = Array(1069...1080)
//          let eyeBottomRight = Array(1081...1084) + Array(1061...1068)

//          let cheekLeft = [206, 207, 216, 217, 218, 219, 220, 402, 403, 404, 405, 408]
//          let cheekRight = [437, 438, 439, 440, 457, 458, 459, 460, 461, 462, 463, 464]
//          let jawLeft = [172, 173, 174, 175, 176, 177, 178, 379, 397, 398, 399, 421]
//          let jawRight = [361, 362, 363, 364, 365, 366, 367, 368, 369, 370, 371, 395]

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

