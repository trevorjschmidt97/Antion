//
//  Acquaintance.swift
//  Antion
//
//  Created by Trevor Schmidt on 1/19/22.
//

import Foundation

struct Friend: Codable, Identifiable {
    
    var publicKey: String
    var publicKeyKeywords: [String]
    var name: String
    var nameKeywords: [String]
    
    var profilePicUrl: String
    
    var isFriend: Bool
    var isRequestFromOther: Bool
    var isRequestFromSelf: Bool
    
    var timeStamp: String
    
    var id: String {
        publicKey
    }
}
