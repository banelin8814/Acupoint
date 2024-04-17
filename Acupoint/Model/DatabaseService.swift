import Foundation
import SwiftData
//
//class DatabaseService {
//    static var shared = DatabaseService()
//    var container: ModelContainer?
//    var context: ModelContext?
//    
//    init() {
//        do {
////             container = try ModelContainer(for: [TodoModel.self])
//            if let container {
//                 
//                context = ModelContext(container)
//                
//            }
//
//             
//        }
//        catch {
//            print(error)
//        }
//    }
//    
//    func saveTask(faceAcupoints: [Acupoint]?) {
//            guard let faceAcupoints else { return }
//            if let context {
//                let taskToBeSaved = AcupointList(id: <#T##String#>, faceAcupoints: <#T##[Acupoint]#>)
//                context.insert(taskToBeSaved)
//            }
//        }
//    func fetchTasks(onCompletion:@escaping([Acupoint]?,Error?) -> (Void)) {
//          let descriptor = FetchDescriptor<AcupointList>
//          if let context{
//              do {
//                  let data = try context.fetch(descriptor)
//                  onCompletion(data,nil)
//              }
//              catch {
//                  onCompletion(nil,error)
//              }
//          }
//     }
//}
