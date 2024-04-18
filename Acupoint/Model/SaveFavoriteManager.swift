//import Foundation
//
//class UserManager {
//    static let shared = UserManager()
//    
//    var currentUser: SavedAcupoint?
//    
//    func toggleFavoriteAcupoint(_ acupointName: String) {
//        guard var user = currentUser else { return }
//        
//        if user.favoriteAcupoints.contains(acupointName) {
//            user.favoriteAcupoints.removeAll { $0 == acupointName }
//        } else {
//            user.favoriteAcupoints.append(acupointName)
//        }
//        currentUser = user
//    }
//    
//    func saveAcupoint(_ acupointName: String) {
//        let savedAcupoint = SavedAcupoint(name: acupointName)
//        $savedAcupoint.save()
//    }
//    
//    func getSavedAcupoints() -> [String] {
//        let savedAcupoints = try? SavedAcupoint.query().fetch()
//        return savedAcupoints?.map { $0.name } ?? []
//    }
//}
//
