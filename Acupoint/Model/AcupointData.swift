import UIKit
import Vision

let faceAcupoints: [FaceAcupointModel] = [
    FaceAcupointModel(
        name: "迎香穴",
        location: "鼻唇溝兩旁凹陷處",
        effect: "通鼻、利氣",
        method: "用手指指尖，點壓按摩迎香穴",
        frequency: "1次約 1分鐘",
        notice: "若有疼痛，請勿按壓",
        position: [746, 311]
    ),
    FaceAcupointModel(
        name: "人中穴",
        location: "人中凹陷處",
        effect: "清熱解毒、開竅醒腦",
        method: "用拇指指腹，點壓按摩人中穴",
        frequency: "1次約 30秒",
        notice: "按壓力度不宜過大",
        position: [3]
    ),
    FaceAcupointModel(
        name: "睛明穴",
        location: "眼內眥旁開1分",
        effect: "明目退翳、通絡止痛",
        method: "用食指或中指指腹，輕柔按摩睛明穴",
        frequency: "1次約 1分鐘",
        notice: "按摩時閉眼，動作宜輕柔",
        position: [1148, 1122]
    ),
    FaceAcupointModel(
        name: "承泣穴",
        location: "眼下眶骨凹陷處",
        effect: "疏肝明目、通絡止痛",
        method: "用中指指腹，輕柔按摩承泣穴",
        frequency: "1次約 1分鐘",
        notice: "按摩時閉眼，勿用力過度",
        position: [1115, 1141]
    ),
    FaceAcupointModel(
        name: "四白穴",
        location: "眼眶骨外眥旁開1分",
        effect: "疏風清熱、明目退翳",
        method: "用食指指腹，來回撫摩四白穴",
        frequency: "1次約 30秒",
        notice: "動作宜緩和輕柔，避免刺激眼睛",
        position: [381, 812]
    )
]

let handAcupoints: [HandAcupointModel] = [
    HandAcupointModel(
        name: "合谷穴",
        location: "虎口肌肉隆起處，大拇指與食指相接處",
        effect: "疏通經絡、緩解頭痛、牙痛、鼻塞等症狀",
        method: "用拇指指腹按壓合谷穴",
        frequency: "每天按壓 2-3 次，每次約 1-2 分鐘",
        notice: "按壓時若感到疼痛，可適當減輕力道",
        position: joiningValley,
        isBackHand: true),
    
    HandAcupointModel(
        name: "內關穴",
        location: "手腕橫紋上方兩寸，掌側兩筋之間",
        effect: "鎮靜安神、改善失眠、緩解心悸、胸悶等症狀",
        method: "用拇指或中指指腹按壓內關穴",
        frequency: "每天按壓 2-3 次，每次約 1-2 分鐘",
        notice: "按壓時若感到不適，可減輕力道或縮短按壓時間",
        position: innerPass,
        isBackHand: false),
    
    HandAcupointModel(
        name: "勞宮穴",
        location: "手掌心兩橫紋交叉處中點",
        effect: "養心安神、改善心悸、失眠、健忘等症狀",
        method: "用拇指指腹按壓勞宮穴",
        frequency: "每天按壓 2-3 次，每次約 1-2 分鐘",
        notice: "按壓時若感到不適，可減輕力道或縮短按壓時間",
        position: palaceOfToil,
        isBackHand: false),
    
    HandAcupointModel(
        name: "少沖穴",
        location: "小指尖端，指甲角旁",
        effect: "鎮靜安神、緩解心悸、失眠、健忘等症狀",
        method: "用拇指指腹按壓少沖穴",
        frequency: "每天按壓 2-3 次，每次約 1-2 分鐘",
        notice: "按壓時若感到不適，可減輕力道或縮短按壓時間",
        position: lesserSurge,
        isBackHand: true)
]

//:1 創建這些點，他們是VNRecognizedPoint
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
    calculateOffsetPoint(point: thumbMP?.location, offsetX: 0, offsetY: 0.08)
}

var innerPass: CGPoint {
    calculateOffsetPoint(point: wrist?.location, offsetX: 0.2
                         , offsetY: 0)
}

var palaceOfToil: CGPoint {
    calculateMidPoint(point1: wrist?.location, point2: middleMCP?.location)
}

var lesserSurge: CGPoint {
    calculateOffsetPoint(point: littleTIP?.location, offsetX: 0, offsetY: -0.009)
}

func calculateMidPoint(point1: CGPoint?, point2: CGPoint?) -> CGPoint {
    guard let pOne = point1, let pTwo = point2 else {
        return CGPoint.zero
    }
    let midX = (pOne.x + pTwo.x) / 2
    let midY = (pOne.y + pTwo.y) / 2
    return CGPoint(x: midX, y: midY)
}

func calculateOffsetPoint(point: CGPoint?, offsetX: CGFloat, offsetY: CGFloat) -> CGPoint {
    guard let point = point else {
        return CGPoint.zero
    }
    let newX = point.x + offsetX
    let newY = point.y + offsetY
    return CGPoint(x: newX, y: newY)
    
}
