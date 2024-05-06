import Foundation
import SwiftData

@MainActor
class SwiftDataService {
    
    static let shared = SwiftDataService()
    
    var acupointNameContainer: ModelContainer?
    var acupointNameContext: ModelContext?
    
    init() { //初始化方法
        do {
            acupointNameContainer = try ModelContainer(for: AcupointName.self)
            acupointNameContext = acupointNameContainer?.mainContext
            
        } catch {
            print("Failed to create ModelContainer: \(error)")
        }
    }
    
    // 保存穴位名字
    func saveAcupointName(_ name: String) {
        if let context = acupointNameContext {
            let newAcupoint = AcupointName(name: name)
            context.insert(newAcupoint)
        }
    }
    // 獲取所有保存的穴位名字
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
            
            for (index, nameInAll) in allAcupoint.enumerated() {
                if nameInAll.name == name {
                    context.delete(nameInAll)
                    allAcupoint.remove(at: index)
                    isAlreadySaved = true
                    break
                }
            }
            
            if !isAlreadySaved {
                let newAcupoint = AcupointName(name: name)
                context.insert(newAcupoint)
                allAcupoint.append(newAcupoint)
            }
        }
    }

}
