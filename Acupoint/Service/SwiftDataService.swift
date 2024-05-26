import Foundation
import SwiftData

@MainActor
class SwiftDataService {
    
    static let shared = SwiftDataService()
    
    var acupointNameContainer: ModelContainer?
    var acupointNameContext: ModelContext?
    
    init() {
        do {
            acupointNameContainer = try ModelContainer(for: AcupointName.self)
            acupointNameContext = acupointNameContainer?.mainContext
            
        } catch {
            print("Failed to create ModelContainer: \(error)")
        }
    }
    
    func saveAcupointName(_ name: String) {
        if let context = acupointNameContext {
            let newAcupoint = AcupointName(name: name)
            context.insert(newAcupoint)
        }
    }

    func fetchAcupointNames() -> [AcupointName] {
        let descriptor = FetchDescriptor<AcupointName>()
        do {
            if let context = acupointNameContext {
                let objects = try context.fetch(descriptor)
                return objects
            }
        } catch {
            print("Failed to fetch acupoint names: \(error)")
        }
        return []
    }

    func checkAcupointNames(_ name: String) {
        if let context = acupointNameContext {
            var allAcupoint = fetchAcupointNames()
            var isAlreadySaved = false
            
            for (index, nameInAll) in allAcupoint.enumerated() where nameInAll.name == name {
                    context.delete(nameInAll)
                    allAcupoint.remove(at: index)
                    isAlreadySaved = true
                    break
            }
            
            if !isAlreadySaved {
                let newAcupoint = AcupointName(name: name)
                context.insert(newAcupoint)
                allAcupoint.append(newAcupoint)
            }
        }
    }
    
    func deleteAllAcupointNames() {
        if let context = acupointNameContext {
            let allAcupoint = fetchAcupointNames()
            for acupoint in allAcupoint {
                context.delete(acupoint)
            }
        }
    }
}
