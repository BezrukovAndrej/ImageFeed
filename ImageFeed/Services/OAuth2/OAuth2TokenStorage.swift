import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private init() {}
    
    private let storage = KeychainWrapper.standard
    private let keyStorage = "bearer14"
    
    var token: String? {
        get {
            storage.string(forKey: keyStorage)
        }
        
        set {
            guard let data = newValue else { return }
            storage.set(data, forKey: keyStorage)
        }
    }
    
    func removeToken() {
        storage.removeObject(forKey: keyStorage)
    }
}
