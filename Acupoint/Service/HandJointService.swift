import Foundation
import UIKit
import AVFoundation
import Vision

class HandJointService {
    
    static let shared = HandJointService()
    
    private init() {}
    
    let jointTouchRadius: CGFloat = 20
    
    private var thumbCMCMCPMidPoint = CGPoint()
    
    let drawOverlay = CAShapeLayer()
    
    let drawPath = UIBezierPath()
    
    var jointPoints: [VNRecognizedPoint] = []
    
    func drawCustomJoints(on drawOverlay: CAShapeLayer,
                          with drawPath: UIBezierPath,
                          in previewLayer: AVCaptureVideoPreviewLayer,
                          observation: VNHumanHandPoseObservation,
                          with custonPoint: CGPoint) {
        let jointPoint = previewLayer.layerPointConverted(fromCaptureDevicePoint: CGPoint(x: custonPoint.x, y: 1 - custonPoint.y)) 
        drawPath.move(to: jointPoint)
        drawPath.addArc(withCenter: jointPoint, radius: 9, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
        
        drawOverlay.path = drawPath.cgPath
    }
    
    func clearDrawing() {
        drawPath.removeAllPoints()
        drawOverlay.path = drawPath.cgPath
    }
}

