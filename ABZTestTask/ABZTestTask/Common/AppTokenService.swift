//
//  AppTokenService.swift
//  ABZTestTask
//
//  Created by Denis Sernuk on 19.06.2025.
//

import Foundation

struct AppTokenService {
    enum Constants {
        static let keychainTokenKey = "keychainTokenKey"
    }
    
    func fetchToken() -> String? {
        return KeychainSwift().get(Constants.keychainTokenKey)
    }
    
    func saveToken(token: String?) -> Bool {
        guard let token = token else { return false }
        return KeychainSwift().set(token, forKey: Constants.keychainTokenKey)
    }
    
    func deleteToken() {
        KeychainSwift().delete(Constants.keychainTokenKey)
    }
}
