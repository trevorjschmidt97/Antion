//
//  SearchUser.swift
//  Antion
//
//  Created by Trevor Schmidt on 3/10/22.
//

import Foundation

struct SearchUser: Codable, Identifiable, Hashable {
    
    var publicKey: String
    var publicKeyLowercased: String
    
    var publicKeyKeywords: [String]
    
    var id: String {
        publicKey
    }
    
    init(publicKey: String) {
        self.publicKey = publicKey
        self.publicKeyLowercased = publicKey.lowercased()
        self.publicKeyKeywords = publicKey.keywords()
    }
}
