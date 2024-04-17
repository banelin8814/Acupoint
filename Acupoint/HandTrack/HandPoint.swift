import Foundation
import Vision

struct HandPoints {
    
    let thumbTIP: VNRecognizedPoint?
    let thumbIP: VNRecognizedPoint?
    let thumbMP: VNRecognizedPoint?
    let thumbCMC: VNRecognizedPoint?
    
    let indexTIP: VNRecognizedPoint?
    let indexDIP: VNRecognizedPoint?
    let indexPIP: VNRecognizedPoint?
    let indexMCP: VNRecognizedPoint?
    
    let middleTIP: VNRecognizedPoint?
    let middleDIP: VNRecognizedPoint?
    let middlePIP: VNRecognizedPoint?
    let middleMCP: VNRecognizedPoint?
    
    let ringTIP: VNRecognizedPoint?
    let ringDIP: VNRecognizedPoint?
    let ringPIP: VNRecognizedPoint?
    let ringMCP: VNRecognizedPoint?
    
    let littleTIP: VNRecognizedPoint?
    let littleDIP: VNRecognizedPoint?
    let littlePIP: VNRecognizedPoint?
    let littleMCP: VNRecognizedPoint?
    
    let wrist: VNRecognizedPoint?

    var customMidPoint: CGPoint {
        calculateMidPoint(point1: thumbTIP?.location, point2: indexTIP?.location)
    }
    
    var customOffsetPoint: CGPoint {
        let offsetX: CGFloat = -0.1
        let offsetY: CGFloat = -0.1
        return calculateOffsetPoint(point: middleMCP?.location, offsetX: offsetX, offsetY: offsetY)
    }
    
    init(observation: VNHumanHandPoseObservation) {
        thumbTIP = try? observation.recognizedPoint(.thumbTip)
        thumbIP = try? observation.recognizedPoint(.thumbIP)
        thumbMP = try? observation.recognizedPoint(.thumbMP)
        thumbCMC = try? observation.recognizedPoint(.thumbCMC)
        
        indexTIP = try? observation.recognizedPoint(.indexTip)
        indexDIP = try? observation.recognizedPoint(.indexDIP)
        indexPIP = try? observation.recognizedPoint(.indexPIP)
        indexMCP = try? observation.recognizedPoint(.indexMCP)
        
        middleTIP = try? observation.recognizedPoint(.middleTip)
        middleDIP = try? observation.recognizedPoint(.middleDIP)
        middlePIP = try? observation.recognizedPoint(.middlePIP)
        middleMCP = try? observation.recognizedPoint(.middleMCP)
        
        ringTIP = try? observation.recognizedPoint(.ringTip)
        ringDIP = try? observation.recognizedPoint(.ringDIP)
        ringPIP = try? observation.recognizedPoint(.ringPIP)
        ringMCP = try? observation.recognizedPoint(.ringMCP)
        
        littleTIP = try? observation.recognizedPoint(.littleTip)
        littleDIP = try? observation.recognizedPoint(.littleDIP)
        littlePIP = try? observation.recognizedPoint(.littlePIP)
        littleMCP = try? observation.recognizedPoint(.littleMCP)
        
        wrist = try? observation.recognizedPoint(.wrist)
    }

    // 計算兩個點的中間點
    func calculateMidPoint(point1: CGPoint?, point2: CGPoint?) -> CGPoint {
        guard let pOne = point1, let pTwo = point2 else {
            return CGPoint.zero
        }
        let midX = (pOne.x + pTwo.x) / 2
        let midY = (pOne.y + pTwo.y) / 2
        return CGPoint(x: midX, y: midY)
    }
    
    // 計算位移後的點
    func calculateOffsetPoint(point: CGPoint?, offsetX: CGFloat, offsetY: CGFloat) -> CGPoint {
        guard let point = point else {
            return CGPoint.zero
        }
        let newX = point.x + offsetX
        let newY = point.y + offsetY
        return CGPoint(x: newX, y: newY)
    }
}
