//
//  TransactionProtocol.swift
//  Antion
//
//  Created by Trevor Schmidt on 3/10/22.
//

import Foundation

protocol TransactionProtocol: Identifiable, Codable {
    var id: String { get set }
    
    var fromPublicKey: String { get set }
    var fromName: String { get set }
    var fromProfilePicUrl: String { get set }
    
    var toPublicKey: String { get set }
    var toName: String { get set }
    var toProfilePicUrl: String { get set }
    
    var amount: Int { get set }
    
    var note: String { get set }
}
