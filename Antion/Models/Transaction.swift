//
//  ConfirmedTransaction.swift
//  Antion
//
//  Created by Trevor Schmidt on 10/1/21.
//

import Foundation

struct Transaction: Identifiable, Codable {
    var id: String
    
    var fromPublicKey: String
    var toPublicKey: String
    
    var timeStamp: String
    var amount: Int
    
    var note: String
    var signature: String

    var formattedAmount: String {
        amount.formattedAmount()
    }
    
    init(fromPublicKey: String, fromPrivateKey: String, toPublicKey: String, amount: Int, note: String) {
        self.id = UUID().uuidString
        self.fromPublicKey = fromPublicKey
        self.toPublicKey = toPublicKey
        self.timeStamp = Date.now.toLongString()
        self.amount = amount
        self.note = note
        self.signature = ""
        self.signature = CryptoService.signTransaction(transaction: self, privateKeyString: fromPrivateKey) ?? ""
    }

    func isValidSignature() -> Bool {
        return CryptoService.isValidSignature(transaction: self)
    }
}
