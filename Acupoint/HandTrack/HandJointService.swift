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
    
//    var selectedJoints: (VNHumanHandPoseObservation.JointName, VNHumanHandPoseObservation.JointName)?
    //init() 標記為 private，防止從外部創建 HandJointService 的實例。
    private init() {}
        
    var customJointPoints: [CGPoint] = []
    
    //繪製所有點
    func drawExistingJoints(on drawOverlay: CAShapeLayer,
                            with drawPath: UIBezierPath,
                            in previewLayer: AVCaptureVideoPreviewLayer,
                            from observation: VNHumanHandPoseObservation) {
        let handPoints = HandPoints(observation: observation)
           let predefinedJoints: [VNRecognizedPoint?] = [
               handPoints.thumbTIP,
               handPoints.thumbIP,
               handPoints.thumbMP,
               handPoints.thumbCMC
               // 其他預定義的關節點...
           ]
           
           for joint in predefinedJoints {
               if let joint = joint {
                   let jointPoint = previewLayer.layerPointConverted(fromCaptureDevicePoint: CGPoint(x: joint.location.x, y: 1 - joint.location.y))
                   drawPath.move(to: jointPoint)
                   drawPath.addArc(withCenter: jointPoint, radius: 10, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
               }
           }
           
           drawOverlay.path = drawPath.cgPath
    }
    
    
    func drawCustomJoints(on drawOverlay: CAShapeLayer, 
                          with drawPath: UIBezierPath,
                          in previewLayer: AVCaptureVideoPreviewLayer,
                          from observation: VNHumanHandPoseObservation) {
        let handPoints = HandPoints(observation: observation)
        //        let predefinedJoints: [CGPoint?] = [
        //            //handPoints.customMidPoint,
        //            handPoints.customOffsetPoint
        //        ]
        let customOffsetPoint = handPoints.customOffsetPoint
//            for joint in predefinedJoints {
//            if let joint = joint {
                let jointPoint = previewLayer.layerPointConverted(fromCaptureDevicePoint: CGPoint(x: customOffsetPoint.x, y: 1 - customOffsetPoint.y)) //為什麼是 1 - joint.y
                drawPath.move(to: jointPoint)
                drawPath.addArc(withCenter: jointPoint, radius: 10, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
//            }
        print(jointPoint)
        
        drawOverlay.path = drawPath.cgPath
    }
    
    
    
//    //
//    func createJointPath(for joint: VNRecognizedPoint, in previewLayer: AVCaptureVideoPreviewLayer) -> CGPath {
//        let jointPoint = previewLayer.layerPointConverted(fromCaptureDevicePoint: CGPoint(x: joint.location.x, y: 1 - joint.location.y))
//        let jointPath = UIBezierPath(arcCenter: jointPoint, radius: jointTouchRadius, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
//        return jointPath.cgPath
//    }
    
    func clearDrawing() {
        drawPath.removeAllPoints()
        drawOverlay.path = drawPath.cgPath
    }
}

