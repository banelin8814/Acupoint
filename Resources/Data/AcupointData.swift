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
            notice: """
                1.出血傾向或服用抗凝血劑者，避免力道大的按摩。
                2.局部感染發炎處，應避開按摩。
                3.過度虛弱、空腹或無力時，避免按摩，以免反應過激。
                4.全身性發炎或自體免疫疾病，須注意按摩力道。
                """,
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
            notice:"""
                1.出血傾向或服用抗凝血劑者，避免力道大的按摩。
                2.局部感染發炎處，應避開按摩。
                3.過度虛弱、空腹或無力時，避免按摩，以免反應過激。
                4.全身性發炎或自體免疫疾病，須注意按摩力道。
                """,
            position: [1148, 1122]
        ),
        
        FaceAcupointModel(
            name: "承泣穴",
            effect: "眼睛疲勞",
            method: "用中指指腹，輕柔按摩承泣穴",
            location: "瞳孔直下方0.7寸",
            notice:"""
                1.出血傾向或服用抗凝血劑者，避免力道大的按摩。
                2.局部感染發炎處，應避開按摩。
                3.過度虛弱、空腹或無力時，避免按摩，以免反應過激。
                4.全身性發炎或自體免疫疾病，須注意按摩力道。
                """,
            position: [1115, 1141]
        ),
        
        FaceAcupointModel(
            name: "四白穴",
            effect: "眼袋和下眼瞼浮腫、眼睛疲勞",
            method: "用食指指腹，來回撫摩四白穴",
            location: "瞳孔直下方2厘米",
            notice:"""
                1.出血傾向或服用抗凝血劑者，避免力道大的按摩。
                2.局部感染發炎處，應避開按摩。
                3.過度虛弱、空腹或無力時，避免按摩，以免反應過激。
                4.全身性發炎或自體免疫疾病，須注意按摩力道。
                """,
            position: [381, 812]
        ),
        
        FaceAcupointModel(
            name: "攢竹穴",
            effect: "眼睛疲勞",
            method: "",
            location: "",
            notice:"""
                1.出血傾向或服用抗凝血劑者，避免力道大的按摩。
                2.局部感染發炎處，應避開按摩。
                3.過度虛弱、空腹或無力時，避免按摩，以免反應過激。
                4.全身性發炎或自體免疫疾病，須注意按摩力道。
                """,
            position: [420, 850]
        ),
        
        FaceAcupointModel(
            name: "承漿穴",
            effect: "提神醒腦、臉部神經麻痺、面腫",
            method: "",
            location: "",
            notice: """
                1.出血傾向或服用抗凝血劑者，避免力道大的按摩。
                2.局部感染發炎處，應避開按摩。
                3.過度虛弱、空腹或無力時，避免按摩，以免反應過激。
                4.全身性發炎或自體免疫疾病，須注意按摩力道。
                """,
            position: [33]
        ),
        
        FaceAcupointModel(
            name: "印堂穴",
            effect: "前額痛、眩暈、鼻炎、感冒發熱",
            method: "",
            location: "",
            notice: """
                1.出血傾向或服用抗凝血劑者，避免力道大的按摩。
                2.局部感染發炎處，應避開按摩。
                3.過度虛弱、空腹或無力時，避免按摩，以免反應過激。
                4.全身性發炎或自體免疫疾病，須注意按摩力道。
                """,
            position: [17]
        ),
        
        FaceAcupointModel(
            name: "地倉穴",
            effect: "齒痛、顏面神經失調",
            method: "",
            location: "",
            notice:"""
                1.出血傾向或服用抗凝血劑者，避免力道大的按摩。
                2.局部感染發炎處，應避開按摩。
                3.過度虛弱、空腹或無力時，避免按摩，以免反應過激。
                4.全身性發炎或自體免疫疾病，須注意按摩力道。
                """,
            position: [175, 623]
        ),
        
        FaceAcupointModel(
            name: "太陽穴",
            effect: "偏頭痛、目赤腫痛、目眩、目澀、牙痛、三叉神經痛",
            method: "",
            location: "",
            notice: """
                1.出血傾向或服用抗凝血劑者，避免力道大的按摩。
                2.局部感染發炎處，應避開按摩。
                3.過度虛弱、空腹或無力時，避免按摩，以免反應過激。
                4.全身性發炎或自體免疫疾病，須注意按摩力道。
                """,
            position: [215,  1013]
        ),
        
        FaceAcupointModel(
            name: "下關穴",
            effect: "耳聾、耳鳴、牙關開合不利",
            method: "",
            location: "",
            notice: """
                1.出血傾向或服用抗凝血劑者，避免力道大的按摩。
                2.局部感染發炎處，應避開按摩。
                3.過度虛弱、空腹或無力時，避免按摩，以免反應過激。
                4.全身性發炎或自體免疫疾病，須注意按摩力道。
                """,
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
                notice:"""
                1.出血傾向或服用抗凝血劑者，避免力道大的按摩。
                2.局部感染發炎處，應避開按摩。
                3.過度虛弱、空腹或無力時，避免按摩，以免反應過激。
                4.全身性發炎或自體免疫疾病，須注意按摩力道。
                """,
                basePoint: [.thumbMP],
                offSet: joiningValley,
                isBackHand: true
            ),
            
            HandAcupointModel(
                name: "少沖穴",
                effect: "鎮靜安神、緩解心悸、失眠、健忘等症狀",
                method: "用拇指指腹按壓少沖穴",
                location: "小指指甲內側下缘",
                notice: """
                1.出血傾向或服用抗凝血劑者，避免力道大的按摩。
                2.局部感染發炎處，應避開按摩。
                3.過度虛弱、空腹或無力時，避免按摩，以免反應過激。
                4.全身性發炎或自體免疫疾病，須注意按摩力道。
                """,
                basePoint: [.littleTip],
                offSet: lesserSurge,
                isBackHand: true
            ),
            
            HandAcupointModel(
                name: "內關穴",
                effect: "鎮靜安神、改善失眠、緩解心悸、胸悶等症狀",
                method: "用拇指或中指指腹按壓內關穴",
                location: "手腕橫紋中點往下三橫指寬處",
                notice:"""
                1.出血傾向或服用抗凝血劑者，避免力道大的按摩。
                2.局部感染發炎處，應避開按摩。
                3.過度虛弱、空腹或無力時，避免按摩，以免反應過激。
                4.全身性發炎或自體免疫疾病，須注意按摩力道。
                """,
                basePoint: [.wrist],
                offSet: innerPass,
                isBackHand: false
            ),
            
            HandAcupointModel(
                name: "勞宮穴",
                effect: "養心安神、改善心悸、失眠、健忘等症狀",
                method: "用拇指指腹按壓勞宮穴",
                location: "握拳，中指紙尖對應的掌心中央處",
                notice: """
                1.出血傾向或服用抗凝血劑者，避免力道大的按摩。
                2.局部感染發炎處，應避開按摩。
                3.過度虛弱、空腹或無力時，避免按摩，以免反應過激。
                4.全身性發炎或自體免疫疾病，須注意按摩力道。
                """,
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
    
    func calculateMidPoint(point1: CGPoint?, point2: CGPoint?) -> CGPoint {
        guard let point1 = point1, let point2 = point2 else { return .zero }
        return CGPoint(x: (point1.x + point2.x) / 2, y: (point1.y + point2.y) / 2)
    }
    
    
    var commonAcupoint: [CommonModel] {
        return [
            CommonModel(categoryName: "頭痛",
                        description: "穴位按摩能緩解頭部緊繃,促進血液循環,減輕頭痛不適。來試試按摩太陽穴、印堂等穴位吧,讓疼痛隨著指尖的溫柔撫觸而煙消雲散。給自己一個放鬆的時刻,讓穴位按摩帶你遠離頭痛的困擾!",
                        acupoints: [
                            Acupoint(name: "太陽穴", image: "透明臉"),                 
                            Acupoint(name: "印堂穴", image: "透明臉"),
                            Acupoint(name: "風池穴", image: "透明臉"),
                            Acupoint(name: "百會穴", image: "透明臉")
                        ]),
            
            CommonModel(categoryName: "助眠",
                        description:
                            "穴位按摩能調節自律神經系統，減少交感神經活動，提高副交感神經活動，幫助我們放鬆入睡。給自己的穴位來個放鬆的按摩吧，讓這些神奇的穴道帶你進入甜美夢鄉！",
                        acupoints: [
                            Acupoint(name: "神門穴", image: "透明手"),
                            Acupoint(name: "內關穴", image: "透明手"),
                            Acupoint(name: "百會穴", image: "透明臉"),
                            Acupoint(name: "印堂穴", image: "透明臉")
                        ]),
            
            CommonModel(categoryName: "美顏",
                        description: "穴位按摩能刺激經絡,改善膚質,讓你的肌膚煥發自然光采。來按摩迎香、四白等穴位吧,感受面部肌肉的放鬆,血液循環的加快。這些神奇的穴道,將喚醒你肌膚的活力,打造明亮動人的美顏!",
                        acupoints: [
                            Acupoint(name: "迎香穴", image: "透明臉"),
                            Acupoint(name: "四白穴", image: "透明臉"),
                            Acupoint(name: "地倉穴", image: "透明臉"),
                            Acupoint(name: "頰車穴", image: "透明臉")
                        ]),
            
            CommonModel(categoryName: "眼睛疲勞",
                        description: "長時間用眼過度,眼睛容易疲勞酸澀。不妨試試穴位按摩,舒緩眼部肌肉緊張。按摩睛明、攢竹、絲竹空等穴位,促進眼部血液循環,緩解疲勞。給雙眼一個放鬆的時刻,讓穴位按摩帶你遠離眼睛的不適,重現明亮雙眸!",
                        acupoints: [
                            Acupoint(name: "睛明穴", image: "透明臉"),
                            Acupoint(name: "攢竹穴", image: "透明臉"),
                            Acupoint(name: "絲竹空穴", image: "透明臉"),
                            Acupoint(name: "承泣穴", image: "透明臉")
                        ])
        ]
    }
}

