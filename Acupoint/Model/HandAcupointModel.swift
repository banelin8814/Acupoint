import SwiftData
import UIKit

class HandAcupointModel: Identifiable, Hashable {
    static func == (lefths: HandAcupointModel, righths: HandAcupointModel) -> Bool {
        return lefths.name == righths.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    var id: UUID?
    var name: String
    var location: String
    var effect: String
    var method: String
    var frequency: String
    var notice: String
    var position: CGPoint
    var isBackHand: Bool
    
    init(name: String, location: String, effect: String, method: String, frequency: String, notice: String, position: CGPoint, isBackHand: Bool) {
        self.name = name
        self.location = location
        self.effect = effect
        self.method = method
        self.frequency = frequency
        self.notice = notice
        self.position = position
        self.isBackHand = isBackHand
        
    }
}
