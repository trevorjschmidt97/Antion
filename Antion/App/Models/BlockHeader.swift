//
//  BlockHeader.swift
//  Antion
//
//  Created by Trevor Schmidt on 3/10/22.
//

import Foundation

protocol BlockHeaderProtocol: Codable {
    var index: Int { get set }
    var timeStamp: String { get set }
    
    var previousHash: String { get set }
    var numTransactions: Int { get set }
    var transactionVolume: Int { get set }
    
    var minerPublicKey: String { get set }
    var merkleRoot: String { get set }
    
    
    var nonce: Int { get set }
    var hash: String { get set }
}

struct BlockHeader: BlockHeaderProtocol, Identifiable, Codable {
    
    var index: Int
    var timeStamp: String
    
    var previousHash: String
    var numTransactions: Int
    var transactionVolume: Int
    
    var minerPublicKey: String
    var merkleRoot: String
    
    
    var nonce: Int
    var hash: String
    
    var id: String {
        hash
    }
}
