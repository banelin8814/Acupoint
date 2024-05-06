import Foundation
import SwiftData

@Model
class AcupointName: Identifiable, Hashable {
    var name: String
    init(name: String) {
        self.name = name
    }
}
