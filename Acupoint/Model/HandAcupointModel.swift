import UIKit
import Vision

struct HandAcupointModel {
    var id: UUID?
    var name: String
    var effect: String
    var method: String
    var location: String
    var notice: String
    var basePoint: [VNHumanHandPoseObservation.JointName]
    var offSet: CGPoint
    var isBackHand: Bool
}
