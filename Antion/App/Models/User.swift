//
//  User.swift
//  Antion
//
//  Created by Trevor Schmidt on 1/16/22.
//

import Foundation

struct User: Identifiable, Codable, UserProtocol {
    
    var name: String
    var publicKey: String
    var profilePicUrl: String
    var balance: Int
    
    var areaCode: String
    
    var numFriends: Int
    var numReceivedRequestedTransactions: Int
    var numReceivedRequestedFriendRequests: Int
    
    var numConfirmedTransactions: Int
    var numReceivedAntion: Int
    var numSentAntion: Int
    var numMinedBlocks: Int
    var numRewardAntion: Int
    
    var friendPublicKeys: [String]
    var selfRequestedFriendPublicKeys: [String]
    var otherRequestedFriendPublicKeys: [String]

    var id: String {
        publicKey
    }
    var formattedBalance: String {
        let balanceString = String(balance)
        if balanceString.count == 0 {
            return "0.00"
        } else if balanceString.count == 1 {
            return "0.0" + balanceString
        } else if balanceString.count == 2 {
            return "0." + balanceString
        } else {
            return balanceString.prefix(balanceString.count-2) + "." + balanceString.suffix(2)
        }
    }
}

let exampleUser = User(name: "trev",
                       publicKey: "zRgvFk5fj5kmzZboRtoCcVBWXlktYKsNfepv1wrE9JQ=",
                       profilePicUrl: "https://firebasestorage.googleapis.com/v0/b/w8trkr-3356b.appspot.com/o/userProfilePics%2FDcapBesjwuhYBbE3q5mG3gll4iy2.jpg?alt=media&token=7f316ec4-4685-4c7f-a63f-98b9461c101a",
                       balance: 42069,
                       areaCode: "801",
                       numFriends: 1,
                       numReceivedRequestedTransactions: 2,
                       numReceivedRequestedFriendRequests: 3,
                       numConfirmedTransactions: 4,
                       numReceivedAntion: 5,
                       numSentAntion: 6,
                       numMinedBlocks: 7,
                       numRewardAntion: 8,
                       friendPublicKeys: [""],
                       selfRequestedFriendPublicKeys: [""],
                       otherRequestedFriendPublicKeys: [""])
