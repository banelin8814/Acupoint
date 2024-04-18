import Foundation
import SwiftData

@MainActor
class DatabaseService {
    static let shared = DatabaseService()
    
    private var container: ModelContainer?
    
    private var context: ModelContext?
    
    init() {
        do {
            container = try ModelContainer(for: FaceAcupointData.self)
            context = container?.mainContext
        } catch {
            print("Failed to create ModelContainer: \(error)")
        }
    }
    
    func saveDefaultAcupoints(_ acupoints: [FaceAcupointData]) {
        if let context {
            for acupoint in acupoints {
                let newAcupoint = FaceAcupointData(
                    name: acupoint.name,
                    location: acupoint.location,
                    effect: acupoint.effect,
                    method: acupoint.method,
                    frequency: acupoint.frequency,
                    notice: acupoint.notice,
                    position: acupoint.position
                )
                context.insert(newAcupoint)
            }
        }
    }
    
    func fetchAcupoints() -> [FaceAcupointData] {
        let descriptor = FetchDescriptor<FaceAcupointData>()
        do {
            if let context = context {
                let objects = try context.fetch(descriptor)
                return objects
            }
        } catch {
            print("Failed to fetch acupoints: \(error)")
        }
        return []
    }
}
