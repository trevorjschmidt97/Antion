//
//  Block.swift
//  Antion
//
//  Created by Trevor Schmidt on 10/1/21.
//

import Foundation

struct Block {
    
    var blockHeader: BlockHeader
    var merkleTree: MerkleTree

}

extension Block: Identifiable {
    var id: String {
        blockHeader.id
    }
}

extension Block: Equatable {
    static func == (lhs: Block, rhs: Block) -> Bool {
        lhs.blockHeader.hash == rhs.blockHeader.hash
    }
}

let exampleBlock = Block(blockHeader: BlockHeader(index: 0,
                                                  timeStamp: Date.now.toLongString(),
                                                  previousHash: "",
                                                  numTransactions: 1,
                                                  transactionVolume: 400,
                                                  minerPublicKey: "x86lakjsdeflkj",
                                                  merkleRoot: "",
                                                  difficulty: 0,
                                                  nonce: 42069,
                                                  hash: "0000lakdsjflksajdf"),
                         merkleTree: [
                            "abcdefgh": [
                                "abcd": [
                                    "ab": [
                                        "a", "b"
                                    ],
                                    "cd": [
                                        "c", "d"
                                    ]
                                ],
                                "efgh": [
                                    "ef": [
                                        "e", "f"
                                    ],
                                    "gh": [
                                        "g", "h"
                                    ]
                                ]
                            ]
                         ])
