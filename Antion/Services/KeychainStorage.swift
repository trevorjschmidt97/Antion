//
//  KeychainStorage.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/21/21.
//

import Foundation
import SwiftKeychainWrapper

enum KeychainStorage {
    static let key = "privateKey"
    
    static func getPrivateKey() -> String? {
        if let myPrivateKey = KeychainWrapper.standard.string(forKey: Self.key) {
            return myPrivateKey
        } else {
            return nil
        }
    }
    
    static func savePrivateKey(_ privateKey: String) -> Bool {
        return KeychainWrapper.standard.set(privateKey, forKey: Self.key) 
    }
}
