import SwiftData
import UIKit

//@Model 
class FaceAcupointModel {
    var id: UUID?
    var name: String
    var effect: String
    var method: String
    var positionDescibition: String
    var notice: String
    var position: [Int]
    
    init(name: String, effect: String, method: String, location: String, notice: String, position: [Int]) {
        self.name = name
        self.effect = effect
        self.method = method
        self.positionDescibition = location
        self.notice = notice
        self.position = position
    }
}
