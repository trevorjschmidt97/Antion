//
//  SearchUser.swift
//  Antion
//
//  Created by Trevor Schmidt on 3/10/22.
//

import Foundation

struct SearchUser: Codable, Identifiable {
    
    var publicKey: String
    var name: String
    var profilePicUrl: String
    var publicKeyLowercased: String
    
    var publicKeyKeywords: [String]
    var nameKeywords: [String]
    
    var id: String {
        publicKey
    }
    
    static func searchUser(fromUser user: User) -> SearchUser {
        
        let publicKeyKeywords = user.publicKey.keywords()
        let nameKeywords = user.name.keywords()
        
        return SearchUser(publicKey: user.publicKey,
                   name: user.name,
                   profilePicUrl: user.profilePicUrl,
                   publicKeyLowercased: user.publicKey.lowercased(),
                   publicKeyKeywords: publicKeyKeywords,
                   nameKeywords: nameKeywords)
    }
}
