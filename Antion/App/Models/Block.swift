//
//  Block.swift
//  Antion
//
//  Created by Trevor Schmidt on 10/1/21.
//

import Foundation

struct Block: BlockHeaderProtocol, Identifiable, Codable {
    
    // MARK: Blockheader
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
    
    // MARK: Block
    
//    var merkleTree: [String:Any]
    
//    static func computeBlockHash(block: Block) -> String {
//        var transactionsString = ""
////        for transaction in block.transactions {
////            transactionsString += transaction.id
////        }
//        return CryptoService.hash(fromString: String(block.index) + block.previousHash + block.timeStamp + transactionsString + String(block.nonce))
//    }
}

extension Block: Equatable {
    
}

let exampleBlock = Block(index: 0,
                         timeStamp: Date.now.toLongString(),
                         previousHash: "",
                         numTransactions: 1,
                         transactionVolume: 400,
                         minerPublicKey: "x86lakjsdeflkj",
                         merkleRoot: "",
                         nonce: 42069,
                         hash: "0000lakdsjflksajdf")
