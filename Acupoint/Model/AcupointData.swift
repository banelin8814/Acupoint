import UIKit

struct Acupoint {
    let name: String
    let location: String
    let effect: String
    let method: String
    let frequency: String
    let notice: String
    let postion: [Int]
}

let faceAcupoints: [Acupoint] = [
    Acupoint(
        name: "迎香穴",
        location: "鼻唇溝兩旁凹陷處",
        effect: "通鼻、利氣",
        method: "用手指指尖，點壓按摩迎香穴",
        frequency: "1次約 1分鐘",
        notice: "若有疼痛，請勿按壓",
        postion: [746, 311]
    ),
    Acupoint(
        name: "人中穴",
        location: "人中凹陷處",
        effect: "清熱解毒、開竅醒腦",
        method: "用拇指指腹，點壓按摩人中穴",
        frequency: "1次約 30秒",
        notice: "按壓力度不宜過大",
        postion: [3]
    ),
    Acupoint(
        name: "睛明穴",
        location: "眼內眥旁開1分",
        effect: "明目退翳、通絡止痛",
        method: "用食指或中指指腹，輕柔按摩睛明穴",
        frequency: "1次約 1分鐘",
        notice: "按摩時閉眼，動作宜輕柔",
        postion: [1148, 1122]
    ),
    Acupoint(
        name: "承泣穴",
        location: "眼下眶骨凹陷處",
        effect: "疏肝明目、通絡止痛",
        method: "用中指指腹，輕柔按摩承泣穴",
        frequency: "1次約 1分鐘",
        notice: "按摩時閉眼，勿用力過度",
        postion: [1115, 1141]
    ),
    Acupoint(
        name: "四白穴",
        location: "眼眶骨外眥旁開1分",
        effect: "疏風清熱、明目退翳",
        method: "用食指指腹，來回撫摩四白穴",
        frequency: "1次約 30秒",
        notice: "動作宜緩和輕柔，避免刺激眼睛",
        postion: [381, 812]
    )
]

let handAcupoints: [Acupoint] = [
    Acupoint(
        name: "勞宮穴",
        location: "掌心兩橫紋中點與第3掌骨中線交叉處",
        effect: "活血化瘀、理氣止痛",
        method: "用拇指指腹按壓勞宮穴",
        frequency: "1次約 30秒",
        notice: "按壓時稍用力，但勿過度",
        postion: [250, 250]
    ),
    
    Acupoint(
        name: "內關穴",
        location: "腕橫紋上2寸，掌長肌腱與橈側腕屈肌腱之間",
        effect: "寧心安神、理氣和胃、調理脾胃",
        method: "用拇指指腹按壓內關穴",
        frequency: "1次約 1分鐘",
        notice: "按壓時感到酸脹感為宜",
        postion: [150, 150]
    ),

    Acupoint(
        name: "外關穴",
        location: "腕背側，尺骨茎突下方與第5掌骨之間的凹陷處",
        effect: "清熱解毒、疏風止痛、清利頭目",
        method: "用拇指指腹按壓外關穴",
        frequency: "1次約 1分鐘",
        notice: "按壓時感到酸脹感為宜",
        postion: [200, 200]
    ),

    Acupoint(
        name: "少商穴",
        location: "手拇指指甲後角與肉交界處",
        effect: "清熱瀉火、開竅醒腦、安神定驚",
        method: "用另一手拇指指腹按壓少商穴",
        frequency: "1次約 30秒",
        notice: "按壓時稍用力，感到酸脹感為宜",
        postion: [300, 300]
    )
]
