//
//  BlockHeader.swift
//  Antion
//
//  Created by Trevor Schmidt on 3/10/22.
//

import Foundation

struct BlockHeader: Identifiable, Codable {
    
    var index: Int
    var timeStamp: String
    
    var previousHash: String
    var numTransactions: Int
    var transactionVolume: Int
    
    var minerPublicKey: String
    var merkleRoot: String
    
    var difficulty: Int
    var nonce: Int
    var hash: String
    
    var id: String {
        hash
    }
}
