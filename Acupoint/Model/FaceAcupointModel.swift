import SwiftData
import UIKit

//@Model 
class FaceAcupointModel {
    var id: UUID?
    var name: String
    var location: String
    var effect: String
    var method: String
    var frequency: String
    var notice: String
    var position: [Int]
    
    init(name: String, location: String, effect: String, method: String, frequency: String, notice: String, position: [Int]) {
        self.name = name
        self.location = location
        self.effect = effect
        self.method = method
        self.frequency = frequency
        self.notice = notice
        self.position = position
    }
}
