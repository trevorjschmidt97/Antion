//
//  PendingTransaction.swift
//  Antion
//
//  Created by Trevor Schmidt on 3/10/22.
//

import Foundation

struct PendingTransaction: Codable, Identifiable {
    var id: String

    var fromPublicKey: String

    var timeStamp: String
    var amount: Int

    var note: String
    
    var signature: String
    
}
