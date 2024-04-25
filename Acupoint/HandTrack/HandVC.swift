import UIKit
import ARKit
import CHGlassmorphismView

class HandVC: UIViewController, ARSCNViewDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    //MARK: - property
    private var cameraVw: CameraView {
        return view as? CameraView ?? CameraView() //為什麼要這樣寫？
    }
    override func loadView() {
        view = CameraView()
    }
    
    private var cameraFeedSession: AVCaptureSession?
    
    private var handPoseRequest: VNDetectHumanHandPoseRequest = {
        let request = VNDetectHumanHandPoseRequest()
        request.maximumHandCount = 1
        return request
    }()
    
    var observation: VNHumanHandPoseObservation?
    
    var isLeftHand: Bool = false
    
    private let videoDataOutputQueue = DispatchQueue(label: "CameraFeedDataOutput", qos: .userInteractive)

    //selected
    //負責給畫點的位置 selectedAcupointPosition = handAcupoints[self.acupointIndex].position
    var acupointIndex: Int = 2
    
    enum DisplayMode {
        case allPoint
        case specific(name: String)
    }
    
    var currentDisplayMode: DisplayMode = .allPoint
    
    var selectedAcupointPosition: CGPoint = .zero
    
    var selectedNameByCell: String?
    //data
    var acupoitData = AcupointData.shared
    //有時候被賦予一個，或全部的點
    lazy var handPoints: [HandAcupointModel] = {
        return acupoitData.handAcupoints
    }()
    //    graphic
    let drawOverlay = CAShapeLayer()
    
    let drawPath = UIBezierPath()
    
    var jointPoints: [VNRecognizedPoint] = []
    
    //UI
    lazy var tranparentVw: UIView = {
           let view = UIView()
           let gradientLayer = CAGradientLayer()
           gradientLayer.frame = view.bounds
           gradientLayer.colors = [UIColor.gray.cgColor, UIColor.clear.cgColor]
           view.layer.insertSublayer(gradientLayer, at: 0)
           view.translatesAutoresizingMaskIntoConstraints = false
           return view
       }()
    
    lazy var leftRightSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["左手", "右手"])
        segmentedControl.selectedSegmentIndex = 1 // 默認選擇右手
        segmentedControl.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        segmentedControl.selectedSegmentTintColor = .white
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        segmentedControl.layer.masksToBounds = true
        // 設置選中的色塊的圓角
        let selectedSegmentView = segmentedControl.subviews[segmentedControl.selectedSegmentIndex]
        segmentedControl.addTarget(self, action: #selector(leftRightSegmentedControlValueChanged), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    lazy var handSideSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["手背", "手心"])
        segmentedControl.selectedSegmentIndex = 0 // 默认选择手背
        segmentedControl.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        segmentedControl.selectedSegmentTintColor = .white
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        segmentedControl.layer.masksToBounds = true
        segmentedControl.addTarget(self, action: #selector(handSideSegmentedControlValueChanged), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(InfoCollectionViewCell.self, forCellWithReuseIdentifier: "InfoCollectionViewCell")
        return collectionView
    }()
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(tranparentVw)

        view.addSubview(leftRightSegmentedControl)
        view.addSubview(handSideSegmentedControl)
        view.addSubview(collectionView)
        
        drawOverlay.frame = view.layer.bounds
        drawOverlay.lineWidth = 40
        drawOverlay.fillColor = .none
        view.layer.addSublayer(drawOverlay)

        
        tranparentVw.frame = view.bounds
          
          // 創建漸變層並設置其 frame
          let gradientLayer = CAGradientLayer()
          gradientLayer.frame = tranparentVw.bounds
          gradientLayer.colors = [UIColor.gray.cgColor, UIColor.clear.cgColor]
          gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
          gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
          gradientLayer.locations = [0, 0.6]
          tranparentVw.layer.insertSublayer(gradientLayer, at: 0)


        setUpUI()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //intro Page
        let introVC = IntroVC()
        introVC.introNameLbl.text = handPoints[0].name
        introVC.introPostionLbl.text = handPoints[0].positionDescibition

        present(introVC, animated: true, completion: nil)
        
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
                HandJointService.shared.drawCustomJoints(on: self.drawOverlay, with: self.drawPath, in: cameraPreviewLayer, observation: self.observation!, with: self.selectedAcupointPosition)
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
        
        let handAcupoints: [HandAcupointModel] = [
            HandAcupointModel(
                name: "合谷穴",
                effect: "疏通經絡、緩解頭痛、牙痛、鼻塞等症狀",
                method: "用拇指指腹按壓合谷穴",
                location: "手部虎口，大拇指與食指相接處",
                notice: "按壓時若感到疼痛，可適當減輕力道",
                position: joiningValley,
                isBackHand: true),
            
            HandAcupointModel(
                name: "少沖穴",
                effect: "鎮靜安神、緩解心悸、失眠、健忘等症狀",
                method: "用拇指指腹按壓少沖穴",
                location: "小指指甲內側下缘",
                notice: "按壓時若感到不適，可減輕力道或縮短按壓時間",
                position: lesserSurge,
                isBackHand: true),
            
            HandAcupointModel(
                name: "內關穴",
                effect: "鎮靜安神、改善失眠、緩解心悸、胸悶等症狀",
                method: "用拇指或中指指腹按壓內關穴",
                location: "手腕橫紋中點往下三橫指寬處",
                notice: "按壓時若感到不適，可減輕力道或縮短按壓時間",
                position: innerPass,
                isBackHand: false),
            
            HandAcupointModel(
                name: "勞宮穴",
                effect: "養心安神、改善心悸、失眠、健忘等症狀",
                method: "用拇指指腹按壓勞宮穴",
                location: "握拳，中指紙尖對應的掌心中央處",
                notice: "按壓時若感到不適，可減輕力道或縮短按壓時間",
                position: palaceOfToil,
                isBackHand: false)
        ]
        
        selectedAcupointPosition = handAcupoints[self.acupointIndex].position
        
        // 如果是一個
        if handPoints.count == 1 {
            var acupointPaths: [UIBezierPath] = []
                            
//                let position = handPoints[acupointIndex].position
                let path = UIBezierPath()
                
                DispatchQueue.main.async { [self] in
                    guard let cameraPreviewLayer = self.cameraVw.previewLayer, let observation = observation else { return }
                    HandJointService.shared.drawCustomJoints(on: self.drawOverlay, with: path, in: cameraPreviewLayer, observation: observation, with: selectedAcupointPosition)
                    acupointPaths.append(path)
                }
           

            DispatchQueue.main.async { [self] in
                // 移除先前的子層
                self.drawOverlay.sublayers?.forEach { $0.removeFromSuperlayer() }
                
                // 為每個穴位路徑創建一個新的子層
                for path in acupointPaths {
                    let shapeLayer = CAShapeLayer()
                    shapeLayer.path = path.cgPath
                    shapeLayer.fillColor = UIColor.white.cgColor
                    shapeLayer.lineWidth = 10
                    self.drawOverlay.addSublayer(shapeLayer)
                }
            }
        // 如果是很多個
        } else {
            
            var acupointPaths: [(path: UIBezierPath, acupoint: HandAcupointModel)] = []

            DispatchQueue.main.async { [self] in
                let isBackHand = handSideSegmentedControl.selectedSegmentIndex == 0
                
                for acupoint in handAcupoints {
                    let position = acupoint.position
                    let path = UIBezierPath()
                    
                    guard let cameraPreviewLayer = self.cameraVw.previewLayer, let observation = observation else { continue }
                    HandJointService.shared.drawCustomJoints(on: self.drawOverlay, with: path, in: cameraPreviewLayer, observation: observation, with: position)
                    acupointPaths.append((path, acupoint))
                }
                
                // 移除先前的子層
                self.drawOverlay.sublayers?.forEach { $0.removeFromSuperlayer() }
                
                // 為每個穴位路徑創建一個新的子層
                for (path, acupoint) in acupointPaths {
                    if acupoint.isBackHand == isBackHand {
                        let shapeLayer = CAShapeLayer()
                        shapeLayer.path = path.cgPath
                        shapeLayer.fillColor = (acupoint.name == selectedNameByCell) ? UIColor.systemRed.cgColor : UIColor.white.cgColor
                        shapeLayer.lineWidth = 10
                        self.drawOverlay.addSublayer(shapeLayer)
                    }
                }
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
    
    
    func setUpUI() {
        
        NSLayoutConstraint.activate([
            
            leftRightSegmentedControl.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 0),
            leftRightSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            leftRightSegmentedControl.widthAnchor.constraint(equalToConstant: 120),
            leftRightSegmentedControl.heightAnchor.constraint(equalToConstant: 30),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            collectionView.heightAnchor.constraint(equalToConstant: 130),
            
            handSideSegmentedControl.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 0),
            handSideSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            handSideSegmentedControl.widthAnchor.constraint(equalToConstant: 120),
            handSideSegmentedControl.heightAnchor.constraint(equalToConstant: 30),
            
            tranparentVw.topAnchor.constraint(equalTo: view.topAnchor),
            tranparentVw.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tranparentVw.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tranparentVw.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            
            
        ])
    }
    
    //MARK: - @Objc
    
    @objc func leftRightSegmentedControlValueChanged() {
        DispatchQueue.main.async {
            self.isLeftHand = self.leftRightSegmentedControl.selectedSegmentIndex == 0
            print(self.isLeftHand)
        }
        updateAcupointPositions()
    }
    
    @objc func handSideSegmentedControlValueChanged() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        updateAcupointPositions()
    }
    
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

//MARK: - collectionView delegate

extension HandVC: UICollectionViewDelegate, UICollectionViewDataSource {
    // UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch currentDisplayMode {
        case .allPoint:
            let isBackHand = handSideSegmentedControl.selectedSegmentIndex == 0
            let filteredAcupoints = handPoints.filter { $0.isBackHand == isBackHand }
            return filteredAcupoints.count
            //                return handPoints.count
        case .specific:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoCollectionViewCell", for: indexPath) as? InfoCollectionViewCell else { return InfoCollectionViewCell()}
        let acupoint: HandAcupointModel
        switch currentDisplayMode {
        case .allPoint:
            let isBackHand = handSideSegmentedControl.selectedSegmentIndex == 0
            let filteredAcupoints = handPoints.filter( { $0.isBackHand == isBackHand})
            acupoint = filteredAcupoints[indexPath.item]
            cell.configureHandDataFromWikiVC(with: acupoint)
            //                acupoint = handPoints[indexPath.item]
        case .specific(let name):
            if let index = handPoints.firstIndex(where: { $0.name == name }) {
                acupoint = handPoints[index]
                cell.configureHandDataFromSearchVC(with: acupoint)
            } else {
                return cell
            }
        }
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if indexPath.item == 0 {
//            let acupoint = handPoints[0]
//            selectedNameByCell = acupoint.name
//        } else {
//            let acupoint = handPoints[indexPath.item - 1]
//            selectedNameByCell = acupoint.name
//        }
//        updateAcupointPositions()
//    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
           let visibleCells = collectionView.visibleCells
           if let currentCell = visibleCells.first as? InfoCollectionViewCell {
               if let labelText = currentCell.acupointNameLabel.text {
                   selectedNameByCell = labelText
                   updateAcupointPositions()
                   print("Current label text: \(labelText)")
               }
           }
       }
}

extension HandVC {
    func collectionViewLayout() -> UICollectionViewLayout {
        
        let galleryItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                    heightDimension: .fractionalHeight(1.0)))
        galleryItem.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
        
        let galleryGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85),
                                                                                                 heightDimension: .fractionalHeight(1)),
                                                              subitem: galleryItem, count: 1)
        
        let gallerySection = NSCollectionLayoutSection(group: galleryGroup)
        gallerySection.orthogonalScrollingBehavior = .groupPagingCentered
        
        let layout = UICollectionViewCompositionalLayout(section: gallerySection)
        return layout
        
    }
}

