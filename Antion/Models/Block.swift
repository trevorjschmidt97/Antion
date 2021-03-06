//
//  Block.swift
//  Antion
//
//  Created by Trevor Schmidt on 10/1/21.
//

import Foundation

struct Block: Codable, Identifiable, Equatable {
    var index: Int
    var timeStamp: String
    
    var previousHash: String
    
    var minerPublicKey: String
    
    var difficulty: Int
    var nonce: Int
    var hash: String
    
    var transactions: [Transaction]
    
    var id: String {
        hash
    }
    static func == (lhs: Block, rhs: Block) -> Bool {
        lhs.hash == rhs.hash
    }
}


let exampleBlock = Block(index: 0,
                         timeStamp: Date.now.toLongString(),
                         previousHash: "",
                         minerPublicKey: "x86lakjsdeflkj",
                         difficulty: 0,
                         nonce: 42069,
                         hash: "0000lakdsjflksajdf",
                         transactions: [])
