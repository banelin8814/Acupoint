import UIKit
import ARKit

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
    
    private var observation: VNHumanHandPoseObservation?
    
    private var isLeftHand: Bool = false
    
    private let videoDataOutputQueue = DispatchQueue(label: "CameraFeedDataOutput", qos: .userInteractive)
    
    //selected
    //負責給畫點的位置 selectedAcupointPosition = handAcupoints[self.acupointIndex].position
    var acupointIndex: Int = 0
    
    enum DisplayMode {
        case allPoint
        case specific(name: String)
    }
    
    var currentDisplayMode: DisplayMode = .allPoint
    
    var selectedAcupointOffset: CGPoint = .zero
    
    //data
    var acupoitData = AcupointData.shared
    //有時候被賦予一個，或全部的點
    lazy var handPoints: [HandAcupointModel] = {
        return acupoitData.handAcupoints
    }()
    var numberOfAcupoints = 1
    //graphic
    let drawOverlay = CAShapeLayer()
    
    let drawPath = UIBezierPath()
    
    var jointPoints: [VNRecognizedPoint] = []
    
    lazy var handOutlineImg: UIImageView = {
        let handOutlineImg = UIImageView()
        handOutlineImg.image = UIImage(named: "handOutline")
        handOutlineImg.translatesAutoresizingMaskIntoConstraints = false
        handOutlineImg.backgroundColor = .clear
        return handOutlineImg
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
        let layout = UICollectionViewFlowLayout()
        // 在这里设置 layout 的属性
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        
        collectionView.register(InfoCollectionViewCell.self, forCellWithReuseIdentifier: "InfoCollectionViewCell")
        return collectionView
    }()
    //updateCurrentPage偵測index給currentPage，被賦予新的值後，執行邏輯。
    
    var selectedNameByCell: String = "" {
        didSet {
            
        }
    }
    var currentPage: Int = 0 {
        didSet {
            if oldValue != currentPage {
                print("The page changed to \(currentPage)")
                getNameByIndex(currentPage)
                updateAcupointPositions()
            }
        }
    }
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //偵測
        collectionView.collectionViewLayout = collectionViewLayoutFromProtocol(collectionView: collectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.addSubview(leftRightSegmentedControl)
        view.addSubview(handSideSegmentedControl)
        view.addSubview(collectionView)
        view.addSubview(handOutlineImg)
        
        drawOverlay.frame = view.layer.bounds
        drawOverlay.lineWidth = 40
        drawOverlay.fillColor = .none
        view.layer.addSublayer(drawOverlay)
        
        setUpUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateCurrentPage(collectionView: collectionView)
        
        
        if numberOfAcupoints == 1 {
            
            let promptVC = PromptVC()
            handPoints = acupoitData.handAcupoints
            promptVC.promptNameLbl.text = handPoints[acupointIndex].name
            promptVC.promptPostionLbl.text = handPoints[acupointIndex].location
            promptVC.promptEffectLbl.text = handPoints[acupointIndex].effect
            present(promptVC, animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        do {
            if cameraFeedSession == nil {
                if let cameraPreviewLayer = cameraVw.previewLayer {
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
    func setUpUI() {
        
        NSLayoutConstraint.activate([
            leftRightSegmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
            leftRightSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            leftRightSegmentedControl.widthAnchor.constraint(equalToConstant: 90),
            leftRightSegmentedControl.heightAnchor.constraint(equalToConstant: 30),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            collectionView.heightAnchor.constraint(equalToConstant: 130),
            
            handSideSegmentedControl.topAnchor.constraint(equalTo: leftRightSegmentedControl.bottomAnchor, constant: 30),
            handSideSegmentedControl.leadingAnchor.constraint(equalTo: leftRightSegmentedControl.leadingAnchor),
            handSideSegmentedControl.widthAnchor.constraint(equalToConstant: 90),
            handSideSegmentedControl.heightAnchor.constraint(equalToConstant: 30)
            
//            handOutlineImg.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 50),
//            handOutlineImg.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            handOutlineImg.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
//            handOutlineImg.heightAnchor.constraint(equalTo: handOutlineImg.widthAnchor)
        ])
    }
    
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
                HandJointService.shared.drawCustomJoints(on: self.drawOverlay, with: self.drawPath, in: cameraPreviewLayer, observation: self.observation!, with: self.selectedAcupointOffset)
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
        
        var acupointPaths: [(path: UIBezierPath, acupoint: HandAcupointModel)] = []
        
        handPoints = acupoitData.handAcupoints
        
        if numberOfAcupoints == 1 {
            let selectedAcupoint = handPoints[acupointIndex]
            let basePoints = selectedAcupoint.basePoint.map { try? observation?.recognizedPoint($0) }
            let offsetPosition = selectedAcupoint.offSet
            
            let path = UIBezierPath()
            let actualPosition = calculateActualPosition(basePoints: basePoints, offsetPosition: offsetPosition)
            
            DispatchQueue.main.async { [self] in
                guard let cameraPreviewLayer = self.cameraVw.previewLayer, let observation = observation else { return }
                HandJointService.shared.drawCustomJoints(on: self.drawOverlay, with: path, in: cameraPreviewLayer, observation: observation, with: actualPosition)
                acupointPaths.append((path, selectedAcupoint))
            }
        } else {
            DispatchQueue.main.async { [self] in
                
                let isBackHand = handSideSegmentedControl.selectedSegmentIndex == 0
                
                let filteredAcupoints = handPoints.filter { $0.isBackHand == isBackHand }
                
                for acupoint in filteredAcupoints {
                    let basePoints = acupoint.basePoint.map { try? observation?.recognizedPoint($0) }
                    let offsetPosition = acupoint.offSet
                    
                    let path = UIBezierPath()
                    let actualPosition = calculateActualPosition(basePoints: basePoints, offsetPosition: offsetPosition)
                    
                    guard let cameraPreviewLayer = self.cameraVw.previewLayer, let observation = observation else { return }
                    HandJointService.shared.drawCustomJoints(on: self.drawOverlay, with: path, in: cameraPreviewLayer, observation: observation, with: actualPosition)
                    acupointPaths.append((path, acupoint))
                }
            }
        }
        
        DispatchQueue.main.async { [self] in
            
            //更新當前頁面的名字
            updateCurrentPage(collectionView: collectionView)
            
            // 移除先前的子层
            self.drawOverlay.sublayers?.forEach { $0.removeFromSuperlayer() }
            
            // 为每个穴位路径创建一个新的子层
            for (path, acupoint ) in acupointPaths {
                let shapeLayer = CAShapeLayer()
                shapeLayer.path = path.cgPath
                shapeLayer.fillColor = UIColor.white.cgColor
                shapeLayer.fillColor = (acupoint.name == selectedNameByCell) ? UIColor.white.withAlphaComponent(0.45).cgColor : UIColor.white.cgColor
                
                shapeLayer.lineWidth = 10
                self.drawOverlay.addSublayer(shapeLayer)
            }
        }
    }
    
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
    
    func calculateActualPosition(basePoints: [VNRecognizedPoint?], offsetPosition: CGPoint) -> CGPoint {
        guard let firstPoint = basePoints.first??.location else { return .zero }
        
        if basePoints.count == 1 {
            return calculateOffsetPoint(point: firstPoint, offsetX: offsetPosition.x, offsetY: offsetPosition.y)
            
        } else if basePoints.count == 2, let secondPoint = basePoints[1]?.location {
            let midPoint = calculateMidPoint(point1: firstPoint, point2: secondPoint)
            return midPoint
        }
        return .zero
    }
    //MARK: - @Objc
    @objc func leftRightSegmentedControlValueChanged() {
        DispatchQueue.main.async {
            self.isLeftHand = self.leftRightSegmentedControl.selectedSegmentIndex == 0
            self.acupoitData.isLeftHand = self.isLeftHand
            self.updateAcupointPositions()
            //更新當前cell的名字
            self.getNameByIndex(self.currentPage)
            self.updateAcupointPositions()
            
//            if self.isLeftHand {
//                self.handOutlineImg.transform = CGAffineTransform(scaleX: -1, y: 1)
//            } else {
//                self.handOutlineImg.transform = CGAffineTransform.identity
//            }
//            if self.isBackHand {
//                
//            }
        }
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
            let filteredAcupoints = handPoints.filter({ $0.isBackHand == isBackHand })
            acupoint = filteredAcupoints[indexPath.item]
            cell.configureHandDataFromWikiVC(with: acupoint)
            
            
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //animation
        let detailVC = DetailVC()
        detailVC.isHandPoint = true
        if let cell = collectionView.cellForItem(at: indexPath) as? InfoCollectionViewCell {
            detailVC.theName = cell.acupointNameLabel.text
        }
        detailVC.modalPresentationStyle = .custom
        present(detailVC, animated: true, completion: nil)
    }
}

extension HandVC: NameSelectionDelegate, CurrentPageUpdatable {
    
    func getNameByIndex(_ index: Int) {
        let acupoint = handPoints[index]
        selectedNameByCell = acupoint.name
        updateAcupointPositions()
    }
}



