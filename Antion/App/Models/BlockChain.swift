////
////  BlockChain.swift
////  SchmidtCoin
////
////  Created by Trevor Schmidt on 10/1/21.
////
//
//import Foundation
//import SwiftUI
//
//struct BlockChain {
//    var chain: [Block] = []
//    var isMining = false
//    
//    mutating func minePendingTransactions(pTransactions: [Transaction], miningRewardPublicKey: String) {
//        var index = 0
//        var previousHash = ""
//        var miningReward = 400
//        let difficulty = 4
//        
//        if let latestBlock = latestBlock() {
//            index = latestBlock.index + 1
//            previousHash = latestBlock.hash
//            // Change this for different miningReward / difficulty
//            miningReward = miningReward - latestBlock.index - 1
////            difficulty = difficulty + latestBlock.index
//        }
//        
//        // Get pending transactions
//        var pendingTransactionsList = pTransactions
//        var userBalances: [String:Int] = [:]
//        for (i, transaction) in pendingTransactionsList.enumerated() {
//            if !transaction.isValidSignature() {
//                let badTransaction = pendingTransactionsList.remove(at: i)
//                print("Transaction: \(badTransaction.id) invalid signature")
//                continue
//            }
//            
//            // Grab the balance if not already
//            if userBalances[transaction.fromPublicKey] == nil {
//                userBalances[transaction.fromPublicKey] = getBalanceOfWallet(address: transaction.fromPublicKey)
//            }
//            if userBalances[transaction.toPublicKey] == nil {
//                userBalances[transaction.toPublicKey] = getBalanceOfWallet(address: transaction.toPublicKey)
//            }
//            
//            let fromAddress = transaction.fromPublicKey
//                if transaction.amount > userBalances[fromAddress]! {
//                    print("Transaction: \(transaction.id) not enough balance")
//                    let badTransaction = pendingTransactionsList.remove(at: i)
//                    continue
//                }
//            
//            
//            // Now reset the balances
//            
//                userBalances[fromAddress] = userBalances[fromAddress]! - transaction.amount
//                userBalances[transaction.toPublicKey] = userBalances[transaction.toPublicKey]! + transaction.amount
//            
//            
//        }
//        
//        // Add reward Transaction
//        
////        let rewardTransaction = Transaction(fromPrivateKey: "", toAddress: miningRewardPublicKey, amount: miningReward, note: "Mining Reward")
////        pendingTransactionsList.append(rewardTransaction)
//        var newBlock = Block(index: index, transactions: pendingTransactionsList, previousHash: previousHash)
//        
//        // Mine the newBlock
//        isMining = true
//        
//        while (newBlock.hash.prefix(difficulty) != String(repeating: "0", count: difficulty) && self.isMining) {
//            newBlock.nonce += 1
//            newBlock.hash = Block.computeBlockHash(block: newBlock)
//        }
//        
//        if self.isMining {
//            for transaction in newBlock.transactions {
//                FirebaseFirestoreService.shared.savePublishedTransaction(transaction)
//                FirebaseFirestoreService.shared.removePendingTransaction(transaction)
//            }
//            FirebaseDatabaseService.shared.addBlockToChain(block: newBlock)
//            FirebaseDatabaseService.shared.deletePendingTransaction(transactions: newBlock.transactions)
//        }
//        
//        self.isMining = false
//    }
//    
//    private func getBalanceOfWallet(address: String) -> Int {
//        var bal = 0
//        
//        for block in chain {
//            for transaction in block.transactions {
//                let fromAddress = transaction.fromPublicKey
//                    if fromAddress == address {
//                        bal -= transaction.amount
//                    }
//                
//                if transaction.toPublicKey == address {
//                    bal += transaction.amount
//                }
//            }
//        }
//        
//        return bal
//    }
//    
//    func latestBlock() -> Block? {
//        chain.last
//    }
//    
//    private func isChainValid() -> Bool {
//        for (i, block) in chain.enumerated() {
//            if i != 0 {
//                if block.previousHash != chain[i-1].hash {
//                    return false
//                }
//            }
//            
//            if block.hash != Block.computeBlockHash(block: block) {
//                return false
//            }
//        }
//        return true
//    }
//    
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
////    var publishedTransactions: [Transaction] {
////        // Maybe use a minHeap in the future becuase it has a better BigO for sorting
////        var publishedTransactions: [Transaction] = []
////        for block in chain {
////            for transaction in block.transactions {
////                publishedTransactions.append(transaction)
////            }
////        }
////
////        return publishedTransactions.sorted { t1, t2 in
////            t1.timeStamp.longStringToDate() > t2.timeStamp.longStringToDate()
////        }
////    }
//    
////    func confirmedTransactions(forPrivateKey privateKey: String) -> [Transaction] {
////        var confirmedTransactions: [Transaction] = []
////        for block in chain {
////            for transaction in block.transactions {
////                if transaction.toAddress == CryptoService.getPublicKeyString(forPrivateKeyString: privateKey) ?? "" ||
////                    transaction.fromAddress ?? "" == CryptoService.getPublicKeyString(forPrivateKeyString: privateKey) ?? ""
////                {
////                    confirmedTransactions.append(transaction)
////                }
////            }
////        }
////        return confirmedTransactions.sorted { t1, t2 in
////            t1.timeStamp.longStringToDate() > t2.timeStamp.longStringToDate()
////        }
////    }
//
////    func pendingTransactions(forPrivateKey privateKey: String) -> [Transaction] {
////        let pendingTransactionsList = Array(pendingTransactions.values) as [Transaction]
////        return pendingTransactionsList.filter { transaction in
////            if let fromAddress = transaction.fromAddress {
////                return fromAddress == CryptoService.getPublicKeyString(forPrivateKeyString: privateKey) ?? ""
////            }
////            return false
////        }
////    }
//    
////    mutating func addPendingTransaction(_ transaction: Transaction) {
////        // No from address
////        guard let fromAddress = transaction.fromAddress else {
////            print("no from address")
////            return
////        }
////
////        // Not enough balance
////        if transaction.amount > getBalanceOfWallet(address: fromAddress) {
////            print("not enough balance")
////            return
////        }
////
////        // Invalid signature
////        if !CryptoService.isValidSignature(transaction: transaction) {
////            print("Invalidsignature")
////            return
////        }
////
////        pendingTransactions[transaction.id] = transaction
////        FirebaseDatabaseService.shared.addPendingTransaction(transaction: transaction)
////    }
