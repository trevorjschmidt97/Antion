//
//  UserProtocol.swift
//  Antion
//
//  Created by Trevor Schmidt on 3/10/22.
//

import Foundation

protocol UserProtocol: Codable {
    
    var publicKey: String { get set }
    var name: String { get set }
    var profilePicUrl: String { get set }
    
}

struct OtherUser: UserProtocol, Identifiable {
    var publicKey: String
    var name: String
    var profilePicUrl: String
    
    var id: String {
        publicKey
    }
}
