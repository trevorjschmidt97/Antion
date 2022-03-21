//
//  FirebaseDatabaseService.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/18/21.
//

import Foundation
import FirebaseDatabase
import CodableFirebase

struct FirebaseDatabaseService {
    private init() { }
    static let shared = FirebaseDatabaseService()
    
    private let rootRef = Database.database().reference()
    
    private struct Key {
        static let usernames = "usernames"
        static let blockChain = "blockChain"
        static let pendingTransactions = "pendingTransactions"
    }
    
    func addBlockToChain(block: Block) {
        let data = try! FirebaseEncoder().encode(block)
        rootRef.child(Key.blockChain).child(String(block.index)).setValue(data)
    }
    
    func pullBlockChain(completion: @escaping ([Block]) -> Void) {
        rootRef.child(Key.blockChain).observe(.value) { snapshot in
            guard let value = snapshot.value else { return }
            
            do {
                let model = try FirebaseDecoder().decode([Block].self, from: value)
                completion(model.sorted { b1, b2 in
                    b1.timeStamp.longStringToDate() < b2.timeStamp.longStringToDate()
                })
            } catch let error {
                print("Error in file \(#filePath), line \(#line)")
                print(error)
            }
            
        }
    }
    
    func addPendingTransaction(transaction: Transaction) {
        let data = try! FirebaseEncoder().encode(transaction)
        rootRef.child(Key.pendingTransactions).child(transaction.id).setValue(data)
    }
    
    func removePendingTransaction(_ transaction: Transaction) {
        rootRef.child(Key.pendingTransactions).child(transaction.id).setValue(nil)
    }
    
    func pullPendingTransactions(completion: @escaping([String:Transaction]) -> Void) {
        rootRef.child(Key.pendingTransactions).observe(.value) { snapshot in
            guard let value = snapshot.value else { return }
            do {
                let model = try FirebaseDecoder().decode([String:Transaction].self, from: value)
                completion(model)
            } catch let error {
                printError()
                print(error)
                completion([:])
            }
        }
    }
    
}
