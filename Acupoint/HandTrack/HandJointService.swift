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
    
    private var thumbCMCMCPMidPoint = CGPoint()
    
    // 看能不能刪除
    let drawOverlay = CAShapeLayer()
    
    let drawPath = UIBezierPath()
    
    var jointPoints: [VNRecognizedPoint] = []
    
    //init() 標記為 private，防止從外部創建 HandJointService 的實例。
    private init() {}
    
//    var customJointPoints: [CGPoint] = []
    
    func drawCustomJoints(on drawOverlay: CAShapeLayer,
                          with drawPath: UIBezierPath,
                          in previewLayer: AVCaptureVideoPreviewLayer,
                          observation: VNHumanHandPoseObservation,
                          with custonPoint: CGPoint) {
//        let handPoints = HandPoints(observation: observation)
        let jointPoint = previewLayer.layerPointConverted(fromCaptureDevicePoint: CGPoint(x: custonPoint.x, y: 1 - custonPoint.y)) //為什麼是 1 - joint.y
        drawPath.move(to: jointPoint)
        drawPath.addArc(withCenter: jointPoint, radius: 9, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
        
        drawOverlay.path = drawPath.cgPath
    }
    
    
    
    //    //
//        func createJointPath(for joint: VNRecognizedPoint, in previewLayer: AVCaptureVideoPreviewLayer) -> CGPath {
//            let jointPoint = previewLayer.layerPointConverted(fromCaptureDevicePoint: CGPoint(x: joint.location.x, y: 1 - joint.location.y))
//            let jointPath = UIBezierPath(arcCenter: jointPoint, radius: jointTouchRadius, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
//            return jointPath.cgPath
//        }
    
    func clearDrawing() {
        drawPath.removeAllPoints()
        drawOverlay.path = drawPath.cgPath
    }
}

