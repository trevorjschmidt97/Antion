//
//  ConfirmedTransaction.swift
//  Antion
//
//  Created by Trevor Schmidt on 10/1/21.
//

import Foundation

struct ConfirmedTransaction: Identifiable, Codable {
    var id: String
    
    var fromPublicKey: String
    var fromName: String
    var fromProfilePicUrl: String
    
    var toPublicKey: String
    var toName: String
    var toProfilePicUrl: String
    
    var timeStamp: String
    var amount: Int
    
    var note: String
    var signature: String
    
    var numComments: Int
    var numLikes: Int
    
    var blockHash: String
    var merklePath: [String]
    
    var inputs: [UnspentTransaction]
    var outputs: [UnspentTransaction]
    
    var formattedAmount: String {
        amount.formattedAmount()
    }
    
    static func signature(privateKey: String, timeStamp: String, amount: Int, fromPublicKey: String, toPublicKey: String, note: String) -> String {
        return CryptoService.signInfo(privateKey: privateKey, timeStamp: timeStamp, amount: amount, fromPublicKey: fromPublicKey, toPublicKey: toPublicKey, note: note)
    }

    func isValidSignature() -> Bool {
        return CryptoService.isValidSignature(transaction: self)
    }
}
