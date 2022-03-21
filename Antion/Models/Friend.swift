//
//  Friend.swift
//  Antion
//
//  Created by Trevor Schmidt on 1/19/22.
//

import Foundation

struct Friend: Codable, Identifiable, Equatable {
    var publicKey: String
    var name: String
    var profilePicUrl: String
    
    var id: String {
        publicKey
    }
}

enum RequestState {
    case fromSelf
    case fromOther
}

struct RequestedFriend: Identifiable {
    var friend: Friend
    var requestState: RequestState
    
    var id: String {
        friend.id
    }
}
