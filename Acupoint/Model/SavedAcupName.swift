import Foundation
import SwiftData

@Model
class AcupointName: Identifiable, Hashable {
    let name: String
    init(name: String) {
        self.name = name
    }
}
