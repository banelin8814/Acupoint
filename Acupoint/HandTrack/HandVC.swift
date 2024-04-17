import UIKit
import ARKit

class HandVC: UIViewController, ARSCNViewDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    private var cameraVw: CameraView {
        return view as? CameraView ?? CameraView() //為什麼要這樣寫？
    }
    //處理push HandVC沒有畫面的問題
    override func loadView() {
        view = CameraView()
    }
    //指定一個佇列來處理影像資料輸出，使用者互動級別
    private let videoDataOutputQueue = DispatchQueue(label: "CameraFeedDataOutput", qos: .userInteractive)
    
    private var cameraFeedSession: AVCaptureSession?
    
    private var handPoseRequest: VNDetectHumanHandPoseRequest = {
        let request = VNDetectHumanHandPoseRequest()
        request.maximumHandCount = 1
        return request
    }()
    
    let drawOverlay = CAShapeLayer()
    
    let drawPath = UIBezierPath()
    
    private var thumbCMCMCPMidPoint = CGPoint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        
        drawOverlay.frame = view.layer.bounds
        drawOverlay.lineWidth = 2
        drawOverlay.fillColor = UIColor.red.cgColor
        view.layer.addSublayer(drawOverlay)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        do {
            if cameraFeedSession == nil {
                if let cameraPreviewLayer = cameraVw.previewLayer as? AVCaptureVideoPreviewLayer {
                    cameraPreviewLayer.videoGravity = .resizeAspectFill
                }
                try setupAVSession()
                cameraVw.previewLayer?.session = cameraFeedSession
            }
            DispatchQueue.global(qos: .userInteractive).async {
                self.cameraFeedSession?.startRunning()
            }
        } catch {
            AppError.display(error, inViewController: self)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cameraFeedSession?.stopRunning()
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
                HandJointService.shared.clearDrawing()
                self.drawPath.removeAllPoints()
                return
            }
            try HandJointService.shared.extractJointPoints(from: observation)
            
            DispatchQueue.main.async {
                guard let cameraPreviewLayer = self.cameraVw.previewLayer else { return }
                HandJointService.shared.setSelectedJoints(.wrist, .littleMCP)
                HandJointService.shared.drawJoints(on:   self.drawOverlay,
                                                   with: self.drawPath,
                                                   in:   cameraPreviewLayer)
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

    private func setupAVSession() throws {
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
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
    
    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        guard let touch = touches.first else { return }
    //        let viewTouchLocation = touch.location(in: cameraVw)
    //
    //    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let viewTouchLocation = touch.location(in: cameraVw)
        
        // 將觸控點的座標轉換為 CALayer 的座標系統
        let touchLocationInLayer = cameraVw.layer.convert(viewTouchLocation, to: drawOverlay)
        
        // 檢查觸控點是否在任何一個手部節點的範圍內
        for joint in HandJointService.shared.jointPoints {
            let jointPath = HandJointService.shared.createJointPath(for: joint, in: cameraVw.previewLayer!)
            if jointPath.contains(touchLocationInLayer) {
                print("Touched joint: \(joint)")
                break
            }
        }
    }
}
