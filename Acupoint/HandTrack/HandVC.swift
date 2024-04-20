import UIKit
import ARKit
import CHGlassmorphismView
import SnapKit

class HandVC: UIViewController, ARSCNViewDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    //MARK: - property
    
    private var cameraVw: CameraView {
        return view as? CameraView ?? CameraView() //為什麼要這樣寫？
    }
    //新的
    var observation: VNHumanHandPoseObservation?
    
    var isLeftHand: Bool = false
    
    // 處理push HandVC沒有畫面的問題
    override func loadView() {
        view = CameraView()
    }
    
    var handPoint = handAcupoints {
        didSet {
            introTitle.text = handPoint[0].name
            methodLbl.text = "手法： \(handPoint[0].method)"
            frequencyLbl.text = "頻率： \(handPoint[0].frequency)"
            noticeLbl.text = "注意： \(handPoint[0].notice)"
        }
    }
    
    var acupointIndex: Int = 2
    
    lazy var handOutLineVw = UIImageView()
    
    lazy var introTitle: UILabel = {
        let label = UILabel()
        label.text = "Test"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var methodLbl: UILabel = {
        let label = UILabel()
        label.text = "Test"
        label.numberOfLines = 2
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var frequencyLbl: UILabel = {
        let label = UILabel()
        label.text = "Test"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var noticeLbl: UILabel = {
        let label = UILabel()
        label.text = "Test"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var frossGlass = CHGlassmorphismView()
    
    lazy var bookmarkBtn: UIButton = {
        let button = UIButton()
        //        let bookmarkTapped = false
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.setImage(UIImage(systemName: "bookmark.fill"), for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        //        button.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    lazy var switchHandBtn: UIButton = {
        let button = UIButton()
        button.setTitle("切换左右手", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(switchHandBtnTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var switchSideBtn: UIButton = {
        let button = UIButton()
        button.setTitle("切換手的正反面", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(switchSideBtnTapped), for: .touchUpInside)
        return button
    }()
    
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
    
    var jointPoints: [VNRecognizedPoint] = []
    
    //    var handAcuPoint: CGPoint = handAcupoints[0].postion
    var selectedAcupoint: CGPoint = .zero
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(handOutLineVw)
        view.addSubview(frossGlass)
        view.addSubview(introTitle)
        view.addSubview(methodLbl)
        view.addSubview(frequencyLbl)
        view.addSubview(noticeLbl)
        view.addSubview(bookmarkBtn)
        view.addSubview(switchHandBtn)
        view.addSubview(switchSideBtn)
        
        drawOverlay.frame = view.layer.bounds
        drawOverlay.lineWidth = 40
        drawOverlay.fillColor = UIColor.systemYellow.cgColor
        view.layer.addSublayer(drawOverlay)
        
        
        setUpUI()
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
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - function
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        let handler = VNImageRequestHandler(
            cmSampleBuffer: sampleBuffer,
            orientation: .up,
            options: [:]
        )
        do {
            try handler.perform([handPoseRequest])
            guard let newObservation = handPoseRequest.results?.first else {
                HandJointService.shared.clearDrawing()
                self.drawPath.removeAllPoints()
                return
            }
            observation = newObservation
            
            // 這些點被賦予值，在被觀察過後
            thumbTIP = try? observation?.recognizedPoint(.thumbTip)
            thumbIP = try? observation?.recognizedPoint(.thumbIP)
            thumbMP = try? observation?.recognizedPoint(.thumbMP)
            thumbCMC = try? observation?.recognizedPoint(.thumbCMC)
            
            indexTIP = try? observation?.recognizedPoint(.indexTip)
            indexDIP = try? observation?.recognizedPoint(.indexDIP)
            indexPIP = try? observation?.recognizedPoint(.indexPIP)
            indexMCP = try? observation?.recognizedPoint(.indexMCP)
            
            middleTIP = try? observation?.recognizedPoint(.middleTip)
            middleDIP = try? observation?.recognizedPoint(.middleDIP)
            middlePIP = try? observation?.recognizedPoint(.middlePIP)
            middleMCP = try? observation?.recognizedPoint(.middleMCP)
            
            ringTIP = try? observation?.recognizedPoint(.ringTip)
            ringDIP = try? observation?.recognizedPoint(.ringDIP)
            ringPIP = try? observation?.recognizedPoint(.ringPIP)
            ringMCP = try? observation?.recognizedPoint(.ringMCP)
            
            littleTIP = try? observation?.recognizedPoint(.littleTip)
            littleDIP = try? observation?.recognizedPoint(.littleDIP)
            littlePIP = try? observation?.recognizedPoint(.littlePIP)
            littleMCP = try? observation?.recognizedPoint(.littleMCP)
            
            wrist = try? observation?.recognizedPoint(.wrist)
            
            updateAcupointPositions()
            
            DispatchQueue.main.async {
                guard let cameraPreviewLayer = self.cameraVw.previewLayer else { return }
                // 這邊畫穴位
                HandJointService.shared.drawCustomJoints(on: self.drawOverlay, with: self.drawPath, in: cameraPreviewLayer, observation: self.observation!, with: self.selectedAcupoint)
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
    func updateAcupointPositions() {
        
        let handAcupoints: [HandAcupoint] = [
            HandAcupoint(
                name: "合谷穴",
                location: "虎口肌肉隆起處，大拇指與食指相接處",
                effect: "疏通經絡、緩解頭痛、牙痛、鼻塞等症狀",
                method: "用拇指指腹按壓合谷穴",
                frequency: "每天按壓 2-3 次，每次約 1-2 分鐘",
                notice: "按壓時若感到疼痛，可適當減輕力道",
                position: joiningValley,
                isBackHand: true),
            
            HandAcupoint(
                name: "內關穴",
                location: "手腕橫紋上方兩寸，掌側兩筋之間",
                effect: "鎮靜安神、改善失眠、緩解心悸、胸悶等症狀",
                method: "用拇指或中指指腹按壓內關穴",
                frequency: "每天按壓 2-3 次，每次約 1-2 分鐘",
                notice: "按壓時若感到不適，可減輕力道或縮短按壓時間",
                position: innerPass,
                isBackHand: true),
            
            HandAcupoint(
                name: "勞宮穴",
                location: "手掌心兩橫紋交叉處中點",
                effect: "養心安神、改善心悸、失眠、健忘等症狀",
                method: "用拇指指腹按壓勞宮穴",
                frequency: "每天按壓 2-3 次，每次約 1-2 分鐘",
                notice: "按壓時若感到不適，可減輕力道或縮短按壓時間",
                position: palaceOfToil,
                isBackHand: false),
            
            HandAcupoint(
                name: "少沖穴",
                location: "小指尖端，指甲角旁",
                effect: "鎮靜安神、緩解心悸、失眠、健忘等症狀",
                method: "用拇指指腹按壓少沖穴",
                frequency: "每天按壓 2-3 次，每次約 1-2 分鐘",
                notice: "按壓時若感到不適，可減輕力道或縮短按壓時間",
                position: lesserSurge,
                isBackHand: true)
        ]
        
        selectedAcupoint = handAcupoints[self.acupointIndex].position
        
        if handPoint.count == 1 {
            var acupointPaths: [UIBezierPath] = []
            
            for acupoint in handPoint {
                if isLeftHand == true {
                    
                    let position = acupoint.position
                    let path = UIBezierPath()
                    
                    DispatchQueue.main.async { [self] in
                        guard let cameraPreviewLayer = self.cameraVw.previewLayer, let observation = observation else { return }
                        HandJointService.shared.drawCustomJoints(on: self.drawOverlay, with: path, in: cameraPreviewLayer, observation: observation, with: position)
                        acupointPaths.append(path)
                    }
                }
            }
            DispatchQueue.main.async { [self] in
                // 移除先前的子層
                self.drawOverlay.sublayers?.forEach { $0.removeFromSuperlayer() }
                
                // 為每個穴位路徑創建一個新的子層
                for path in acupointPaths {
                    let shapeLayer = CAShapeLayer()
                    shapeLayer.path = path.cgPath
                    shapeLayer.fillColor = UIColor.systemBlue.cgColor
                    shapeLayer.lineWidth = 10
                    self.drawOverlay.addSublayer(shapeLayer)
                }
            }
        } else {
            
            
            var acupointPaths: [UIBezierPath] = []
            
            for acupoint in handAcupoints {
                
                if acupoint.isBackHand == true {
                    
                    let position = acupoint.position
                    let path = UIBezierPath()
                    
                    DispatchQueue.main.async { [self] in
                        guard let cameraPreviewLayer = self.cameraVw.previewLayer, let observation = observation else { return }
                        HandJointService.shared.drawCustomJoints(on: self.drawOverlay, with: path, in: cameraPreviewLayer, observation: observation, with: position)
                        acupointPaths.append(path)
                    }
                }
            }
            
            DispatchQueue.main.async { [self] in
                // 移除先前的子層
                self.drawOverlay.sublayers?.forEach { $0.removeFromSuperlayer() }
                
                // 為每個穴位路徑創建一個新的子層
                for path in acupointPaths {
                    let shapeLayer = CAShapeLayer()
                    shapeLayer.path = path.cgPath
                    shapeLayer.fillColor = UIColor.systemRed.cgColor
                    shapeLayer.lineWidth = 10
                    self.drawOverlay.addSublayer(shapeLayer)
                }
            }
        }
        //        if isLeftHand {
        //            // 計算左手穴位的對稱位置
        //            selectedAcupoint.x = 1 - selectedAcupoint.x
        //        }
        
        //        DispatchQueue.main.async {
        //            if handAcupoints[self.acupointIndex].isBackHand == true {
        //                self.handOutLineVw.image = UIImage(named: "handOutlineBack")
        //            } else {
        //                self.handOutLineVw.image = UIImage(named: "handOutlinePalm")
        //            }
        //        }
        
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
    
    
    func setUpUI() {
        frossGlass.setTheme(theme: .dark)
        handOutLineVw.translatesAutoresizingMaskIntoConstraints = false
        frossGlass.translatesAutoresizingMaskIntoConstraints = false
        handOutLineVw.translatesAutoresizingMaskIntoConstraints = false
        
        frossGlass.setCornerRadius(25)
        frossGlass.setDistance(5)
        frossGlass.setBlurDensity(with: 0.65)
        
        NSLayoutConstraint.activate([
            handOutLineVw.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            handOutLineVw.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 85),
            handOutLineVw.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1.1),
            handOutLineVw.heightAnchor.constraint(equalTo: handOutLineVw.widthAnchor),
           
            frossGlass.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            frossGlass.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 3),
            frossGlass.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.28),
            frossGlass.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            introTitle.leadingAnchor.constraint(equalTo: frossGlass.leadingAnchor, constant: 20),
            introTitle.topAnchor.constraint(equalTo: frossGlass.topAnchor, constant: 20),
          
            methodLbl.leadingAnchor.constraint(equalTo: frossGlass.leadingAnchor, constant: 20),
            methodLbl.trailingAnchor.constraint(equalTo: frossGlass.trailingAnchor, constant: -20),
            methodLbl.topAnchor.constraint(equalTo: introTitle.topAnchor, constant: 40),
           
            frequencyLbl.leadingAnchor.constraint(equalTo: frossGlass.leadingAnchor, constant: 20),
            frequencyLbl.trailingAnchor.constraint(equalTo: frossGlass.trailingAnchor, constant: -20),
            frequencyLbl.topAnchor.constraint(equalTo: methodLbl.topAnchor, constant: 20),
           
            noticeLbl.leadingAnchor.constraint(equalTo: frossGlass.leadingAnchor, constant: 20),
            noticeLbl.trailingAnchor.constraint(equalTo: frossGlass.trailingAnchor, constant: -20),
            noticeLbl.topAnchor.constraint(equalTo: frequencyLbl.topAnchor, constant: 20),
           
            bookmarkBtn.topAnchor.constraint(equalTo: frossGlass.topAnchor, constant: 20),
            bookmarkBtn.trailingAnchor.constraint(equalTo: frossGlass.trailingAnchor, constant: -20),
            
            switchHandBtn.bottomAnchor.constraint(equalTo: frossGlass.topAnchor, constant: -20),
            switchHandBtn.leadingAnchor.constraint(equalTo: frossGlass.leadingAnchor, constant: 20),
            switchHandBtn.widthAnchor.constraint(equalToConstant: 100),
            switchHandBtn.heightAnchor.constraint(equalToConstant: 40),
            
            switchSideBtn.bottomAnchor.constraint(equalTo: frossGlass.topAnchor, constant: -20),
            switchSideBtn.trailingAnchor.constraint(equalTo: frossGlass.trailingAnchor, constant: -20),
            switchSideBtn.widthAnchor.constraint(equalToConstant: 160),
            switchSideBtn.heightAnchor.constraint(equalToConstant: 40)
        ])
        
    }
    
    //MARK: - switch buttons
    
    @objc func switchHandBtnTapped() {
        isLeftHand = !isLeftHand
        if isLeftHand {
            switchHandBtn.setTitle("已選擇左手", for: .normal)
        } else {
            switchHandBtn.setTitle("已選擇右手", for: .normal)
        }
        updateAcupointPositions()
    }

//    
//    var isBackHand = true
//    
//    @objc func switchSideBtnTapped() {
//        isBackHand = !isBackHand
//        updateAcupointPositions()
//    }
    
    //MARK: - setup VNRecognizedPoint
    
    var thumbTIP: VNRecognizedPoint?
    var thumbIP: VNRecognizedPoint?
    var thumbMP: VNRecognizedPoint?
    var thumbCMC: VNRecognizedPoint?
    
    var indexTIP: VNRecognizedPoint?
    var indexDIP: VNRecognizedPoint?
    var indexPIP: VNRecognizedPoint?
    var indexMCP: VNRecognizedPoint?
    
    var middleTIP: VNRecognizedPoint?
    var middleDIP: VNRecognizedPoint?
    var middlePIP: VNRecognizedPoint?
    var middleMCP: VNRecognizedPoint?
    
    var ringTIP: VNRecognizedPoint?
    var ringDIP: VNRecognizedPoint?
    var ringPIP: VNRecognizedPoint?
    var ringMCP: VNRecognizedPoint?
    
    var littleTIP: VNRecognizedPoint?
    var littleDIP: VNRecognizedPoint?
    var littlePIP: VNRecognizedPoint?
    var littleMCP: VNRecognizedPoint?
    var wrist: VNRecognizedPoint?
    // 設定預定義關節點
    
    //    var joiningValley: CGPoint {
    //        calculateOffsetPoint(point: thumbMP?.location, offsetX: 0, offsetY: 0.08)
    //    }
    //
    //    var innerPass: CGPoint {
    //        calculateOffsetPoint(point: wrist?.location, offsetX: 0.2
    //                             , offsetY: 0)
    //    }
    //
    //    var palaceOfToil: CGPoint {
    //        calculateMidPoint(point1: wrist?.location, point2: middleMCP?.location)
    //    }
    //
    //    var lesserSurge: CGPoint {
    //        calculateOffsetPoint(point: littleTIP?.location, offsetX: 0, offsetY: -0.009)
    //    }
    var joiningValley: CGPoint {
        if isLeftHand {
            calculateOffsetPoint(point: thumbMP?.location, offsetX: 0, offsetY: 0.1)
        } else {
            calculateOffsetPoint(point: thumbMP?.location, offsetX: 0, offsetY: 0.08)
        }
    }
    
    var innerPass: CGPoint {
        if isLeftHand {
            calculateOffsetPoint(point: wrist?.location, offsetX: -0.18, offsetY: 0.08)
        } else {
            calculateOffsetPoint(point: wrist?.location, offsetX: 0.19, offsetY: 0)
        }
    }
    
    var palaceOfToil: CGPoint {
        calculateMidPoint(point1: wrist?.location, point2: middleMCP?.location)
    }
    
    var lesserSurge: CGPoint {
        if isLeftHand {
            calculateOffsetPoint(point: littleTIP?.location, offsetX: -0.01, offsetY: -0.03)
        } else {
            calculateOffsetPoint(point: littleTIP?.location, offsetX: 0.02, offsetY: -0.009)
        }
    }
    
    //    func calculateOffsetPoint(point: CGPoint?, offsetX: CGFloat, offsetY: CGFloat) -> CGPoint {
    //        guard let point = point else { return .zero }
    //        return CGPoint(x: point.x + offsetX, y: point.y + offsetY)
    //    }
    
    func calculateOffsetPoint(point: CGPoint?, offsetX: CGFloat, offsetY: CGFloat) -> CGPoint {
        guard let point = point else { return .zero }
        if isLeftHand {
            return CGPoint(x: point.x - offsetX, y: point.y - offsetY)
        } else {
            return CGPoint(x: point.x + offsetX, y: point.y + offsetY)
        }
    }
    
    func calculateMidPoint(point1: CGPoint?, point2: CGPoint?) -> CGPoint {
        guard let point1 = point1, let point2 = point2 else { return .zero }
        return CGPoint(x: (point1.x + point2.x) / 2, y: (point1.y + point2.y) / 2)
    }
    
    // 應該是手點擊的功能
    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        guard let touch = touches.first else { return }
    //        let viewTouchLocation = touch.location(in: cameraVw)
    //
    //        // 將觸控點的座標轉換為 CALayer 的座標系統
    //        let touchLocationInLayer = cameraVw.layer.convert(viewTouchLocation, to: drawOverlay)
    //
    //        // 檢查觸控點是否在任何一個手部節點的範圍內
    //        for joint in HandJointService.shared.jointPoints {
    //            let jointPath = HandJointService.shared.createJointPath(for: joint, in: cameraVw.previewLayer!)
    //            if jointPath.contains(touchLocationInLayer) {
    //                print("Touched joint: \(joint)")
    //                break
    //            }
    //        }
    //    }
}

//MARK: - struct of Acupoint

struct HandAcupoint {
    let name: String
    let location: String
    let effect: String
    let method: String
    let frequency: String
    let notice: String
    let position: CGPoint
    let isBackHand: Bool
}
