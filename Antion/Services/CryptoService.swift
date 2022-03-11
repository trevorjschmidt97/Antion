//
//  Crypto.swift
//  SchmidtCoin
//
//  Created by Trevor Schmidt on 10/1/21.
//

import Foundation
import CryptoKit

struct CryptoService {
    static func hash(fromString input: String) -> String {
        let data = Data(input.utf8)
        let hash = SHA256.hash(data: data)
        return hash.map { String(format: "%02hhx", $0) }.joined()
    }
    
    static func generatePrivateKey() -> Curve25519.Signing.PrivateKey {
        return Curve25519.Signing.PrivateKey.init()
    }
    static func generateKeyPair() -> (String, String) {
        let privateKey = Curve25519.Signing.PrivateKey.init()
        return (privateKey.rawRepresentation.base64EncodedString(), privateKey.publicKey.rawRepresentation.base64EncodedString())
    }
    
    static func generatePrivateKey(fromString: String) -> Curve25519.Signing.PrivateKey? {
        if let data = Data(base64Encoded: fromString) {
            return try? Curve25519.Signing.PrivateKey.init(rawRepresentation: data)
        }
        return nil
    }
    
    static func generatePrivateKeyString(fromString: String) -> String? {
        if let data = Data(base64Encoded: fromString) {
            return try? Curve25519.Signing.PrivateKey.init(rawRepresentation: data).rawRepresentation.base64EncodedString()
        }
        return nil
    }
    
    static func generatePublicKey(fromString: String) -> Curve25519.Signing.PublicKey? {
        if let data = Data(base64Encoded: fromString) {
            return try? Curve25519.Signing.PublicKey.init(rawRepresentation: data)
        }
        return nil
    }
    
    static func getPublicKeyString(forPrivateKeyString skString: String) -> String? {
        if let sk = generatePrivateKey(fromString: skString) {
            return sk.publicKey.rawRepresentation.base64EncodedString()
        }
        return nil
    }
    
    /**
     Returns nil if can't convert transaction to data, or the signature method throws an error
     Returns a signature(data) if successfully signs transaction data.
    */
//    static func signTransaction(transaction: Transaction, privateKeyString: String) -> String? {
//        if let privateKey = generatePrivateKey(fromString: privateKeyString),
//           let transactionData = Transaction.transactionData(transaction: transaction),
//           let signatureData = try? privateKey.signature(for: transactionData) {
//            return signatureData.base64EncodedString()
//        }
//        return nil
//    }
    
    static func signInfo(privateKey: String, timeStamp: String, amount: Int, fromPublicKey: String, toPublicKey: String, note: String) -> String {
        let fullString = timeStamp + String(amount) + fromPublicKey + toPublicKey + note
        if let privateKey = generatePrivateKey(fromString: privateKey),
           let transactionData = fullString.data(using: .utf8),
           let signatureData = try? privateKey.signature(for: transactionData) {
            return signatureData.base64EncodedString()
        }
        return ""
    }

    /**
     Returns false if no signature,  no fromAddress, or can't convert transaction to Data.
     Returns true iff the signature is valid for the address and data.
    */
    static func isValidSignature(transaction: ConfirmedTransaction) -> Bool {
        
        let fullString = transaction.timeStamp + String(transaction.amount) + transaction.fromPublicKey + transaction.toPublicKey + transaction.note
        
        let fromAddress = transaction.fromPublicKey
        let signature = transaction.signature
        if let fromPublicKey = CryptoService.generatePublicKey(fromString: fromAddress),
           let signatureData = Data(base64Encoded: signature),
           let transactionData = fullString.data(using: .utf8) {
            return fromPublicKey.isValidSignature(signatureData, for: transactionData)
        }
        return false
    }
}
