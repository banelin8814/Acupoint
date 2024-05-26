import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirebaseManager {
    static let shared = FirebaseManager()
    
    private init() {}
    
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
    
    func createNewUser(auth: AuthDataResultModel) async throws {
        var userData: [String: Any] = [
            "user_id" : auth.userId,
            "name" : auth.name
        ]
        if let email = auth.email {
            userData["email"] = email
        }
        do {
            try await Firestore.firestore().collection("users").document(auth.userId).setData(userData, merge: false)
            print("User data saved successfully for user ID: \(auth.userId)")
        } catch {
            print("FirebaseError: createNewUser(auth:) failed. \(error)")
            throw error
        }
    }
    func saveAcupointNameToUserSubcollection(_ acupointName: String, userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let reference = dataBase.collection("users").document(userId).collection("acupointNames").document()
        
        let data: [String: Any] = [
            "name": acupointName
        ]
        
        reference.setData(data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    func fetchAcupointNamesFromUserSubcollection(userId: String, completion: @escaping (Result<[String], Error>) -> Void) {
        let reference = dataBase.collection("users").document(userId).collection("acupointNames")
        
        reference.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let acupointNames = snapshot.documents.compactMap { $0.data()["name"] as? String }
                completion(.success(acupointNames))
            }
        }
    }
    func deleteAcupointNameFromUserSubcollection(_ name: String, userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let database = Firestore.firestore()
        let userRef = database.collection("users").document(userId)
        
        userRef.collection("acupointNames").whereField("name", isEqualTo: name).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                guard let snapshot = snapshot else {
                    completion(.failure(NSError(domain: "FirebaseManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "Snapshot is nil"])))
                    return
                }
                
                let batch = database.batch()
                snapshot.documents.forEach { document in
                    batch.deleteDocument(document.reference)
                }
                
                batch.commit { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            }
        }
    }
}

struct AuthDataResultModel {
    let userId: String
    let email: String?
    let name: String
}
