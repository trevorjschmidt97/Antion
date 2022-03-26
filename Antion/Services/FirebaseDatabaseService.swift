//
//  FirebaseDatabaseService.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/18/21.
//

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
        static let timeStamp = "timeStamp"
        static let fromPublicKey = "fromPublicKey"
    }
    
    func addBlockToChain(block: Block) {
        let data = try! FirebaseEncoder().encode(block)
        rootRef.child(Key.blockChain).child(String(block.index)).setValue(data)
    }
    
    func pullBlockChain(completion: @escaping (Result<[Block],Error>) -> Void) {
        rootRef.child(Key.blockChain).observe(.value) { snapshot in
            guard let value = snapshot.value else {
                completion(.failure(FirebaseFirestoreService.FirestoreError.UnwrappingSnapshotFailed))
                return }
            
            do {
                let model = try FirebaseDecoder().decode([Block].self, from: value)

                completion(.success(model.sorted{ $0.timeStamp < $1.timeStamp }))
                return
            } catch let error {
                print("Error in file \(#filePath), line \(#line)")
                print(error)
                completion(.failure(error))
                return
            }
            
        }
    }
    
    func addPendingTransaction(transaction: Transaction) {
        let data = try! FirebaseEncoder().encode(transaction)
        rootRef.child(Key.pendingTransactions).child(transaction.id).setValue(data)
    }
    
    func pullPendingTransactions(completion: @escaping(Result<[Transaction],Error>) -> Void) {
        rootRef
            .child(Key.pendingTransactions)
            .observe(.value, with: { snapshot in
                guard let value = snapshot.value as? [String:Any] else {
                    completion(.failure(FirebaseFirestoreService.FirestoreError.UnwrappingSnapshotFailed))
                    return }
                
                do {
                    let model = try FirebaseDecoder().decode([Transaction].self, from: Array(value.values))
                    let sorted = model.sorted{ $0.timeStamp < $1.timeStamp }
                    completion(.success(sorted))
                } catch let error {
                    print("Error in file \(#filePath), line \(#line)")
                    completion(.failure(error))
                }
            })
    }
    
    func removePendingTransaction(_ transaction: Transaction) {
        rootRef.child(Key.pendingTransactions).child(transaction.id).setValue(nil)
    }

}
