//
//  SearchModel.swift
//  Antion
//
//  Created by Trevor Schmidt on 3/2/22.
//

import Foundation

struct SearchUser: Codable, Identifiable {
    var id: String { publicKey }
    var publicKey: String
    var name: String
    var profilePicUrl: String
}
