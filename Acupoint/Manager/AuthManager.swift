import Foundation
import FirebaseAuth

class AuthManager {
    static let shared = AuthManager()
    
    var handle: AuthStateDidChangeListenerHandle?
    
    var isLoggedIn: Bool {
        return Auth.auth().currentUser != nil
    }

    func addLoginObserver(complition: @escaping (Bool) -> Void) {
        handle = Auth.auth().addStateDidChangeListener({ _, user in
            complition(user != nil)
        })
    }
    
    func removeLoginObserver() {
            if let handle = handle {
                Auth.auth().removeStateDidChangeListener(handle)
            }
        }
}
