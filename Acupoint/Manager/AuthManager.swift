import Foundation
import FirebaseAuth

class AuthManager {
    static let shared = AuthManager()
    
    var handle: AuthStateDidChangeListenerHandle?
    
    @Published var isLoggedIn: Bool = false
    
    func addLoginObserver(complition: @escaping (Bool) -> Void) {
        handle = Auth.auth().addStateDidChangeListener({ _, user in
            complition(user != nil)
        })
    }
    
//    func addLoginObserver() {
//        Auth.auth().addStateDidChangeListener { [weak self] _, user in
//            self?.isLoggedIn = user != nil
//        }
//        
//        
//    
    
    func removeLoginObserver() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}

