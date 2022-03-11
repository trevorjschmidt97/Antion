//
//  PendingTransaction.swift
//  Antion
//
//  Created by Trevor Schmidt on 3/10/22.
//

import Foundation

struct PendingTransaction: Codable, Identifiable, TransactionProtocol {
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
}
