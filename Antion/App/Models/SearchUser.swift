//
//  SearchUser.swift
//  Antion
//
//  Created by Trevor Schmidt on 3/10/22.
//

import Foundation

struct SearchUser: Identifiable, Codable, UserProtocol {
    
    var publicKey: String
    var name: String
    var profilePicUrl: String
    
    var publicKeyKeywords: [String]
    var nameKeywords: [String]
    var publicKeyLowercased: String
    
    var id: String {
        publicKey
    }
}
