import UIKit
import Vision

struct AcupointData {
    
    static let shared = AcupointData()
    
    //MARK: - Face Data
    
    let faceAcupoints: [FaceAcupointModel] = [
        FaceAcupointModel(
            name: "迎香穴",
            effect: "治鼻塞、鼻水、鼻炎、感冒",
            method: "用手指指尖，點壓按摩迎香穴",
            location: "鼻翼外緣的中點，旁開0.5寸處的鼻唇溝陷中",
            notice: "若有疼痛，請勿按壓",
            position: [746, 311]
        ),
        //        FaceAcupointModel(
        //            name: "人中穴",
        //            effect: "清熱解毒、開竅醒腦",
        //            method: "用拇指指腹，點壓按摩人中穴",
        //            location: "人中上1/3處",
        //            notice: "按壓力度不宜過大",
        //            position: [3]
        //        ),
        FaceAcupointModel(
            name: "睛明穴",
            effect: "眼精乾澀、眼壓大",
            method: "用食指或中指指腹，輕柔按摩睛明穴",
            location: "位於人的眼部內側，內眼角稍上方凹陷處",
            notice: "",
            position: [1148, 1122]
        ),
        
        FaceAcupointModel(
            name: "承泣穴",
            effect: "眼睛疲勞",
            method: "用中指指腹，輕柔按摩承泣穴",
            location: "瞳孔直下方0.7寸",
            notice: "切記要按在眼眶骨上，千萬不能直接按壓眼球",
            position: [1115, 1141]
        ),
        
        FaceAcupointModel(
            name: "四白穴",
            effect: "眼袋和下眼瞼浮腫、眼睛疲勞",
            method: "用食指指腹，來回撫摩四白穴",
            location: "瞳孔直下方2厘米",
            notice: "動作宜緩和輕柔，避免刺激眼睛",
            position: [381, 812]
        ),
        
        FaceAcupointModel(
            name: "攢竹穴",
            effect: "眼睛疲勞",
            method: "",
            location: "",
            notice: "",
            position: [420, 850]
        ),
        
        FaceAcupointModel(
            name: "承漿穴",
            effect: "提神醒腦、臉部神經麻痺、面腫",
            method: "",
            location: "",
            notice: "",
            position: [33]
        ),
        
        FaceAcupointModel(
            name: "印堂穴",
            effect: "前額痛、眩暈、鼻炎、感冒發熱",
            method: "",
            location: "",
            notice: "",
            position: [17]
        ),
        
        FaceAcupointModel(
            name: "地倉穴",
            effect: "齒痛、顏面神經失調",
            method: "",
            location: "",
            notice: "",
            position: [175, 623]
        ),
        
        FaceAcupointModel(
            name: "太陽穴",
            effect: "偏頭痛、目赤腫痛、目眩、目澀、牙痛、三叉神經痛",
            method: "",
            location: "",
            notice: "",
            position: [215,  1013]
        ),
        
        FaceAcupointModel(
            name: "下關穴",
            effect: "耳聾、耳鳴、牙關開合不利",
            method: "",
            location: "",
            notice: "",
            position: [939, 1008]
        )
    ]
    
    //MARK: - Hand Data
    
    //因爲position是計算屬性，所以要用lazy
    var handAcupoints: [HandAcupointModel] {
       return [
           HandAcupointModel(
               name: "合谷穴",
               effect: "疏通經絡、緩解頭痛、牙痛、鼻塞等症狀",
               method: "用拇指指腹按壓合谷穴",
               location: "手部虎口，大拇指與食指相接處",
               notice: "按壓時若感到疼痛，可適當減輕力道",
               basePoint: [.thumbMP],
               offSet: joiningValley,
               isBackHand: true
           ),
           
           HandAcupointModel(
               name: "少沖穴",
               effect: "鎮靜安神、緩解心悸、失眠、健忘等症狀",
               method: "用拇指指腹按壓少沖穴",
               location: "小指指甲內側下缘",
               notice: "按壓時若感到不適，可減輕力道或縮短按壓時間",
               basePoint: [.littleTip],
               offSet: lesserSurge,
               isBackHand: true
           ),
           
           HandAcupointModel(
               name: "內關穴",
               effect: "鎮靜安神、改善失眠、緩解心悸、胸悶等症狀",
               method: "用拇指或中指指腹按壓內關穴",
               location: "手腕橫紋中點往下三橫指寬處",
               notice: "按壓時若感到不適，可減輕力道或縮短按壓時間",
               basePoint: [.wrist],
               offSet: innerPass,
               isBackHand: false
           ),
           
           HandAcupointModel(
               name: "勞宮穴",
               effect: "養心安神、改善心悸、失眠、健忘等症狀",
               method: "用拇指指腹按壓勞宮穴",
               location: "握拳，中指紙尖對應的掌心中央處",
               notice: "按壓時若感到不適，可減輕力道或縮短按壓時間",
               basePoint: [.wrist, .middleMCP],
               offSet: palaceOfToil,
               isBackHand: false
           )
       ]
    }
    
    
    var middleMCP: VNRecognizedPoint?
    var wrist: VNRecognizedPoint?
    
    
    var isLeftHand: Bool = false
    
    var joiningValley: CGPoint {
        return isLeftHand ? CGPoint(x: 0, y: 0.1) : CGPoint(x: 0, y: 0.08)
    }
    
    var innerPass: CGPoint {
        return isLeftHand ? CGPoint(x: -0.18, y: 0.08) : CGPoint(x: 0.19, y: 0)
    }
    
    var palaceOfToil: CGPoint {
        return calculateMidPoint(point1: wrist?.location, point2: middleMCP?.location)
    }
    
    var lesserSurge: CGPoint {
        return isLeftHand ? CGPoint(x: -0.01, y: -0.03) : CGPoint(x: 0.02, y: -0.009)
    }
    
    //    func calculateOffsetPoint(point: CGPoint?, offsetX: CGFloat, offsetY: CGFloat) -> CGPoint {
    //        guard let point = point else { return .zero }
    //        if isLeftHand {
    //            return CGPoint(x: point.x - offsetX, y: point.y - offsetY)
    //        } else {
    //            return CGPoint(x: point.x + offsetX, y: point.y + offsetY)
    //        }
    //    }
    //
    func calculateMidPoint(point1: CGPoint?, point2: CGPoint?) -> CGPoint {
        guard let point1 = point1, let point2 = point2 else { return .zero }
        return CGPoint(x: (point1.x + point2.x) / 2, y: (point1.y + point2.y) / 2)
    }
    
}

