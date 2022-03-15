//
//  UnspentTransaction.swift
//  Antion
//
//  Created by Trevor Schmidt on 3/14/22.
//

import Foundation

struct UnspentTransaction: Codable, Identifiable {
    var blockHash: String
    var merklePath: [String]
    var index: Int
    
    var toPublicKey: String
    var amount: Int
    
    var id: String {
        "\(blockHash)/\(String(index))/\(merklePath.joined(separator: "/"))"
    }
}
