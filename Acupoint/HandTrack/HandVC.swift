import UIKit
import ARKit

class HandVC: UIViewController, ARSCNViewDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    private var cameraView: CameraView {
        return view as? CameraView ?? CameraView()
    }
    private let videoDataOutputQueue = DispatchQueue(label: "CameraFeedDataOutput", qos: .userInteractive)
    private var cameraFeedSession: AVCaptureSession?
    private var handPoseRequest: VNDetectHumanHandPoseRequest = {
        let request = VNDetectHumanHandPoseRequest()
        request.maximumHandCount = 1
        return request
    }()
    private var thumbCMCMCPMidPoint = CGPoint()
    private let drawOverlay = CAShapeLayer()
    private let drawPath = UIBezierPath()
    lazy var backButton: UIButton = {
           let button = UIButton(type: .system)
           button.setTitle("Back", for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
           button.translatesAutoresizingMaskIntoConstraints = false
           return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawOverlay.frame = view.layer.bounds
        drawOverlay.lineWidth = 2
        drawOverlay.strokeColor = UIColor.green.cgColor
        drawOverlay.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(drawOverlay)
    }
    override func viewDidLayoutSubviews() {
        view.addSubview(backButton)
               NSLayoutConstraint.activate([
                   backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                   backButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -50)
               ])
        view.bringSubviewToFront(backButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        do {
            if cameraFeedSession == nil {
                if let cameraPreviewLayer = cameraView.previewLayer as? AVCaptureVideoPreviewLayer {
                    cameraPreviewLayer.videoGravity = .resizeAspectFill
                }
                try setupAVSession()
                cameraView.previewLayer?.session = cameraFeedSession
            }
            DispatchQueue.global(qos: .userInteractive).async {
                self.cameraFeedSession?.startRunning()
            }
        } catch {
            AppError.display(error, inViewController: self)
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        cameraFeedSession?.stopRunning()
        super.viewWillDisappear(animated)
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let handler = VNImageRequestHandler(
            cmSampleBuffer: sampleBuffer,
            orientation: .up,
            options: [:]
        )
        do {
            try handler.perform([handPoseRequest])
            guard let observation = handPoseRequest.results?.first else {
                clearDrawing()
                return
            }
            let wristJoint = try observation.recognizedPoint(.wrist)
            let thumbCMCJoint = try observation.recognizedPoint(.thumbCMC)
            let thumbMCPJoint = try observation.recognizedPoint(.thumbMP)
            let thumbIPJoint = try observation.recognizedPoint(.thumbIP)
            let thumbTipJoint = try observation.recognizedPoint(.thumbTip)
            let indexMCPJoint = try observation.recognizedPoint(.indexMCP)
            let indexPIPJoint = try observation.recognizedPoint(.indexPIP)
            let indexDIPJoint = try observation.recognizedPoint(.indexDIP)
            let indexTipJoint = try observation.recognizedPoint(.indexTip)
            let middleMCPJoint = try observation.recognizedPoint(.middleMCP)
            let middlePIPJoint = try observation.recognizedPoint(.middlePIP)
            let middleDIPJoint = try observation.recognizedPoint(.middleDIP)
            let middleTipJoint = try observation.recognizedPoint(.middleTip)
            let ringMCPJoint = try observation.recognizedPoint(.ringMCP)
            let ringPIPJoint = try observation.recognizedPoint(.ringPIP)
            let ringDIPJoint = try observation.recognizedPoint(.ringDIP)
            let ringTipJoint = try observation.recognizedPoint(.ringTip)
            let littleMCPJoint = try observation.recognizedPoint(.littleMCP)
            let littlePIPJoint = try observation.recognizedPoint(.littlePIP)
            let littleDIPJoint = try observation.recognizedPoint(.littleDIP)
            let littleTipJoint = try observation.recognizedPoint(.littleTip)
            
            thumbCMCMCPMidPoint = CGPoint(
                x: (thumbCMCJoint.location.x + thumbMCPJoint.location.x) / 2,
                y: (thumbCMCJoint.location.y + thumbMCPJoint.location.y) / 2
            )
            
            
            DispatchQueue.main.async {
                self.drawJoint(joint: wristJoint, name: "wrist")
                self.drawJoint(joint: thumbCMCJoint, name: "thumbCMC")
                self.drawJoint(joint: thumbMCPJoint, name: "thumbMCP")
                self.drawJoint(joint: thumbIPJoint, name: "thumbIP")
                self.drawJoint(joint: thumbTipJoint, name: "thumbTip")
                self.drawJoint(joint: indexMCPJoint, name: "indexMCP")
                self.drawJoint(joint: indexPIPJoint, name: "indexPIP")
                self.drawJoint(joint: indexDIPJoint, name: "indexDIP")
                self.drawJoint(joint: indexTipJoint, name: "indexTip")
                self.drawJoint(joint: middleMCPJoint, name: "middleMCP")
                self.drawJoint(joint: middlePIPJoint, name: "middlePIP")
                self.drawJoint(joint: middleDIPJoint, name: "middleDIP")
                self.drawJoint(joint: middleTipJoint, name: "middleTip")
                self.drawJoint(joint: ringMCPJoint, name: "ringMCP")
                self.drawJoint(joint: ringPIPJoint, name: "ringPIP")
                self.drawJoint(joint: ringDIPJoint, name: "ringDIP")
                self.drawJoint(joint: ringTipJoint, name: "ringTip")
                self.drawJoint(joint: littleMCPJoint, name: "littleMCP")
                self.drawJoint(joint: littlePIPJoint, name: "littlePIP")
                self.drawJoint(joint: littleDIPJoint, name: "littleDIP")
                self.drawJoint(joint: littleTipJoint, name: "littleTip")
                self.drawPath.removeAllPoints()
            }
        } catch {
            cameraFeedSession?.stopRunning()
            let error = AppError.visionError(error: error)
            DispatchQueue.main.async {
                error.displayInViewController(self)
            }
        }
    }
    func setupAVSession() throws {
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            throw AppError.captureSessionSetup(reason: "Could not find a front camera.")
        }
        guard let deviceInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            throw AppError.captureSessionSetup(reason: "Could not create video device input.")
        }
        let session = AVCaptureSession()
        session.beginConfiguration()
        session.sessionPreset = AVCaptureSession.Preset.high
        
        guard session.canAddInput(deviceInput) else {
            throw AppError.captureSessionSetup(reason: "Could not add video device input to the session")
        }
        session.addInput(deviceInput)
        
        let dataOutput = AVCaptureVideoDataOutput()
        if session.canAddOutput(dataOutput) {
            session.addOutput(dataOutput)
            dataOutput.alwaysDiscardsLateVideoFrames = true
            dataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            dataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        } else {
            throw AppError.captureSessionSetup(reason: "Could not add video data output.")
        }
        session.commitConfiguration()
        cameraFeedSession = session
    }
    
    private func drawJoint(joint: VNRecognizedPoint, name: String) {
        guard let cameraPreviewLayer = cameraView.previewLayer as? AVCaptureVideoPreviewLayer else { return }
        let jointPoint = cameraPreviewLayer.layerPointConverted(fromCaptureDevicePoint: CGPoint(x: joint.location.x, y: 1 - joint.location.y))
        drawPath.move(to: jointPoint)
        drawPath.addArc(withCenter: jointPoint, radius: 5, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
        
        let thumbCMCMCPLayerPoint = cameraPreviewLayer.layerPointConverted(fromCaptureDevicePoint: CGPoint(x: thumbCMCMCPMidPoint.x, y: 1 - thumbCMCMCPMidPoint.y))
        self.drawPath.move(to: thumbCMCMCPLayerPoint)
        self.drawPath.addArc(withCenter: thumbCMCMCPLayerPoint, radius: 3, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
        
        drawOverlay.path = drawPath.cgPath
    }
    
    private func clearDrawing() {
        drawPath.removeAllPoints()
        drawOverlay.path = drawPath.cgPath
    }
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
