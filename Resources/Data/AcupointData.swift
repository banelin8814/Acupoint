import UIKit
import Vision

struct AcupointData {
    
    static let shared = AcupointData()
    
    //MARK: - Face Data
    let faceAcupoints: [FaceAcupointModel] = [
        FaceAcupointModel(
            name: "迎香穴",
            effect: "治鼻塞、鼻水、鼻炎、感冒",
            method: "食指指尖，按壓穴道5秒鐘，休息5秒鐘",
            location: "鼻翼外緣的中點，旁開0.5寸處的鼻唇溝陷中",
            notice: """
                1.出血傾向或服用抗凝血劑者，避免力道大的按摩
                2.局部感染發炎處，應避開按摩
                3.過度虛弱、空腹或無力時，避免按摩，以免反應過激
                4.全身性發炎或自體免疫疾病，須注意按摩力道
                """,
            position: [746, 311]
        ),
        FaceAcupointModel(
            name: "人中穴",
            effect: "清熱解毒、開竅醒腦",
            method: "食指指腹向斜上方按揉",
            location: "人中上1/3處",
            notice: """
                 1.出血傾向或服用抗凝血劑者，避免力道大的按摩
                 2.局部感染發炎處，應避開按摩
                 3.過度虛弱、空腹或無力時，避免按摩，以免反應過激
                 4.全身性發炎或自體免疫疾病，須注意按摩力道
                """,
            position: [3]
        ),
        FaceAcupointModel(
            name: "睛明穴",
            effect: "眼睛乾澀、眼壓大",
            method: "大拇指按、揉此穴",
            location: "位於人的眼部內側，內眼角稍上方凹陷處",
            notice:"""
                1.出血傾向或服用抗凝血劑者，避免力道大的按摩
                2.局部感染發炎處，應避開按摩
                3.過度虛弱、空腹或無力時，避免按摩，以免反應過激
                4.全身性發炎或自體免疫疾病，須注意按摩力道
                """,
            position: [1148, 1122]
        ),
        
        FaceAcupointModel(
            name: "承泣穴",
            effect: "眼睛疲勞",
            method: "拇指持續往眼眶方向推壓",
            location: "瞳孔直下方0.7寸",
            notice:"""
                1.出血傾向或服用抗凝血劑者，避免力道大的按摩
                2.局部感染發炎處，應避開按摩
                3.過度虛弱、空腹或無力時，避免按摩，以免反應過激
                4.全身性發炎或自體免疫疾病，須注意按摩力道
                """,
            position: [1115, 1141]
        ),
        
        FaceAcupointModel(
            name: "四白穴",
            effect: "眼袋和下眼瞼浮腫、眼睛疲勞",
            method: "用食指指腹，略微用力按壓",
            location: "瞳孔直下方2厘米",
            notice:"""
                1.出血傾向或服用抗凝血劑者，避免力道大的按摩
                2.局部感染發炎處，應避開按摩
                3.過度虛弱、空腹或無力時，避免按摩，以免反應過激
                4.全身性發炎或自體免疫疾病，須注意按摩力道
                """,
            position: [381, 812]
        ),
        
        FaceAcupointModel(
            name: "攢竹穴",
            effect: "眼睛疲勞",
            method: "閉眼，雙手握拳，利用食指近端關節，沿着眉毛向外側緩緩輕刮",
            location: "位於眉毛內側凹陷處",
            notice: """
                1.出血傾向或服用抗凝血劑者，避免力道大的按摩
                2.局部感染發炎處，應避開按摩
                3.過度虛弱、空腹或無力時，避免按摩，以免反應過激
                4.全身性發炎或自體免疫疾病，須注意按摩力道
                """,
            position: [420, 850]
        ),
        FaceAcupointModel(
            name: "承漿穴",
            effect: "提神醒腦、臉部神經麻痺、面腫",
            method: "用拇指指腹，畫圓按摩",
            location: "下嘴唇與下巴間的凹陷處",
            notice: """
                1.出血傾向或服用抗凝血劑者，避免力道大的按摩
                2.局部感染發炎處，應避開按摩
                3.過度虛弱、空腹或無力時，避免按摩，以免反應過激
                4.全身性發炎或自體免疫疾病，須注意按摩力道
                """,
            position: [33]
        ),
        FaceAcupointModel(
            name: "印堂穴",
            effect: "前額痛、眩暈、鼻炎、感冒發熱",
            method: "用中指或食指指腹，揉按穴位",
            location: "前額正中，髮際上方0.5寸",
            notice: """
                1.出血傾向或服用抗凝血劑者，避免力道大的按摩
                2.局部感染發炎處，應避開按摩
                3.過度虛弱、空腹或無力時，避免按摩，以免反應過激
                4.全身性發炎或自體免疫疾病，須注意按摩力道
                """,
            position: [17]
        ),
        FaceAcupointModel(
            name: "地倉穴",
            effect: "齒痛、顏面神經失調",
            method: "食指指腹揉按左右穴位",
            location: "位於面部，口角外側，上直瞳孔",
            notice: """
                1.出血傾向或服用抗凝血劑者，避免力道大的按摩
                2.局部感染發炎處，應避開按摩
                3.過度虛弱、空腹或無力時，避免按摩，以免反應過激
                4.全身性發炎或自體免疫疾病，須注意按摩力道
                """,
            position: [175, 623]
        ),
        FaceAcupointModel(
            name: "太陽穴",
            effect: "偏頭痛、目赤腫痛、目眩、目澀、牙痛、三叉神經痛",
            method: "用中指或食指指腹，畫圓按摩",
            location: "眉尾直上，在髮際旁凹陷處",
            notice: """
                1.出血傾向或服用抗凝血劑者，避免力道大的按摩
                2.局部感染發炎處，應避開按摩
                3.過度虛弱、空腹或無力時，避免按摩，以免反應過激
                4.全身性發炎或自體免疫疾病，須注意按摩力道
                """,
            position: [215,  1013]
        ),
        FaceAcupointModel(
            name: "下關穴",
            effect: "耳聾、耳鳴、牙關開合不利",
            method: "用中指或食指指腹按壓，同時做開闔口的動作",
            location: "耳前方，顴弓下限處",
            notice: """
                1.出血傾向或服用抗凝血劑者，避免力道大的按摩
                2.局部感染發炎處，應避開按摩
                3.過度虛弱、空腹或無力時，避免按摩，以免反應過激
                4.全身性發炎或自體免疫疾病，須注意按摩力道
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
                effect: "緩解頭痛、牙痛、鼻塞等症狀",
                method: "用拇指指腹按壓",
                location: "手部虎口，大拇指與食指相接處",
                notice:"""
                1.出血傾向或服用抗凝血劑者，避免力道大的按摩
                2.局部感染發炎處，應避開按摩
                3.過度虛弱、空腹或無力時，避免按摩，以免反應過激
                4.全身性發炎或自體免疫疾病，須注意按摩力道
                """,
                basePoint: [.thumbMP],
                offSet: heGu,
                isBackHand: true //是手背
            ),
            
            HandAcupointModel(
                name: "少沖穴",
                effect: "緩解心悸、失眠、健忘等症狀",
                method: "用拇指指腹按壓",
                location: "小指指甲內側下缘",
                notice: """
                1.出血傾向或服用抗凝血劑者，避免力道大的按摩
                2.局部感染發炎處，應避開按摩
                3.過度虛弱、空腹或無力時，避免按摩，以免反應過激
                4.全身性發炎或自體免疫疾病，須注意按摩力道
                """,
                basePoint: [.littleTip],
                offSet: shaoChong,
                isBackHand: true
            ),
            
            HandAcupointModel(
                name: "商陽穴",
                effect: "有助於緩解肺部、腸胃小困擾",
                method: "用大拇指點按",
                location: "食指指甲下方內側",
                notice:"""
                1.出血傾向或服用抗凝血劑者，避免力道大的按摩
                2.局部感染發炎處，應避開按摩
                3.過度虛弱、空腹或無力時，避免按摩，以免反應過激
                4.全身性發炎或自體免疫疾病，須注意按摩力道
                """,
                basePoint: [.indexTip],
                offSet: shangYang,
                isBackHand: true
            ),
            
            HandAcupointModel(
                name: "中渚穴",
                effect: "頭痛、目赤、耳聾、耳鳴、咽喉腫痛",
                method: "手掌心向下，用另一手反手握住該手的小指側，用拇指的指尖掐揉",
                location: "第四、五掌骨間凹陷處",
                notice:"""
                1.出血傾向或服用抗凝血劑者，避免力道大的按摩
                2.局部感染發炎處，應避開按摩
                3.過度虛弱、空腹或無力時，避免按摩，以免反應過激
                4.全身性發炎或自體免疫疾病，須注意按摩力道
                """,
                basePoint:  [.wrist, .littlePIP],
                offSet: chongDu,
                isBackHand: true
            ),
            
//            HandAcupointModel(
//                name: "液門穴",
//                effect: "",
//                method: "",
//                location: "",
//                notice:"""
//                1.出血傾向或服用抗凝血劑者，避免力道大的按摩
//                2.局部感染發炎處，應避開按摩
//                3.過度虛弱、空腹或無力時，避免按摩，以免反應過激
//                4.全身性發炎或自體免疫疾病，須注意按摩力道
//                """,
//                basePoint:  [.middleMCP, .littleMCP],
//                offSet: yiMen,
//                isBackHand: true
//            ),
//            
//            HandAcupointModel(
//                name: "陽池穴",
//                effect: "",
//                method: "",
//                location: "",
//                notice:"""
//                1.出血傾向或服用抗凝血劑者，避免力道大的按摩
//                2.局部感染發炎處，應避開按摩
//                3.過度虛弱、空腹或無力時，避免按摩，以免反應過激
//                4.全身性發炎或自體免疫疾病，須注意按摩力道
//                """,
//                basePoint:  [.wrist],
//                offSet: yangChi,
//                isBackHand: true
//            ),

//            HandAcupointModel(
//                name: "內關穴",
//                effect: "改善失眠、緩解心悸、胸悶等症狀",
//                method: "合併食指中指，兩指按揉",
//                location: "手腕橫紋中點往下三橫指寬處",
//                notice:"""
//                1.出血傾向或服用抗凝血劑者，避免力道大的按摩
//                2.局部感染發炎處，應避開按摩
//                3.過度虛弱、空腹或無力時，避免按摩，以免反應過激
//                4.全身性發炎或自體免疫疾病，須注意按摩力道
//                """,
//                basePoint: [.wrist],
//                offSet: innerPass,
//                isBackHand: false
//            ),
         
            HandAcupointModel(
                name: "勞宮穴",
                effect: "養心安神、改善心悸、失眠、健忘等症狀",
                method: "拇指以旋轉方式按壓",
                location: "握拳，中指紙尖對應的掌心中央處",
                notice: """
                1.出血傾向或服用抗凝血劑者，避免力道大的按摩
                2.局部感染發炎處，應避開按摩
                3.過度虛弱、空腹或無力時，避免按摩，以免反應過激
                4.全身性發炎或自體免疫疾病，須注意按摩力道
                """,
                basePoint: [.wrist, .middleMCP],
                offSet: laoGong,
                isBackHand: false
            ),
            
            HandAcupointModel(
                name: "少府穴",
                effect: "緩解心悸、胸痛、心律不整，心火旺盛引起的失眠、口臭、痘痘",
                method: "用拇指尖按壓",
                location: "手握拳，小指尖在掌心所指處",
                notice:"""
                1.出血傾向或服用抗凝血劑者，避免力道大的按摩
                2.局部感染發炎處，應避開按摩
                3.過度虛弱、空腹或無力時，避免按摩，以免反應過激
                4.全身性發炎或自體免疫疾病，須注意按摩力道
                """,
                basePoint:  [.wrist, .littleMCP],
                offSet: shaoFu,
                isBackHand: false
            ),
            
            HandAcupointModel(
                name: "大陵穴",
                effect: "鎮驚安神、緩解失眠",
                method: "大拇指按壓",
                location: "腕掌橫紋的中點處",
                notice:"""
                1.出血傾向或服用抗凝血劑者，避免力道大的按摩
                2.局部感染發炎處，應避開按摩
                3.過度虛弱、空腹或無力時，避免按摩，以免反應過激
                4.全身性發炎或自體免疫疾病，須注意按摩力道
                """,
                basePoint:  [.wrist],
                offSet: daLin,
                isBackHand: false
            ),
            
            HandAcupointModel(
                name: "魚際穴",
                effect: "緩解咽喉腫痛、咳嗽、發熱、頭痛、風寒",
                method: "一手手掌輕握另一手手背彎曲大拇指，以指甲尖垂直下按第一掌骨側中點肉際處",
                location: "第一掌骨中點橈側",
                notice:"""
                1.出血傾向或服用抗凝血劑者，避免力道大的按摩
                2.局部感染發炎處，應避開按摩
                3.過度虛弱、空腹或無力時，避免按摩，以免反應過激
                4.全身性發炎或自體免疫疾病，須注意按摩力道
                """,
                basePoint:  [.thumbCMC],
                offSet: yuChi,
                isBackHand: false
            )
            
            //            HandAcupointModel(
            //                name: "神門穴",
            //                effect: "",
            //                method: "",
            //                location: "",
            //                notice:"""
            //                1.出血傾向或服用抗凝血劑者，避免力道大的按摩
            //                2.局部感染發炎處，應避開按摩
            //                3.過度虛弱、空腹或無力時，避免按摩，以免反應過激
            //                4.全身性發炎或自體免疫疾病，須注意按摩力道
            //                """,
            //                basePoint:  [.middleMCP, .littleMCP],
            //                offSet: shaunMang,
            //                isBackHand: false
            //            ),
        ]
    }
    
    var middleMCP: VNRecognizedPoint?
    var wrist: VNRecognizedPoint?
    var littleMCP: VNRecognizedPoint?
    var littlePIP: VNRecognizedPoint?
    var thumbCMC: VNRecognizedPoint?

    var isLeftHand: Bool = false
    
    var heGu: CGPoint {
        return isLeftHand ? CGPoint(x: 0, y: 0.1) : CGPoint(x: 0, y: 0.08)
    }
    
    var innerPass: CGPoint {
        return isLeftHand ? CGPoint(x: -0.18, y: 0.08) : CGPoint(x: 0.19, y: 0)
    }
    
    var laoGong: CGPoint {
        return calculateMidPoint(point1: wrist?.location, point2: middleMCP?.location)
    }
    
    var shaoChong: CGPoint {
        return isLeftHand ? CGPoint(x: -0.01, y: -0.03) : CGPoint(x: 0.02, y: -0.009)
    }
    
    var shangYang: CGPoint {
        return isLeftHand ? CGPoint(x: -0.02, y: -0.02) : CGPoint(x: 0.02, y: -0.03)
    }
    
    var shaoFu: CGPoint {
        return calculateMidPoint(point1: wrist?.location, point2: littleMCP?.location)
    }

    var chongDu: CGPoint {
        return calculateMidPoint(point1: wrist?.location, point2: littlePIP?.location)
    }
    
//    var yiMen: CGPoint {
//        return calculateMidPoint(point1: littleMCP?.location, point2: middleMCP?.location)
//    }
//    
    var yangChi: CGPoint {
        return calculateMidPoint(point1: wrist?.location, point2: wrist?.location)
    }
    
    var daLin: CGPoint {
        return isLeftHand ? CGPoint(x: -0.04, y: 0.1) : CGPoint(x: 0.08, y: -0.03)
    }
    
    var yuChi: CGPoint {
        return isLeftHand ? CGPoint(x: 0, y: 0.1) : CGPoint(x: 0, y: 0)
    }
    
    
    func calculateMidPoint(point1: CGPoint?, point2: CGPoint?) -> CGPoint {
        guard let point1 = point1, let point2 = point2 else { return .zero }
        return CGPoint(x: (point1.x + point2.x) / 2, y: (point1.y + point2.y) / 2)
    }
    
    
    var commonAcupoint: [CommonModel] {
        return [
            CommonModel(categoryName: "頭痛",
                        description: "穴位按摩能緩解頭部緊繃，促進血液循環，減輕頭痛不適。來試試按摩太陽穴、印堂等穴位吧，讓疼痛隨著指尖的溫柔撫觸而煙消雲散。給自己一個放鬆的時刻，讓穴位按摩帶你遠離頭痛的困擾!",
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
                        description: "穴位按摩能刺激經絡，改善膚質，讓你的肌膚煥發自然光采。來按摩迎香、四白等穴位吧，感受面部肌肉的放鬆，血液循環的加快。這些神奇的穴道，將喚醒你肌膚的活力，打造明亮動人的美顏!",
                        acupoints: [
                            Acupoint(name: "迎香穴", image: "透明臉"),
                            Acupoint(name: "四白穴", image: "透明臉"),
                            Acupoint(name: "地倉穴", image: "透明臉"),
                            Acupoint(name: "頰車穴", image: "透明臉")
                        ]),
            
            CommonModel(categoryName: "眼睛疲勞",
                        description: "長時間用眼過度，眼睛容易疲勞酸澀。不妨試試穴位按摩，舒緩眼部肌肉緊張。按摩睛明、攢竹、絲竹空等穴位，促進眼部血液循環，緩解疲勞。給雙眼一個放鬆的時刻，讓穴位按摩帶你遠離眼睛的不適，重現明亮雙眸!",
                        acupoints: [
                            Acupoint(name: "睛明穴", image: "透明臉"),
                            Acupoint(name: "攢竹穴", image: "透明臉"),
                            Acupoint(name: "絲竹空穴", image: "透明臉"),
                            Acupoint(name: "承泣穴", image: "透明臉")
                        ])
        ]
    }
}

