import Foundation
import UIKit
import AVFoundation
import Vision

class HandJointService {
    
    static let shared = HandJointService()
    
    let jointTouchRadius: CGFloat = 20
    
    enum VisionError: Error {
        case unknownHandJoint
    }
    
    enum HandJoints: String, CaseIterable {
        case wrist, thumbCMC, thumbMCP, thumbIP, thumbTip,
             indexMCP, indexPIP, indexDIP, indexTip,
             middleMCP, middlePIP, middleDIP, middleTip,
             ringMCP, ringPIP, ringDIP, ringTip,
             littleMCP, littlePIP, littleDIP, littleTip
        
        var jointName: VNHumanHandPoseObservation.JointName {
            switch self {
            case .wrist:     return .wrist
            case .thumbCMC:  return .thumbCMC
            case .thumbMCP:  return .thumbMP
            case .thumbIP:   return .thumbIP
            case .thumbTip:  return .thumbTip
            case .indexMCP:  return .indexMCP
            case .indexPIP:  return .indexPIP
            case .indexDIP:  return .indexDIP
            case .indexTip:  return .indexTip
            case .middleMCP: return .middleMCP
            case .middlePIP: return .middlePIP
            case .middleDIP: return .middleDIP
            case .middleTip: return .middleTip
            case .ringMCP:   return .ringMCP
            case .ringPIP:   return .ringPIP
            case .ringDIP:   return .ringDIP
            case .ringTip:   return .ringTip
            case .littleMCP: return .littleMCP
            case .littlePIP: return .littlePIP
            case .littleDIP: return .littleDIP
            case .littleTip: return .littleTip
            }
        }
    }
    
    let drawOverlay = CAShapeLayer()
    
    let drawPath = UIBezierPath()
    
    var jointPoints: [VNRecognizedPoint] = []
    
    var selectedJoints: (VNHumanHandPoseObservation.JointName, VNHumanHandPoseObservation.JointName)?
    //init() 標記為 private，防止從外部創建 HandJointService 的實例。
    private init() {}
    
    func extractJointPoints(from observation: VNHumanHandPoseObservation) throws {
        jointPoints = try HandJoints.allCases.map { joint in
            try observation.recognizedPoint(joint.jointName)
        }
    }
    
    func setSelectedJoints(_ joint1: VNHumanHandPoseObservation.JointName, _ joint2: VNHumanHandPoseObservation.JointName) {
        selectedJoints = (joint1, joint2)
    }
    //全部
    func drawJoints(on drawOverlay: CAShapeLayer, with drawPath: UIBezierPath, in previewLayer: AVCaptureVideoPreviewLayer) {
        for joint in jointPoints {
            let jointPoint = previewLayer.layerPointConverted(fromCaptureDevicePoint: CGPoint(x: joint.location.x, y: 1 - joint.location.y))
            drawPath.move(to: jointPoint)
            drawPath.addArc(withCenter: jointPoint, radius: 5, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
        }
        drawOverlay.path = drawPath.cgPath
    }
    
    //    func drawJoints(on drawOverlay: CAShapeLayer, with drawPath: UIBezierPath, in previewLayer: AVCaptureVideoPreviewLayer) {
    //        for joint in jointPoints {
    //            if let selectedJoints = selectedJoints,
    //               (joint == selectedJoints.0 as NSObject || joint == selectedJoints.1 as NSObject) {
    //                let jointPoint = previewLayer.layerPointConverted(fromCaptureDevicePoint: CGPoint(x: joint.location.x, y: 1 - joint.location.y))
    //                drawPath.move(to: jointPoint)
    //                drawPath.addArc(withCenter: jointPoint, radius: 5, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
    //            }
    //        }
    //        drawOverlay.path = drawPath.cgPath
    //    }
    
    //    func drawJoints(on drawOverlay: CAShapeLayer, with drawPath: UIBezierPath, in previewLayer: AVCaptureVideoPreviewLayer) {
    //        for joint in jointPoints {
    //            if let selectedJoints = selectedJoints,
    //               let jointName = try? HandJoints(rawValue: joint)?.jointName,
    //               (jointName == selectedJoints.0 || jointName == selectedJoints.1) {
    //                let jointPoint = previewLayer.layerPointConverted(fromCaptureDevicePoint: CGPoint(x: joint.location.x, y: 1 - joint.location.y))
    //                drawPath.move(to: jointPoint)
    //                drawPath.addArc(withCenter: jointPoint, radius: 5, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
    //            }
    //        }
    //        drawOverlay.path = drawPath.cgPath
    //    }
    
    
    func createJointPath(for joint: VNRecognizedPoint, in previewLayer: AVCaptureVideoPreviewLayer) -> CGPath {
        let jointPoint = previewLayer.layerPointConverted(fromCaptureDevicePoint: CGPoint(x: joint.location.x, y: 1 - joint.location.y))
        let jointPath = UIBezierPath(arcCenter: jointPoint, radius: jointTouchRadius, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
        return jointPath.cgPath
    }
    
    
    func clearDrawing() {
        drawPath.removeAllPoints()
        drawOverlay.path = drawPath.cgPath
    }
}
