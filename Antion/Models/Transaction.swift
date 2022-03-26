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
    
    init(id: String, fromPublicKey: String, toPublicKey: String, timeStamp: String, amount: Int, note: String, signature: String) {
        self.id = id
        self.fromPublicKey = fromPublicKey
        self.toPublicKey = toPublicKey
        self.timeStamp = timeStamp
        self.amount = amount
        self.note = note
        self.signature = signature
    }
    
    init(fromPublicKey: String, fromPrivateKey: String, toPublicKey: String, amount: Int, note: String, timeStamp: String) {
        self.id = UUID().uuidString
        self.fromPublicKey = fromPublicKey
        self.toPublicKey = toPublicKey
        self.timeStamp = timeStamp
        self.amount = amount
        self.note = note
        self.signature = ""
        let cryptoSignature = CryptoService.signTransaction(transaction: self, privateKeyString: fromPrivateKey)
        self.signature = cryptoSignature ?? ""
    }

    func isValidSignature() -> Bool {
        return CryptoService.isValidSignature(transaction: self)
    }
}
struct RequestedTransaction: Identifiable {
    var transaction: Transaction
    var requestState: RequestState
    
    var id: String {
        transaction.id
    }
}
