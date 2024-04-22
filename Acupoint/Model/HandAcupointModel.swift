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
    var effect: String
    var method: String
    var positionDescibition: String
    var notice: String
    var position: CGPoint
    var isBackHand: Bool
    
    init(name: String, effect: String, method: String, location: String, notice: String, position: CGPoint, isBackHand: Bool) {
        self.name = name
        self.effect = effect
        self.method = method
        self.positionDescibition = location
        self.notice = notice
        self.position = position
        self.isBackHand = isBackHand
        
    }
}
