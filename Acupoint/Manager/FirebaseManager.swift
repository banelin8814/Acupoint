import Foundation
import Firebase
import FirebaseFirestore

class FirebaseManager {
    static let shared = FirebaseManager()
    
    private let dataBase = Firestore.firestore()
    
    func saveAcupointName(_ acupointModel: AcupointName, completion: @escaping (Result<Void, Error>) -> Void) {
        let referance = dataBase.collection("users").document(acupointModel.name)
        let data: [String: Any] = [
            "name": acupointModel.name
        ]
        
        referance.setData(data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
