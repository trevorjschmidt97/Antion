//
//  User.swift
//  Antion
//
//  Created by Trevor Schmidt on 1/16/22.
//

import Foundation

struct User: Codable, Identifiable {
    
    init(publicKey: String, name: String, profilePicUrl: String, friends: [Friend], otherRequestedFriends: [Friend], selfRequestedFriends: [Friend], requestedTransactions: [Transaction]) {
        self.publicKey = publicKey
        self.name = name
        self.profilePicUrl = profilePicUrl
        self.friends = friends
        self.otherRequestedFriends = otherRequestedFriends
        self.selfRequestedFriends = selfRequestedFriends
        self.requestedTransactions = requestedTransactions
    }
    
    init(publicKey: String) {
        self.name = "Anonymous"
        self.publicKey = publicKey
        self.profilePicUrl = ""
        self.friends = []
        self.selfRequestedFriends = []
        self.otherRequestedFriends = []
        self.requestedTransactions = []
    }
    
    var name: String
    var publicKey: String
    var profilePicUrl: String
    
    var friends: [Friend]
    var selfRequestedFriends: [Friend]
    var otherRequestedFriends: [Friend]
    
    var requestedTransactions: [Transaction]
    
    var id: String {
        publicKey
    }
    
    mutating func removeFriend(friendPublicKey: String) {
        friends = friends.filter{ $0.publicKey != friendPublicKey }
    }
    
    var numRequestedTransactions: Int {
        requestedTransactions.filter{ $0.fromPublicKey == publicKey }.count
    }
    
    var numRequestedFriends: Int {
        otherRequestedFriends.count
    }
    
    var numTabBadge: Int {
        return numRequestedTransactions + numRequestedFriends
    }
    
    var friendsMap: [String:Friend] {
        var retFriends: [String:Friend] = [:]
        for friend in friends {
            retFriends[friend.publicKey] = friend
        }
        return retFriends
    }
    
    var otherRequestedFriendsMap: [String:Friend] {
        var retFriends: [String:Friend] = [:]
        for friend in otherRequestedFriends {
            retFriends[friend.publicKey] = friend
        }
        return retFriends
    }
    
    var userMap: [String:Friend] {
        var retUsers: [String:Friend] = [:]
        retUsers[AppViewModel.shared.publicKey] = Friend(publicKey: publicKey, name: name, profilePicUrl: profilePicUrl)
        for friend in friendsMap {
            retUsers[friend.key] = friend.value
        }
        for otherRequestedFriend in otherRequestedFriendsMap {
            retUsers[otherRequestedFriend.key] = otherRequestedFriend.value
        }
        return retUsers
    }
    
    var friendsSet: Set<String> {
        Set(friends.map{ $0.publicKey })
    }
    var selfRequestedFriendsSet: Set<String> {
        Set(selfRequestedFriends.map{ $0.publicKey })
    }
    var otherRequestedFriendsSet: Set<String> {
        Set(otherRequestedFriends.map{ $0.publicKey })
    }
    
    var requestedFriends: [RequestedFriend] {
        var retRequestedFriends: [RequestedFriend] = []
        for selfRequestedFriend in selfRequestedFriends {
            retRequestedFriends.append(RequestedFriend(friend: selfRequestedFriend, requestState: .fromSelf))
        }
        for otherRequestedFriend in otherRequestedFriends {
            retRequestedFriends.append(RequestedFriend(friend: otherRequestedFriend, requestState: .fromOther))
        }
        return retRequestedFriends.sorted{ $0.friend.publicKey.lowercased() < $1.friend.publicKey.lowercased()}
    }
}

let blankUser = User(publicKey: "RTqJfeesx3qNGpvxeROFnkO2jVlTvnwvaNF6gIg4aos=")
