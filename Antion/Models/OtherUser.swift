//
//  OtherUser.swift
//  Antion
//
//  Created by Trevor Schmidt on 1/20/22.
//

import Foundation

struct OtherUser: Decodable, Identifiable {
    
    var publicKey: String
    var name: String
    var profilePicUrl: String
    
    var id: String {
        publicKey
    }
}
