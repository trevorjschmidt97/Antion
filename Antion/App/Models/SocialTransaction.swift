//
//  SocialTransaction.swift
//  Antion
//
//  Created by Trevor Schmidt on 1/20/22.
//

import Foundation

struct SocialTransaction {
    var transaction: Transaction
    var fromName: String
    var fromProfilePicUrl: String?
    var toName: String
    var toProfilePicUrl: String?
    var numLikes: Int
    var numComments: Int
}
