//
//  BlockChain.swift
//  SchmidtCoin
//
//  Created by Trevor Schmidt on 10/1/21.
//

import Foundation
import SwiftUI

struct BlockChain {
    var chain: [Block] = []
    var pendingTransactions: [Transaction] = []
    
    var feedTransactions: [Transaction] {
        var retTransactions: [Transaction] = []
        for chain in chain {
            for transaction in chain.transactions {
                if transaction.fromPublicKey == AppViewModel.shared.publicKey ||
                    AppViewModel.shared.user.friendsSet.contains(transaction.fromPublicKey) ||
                    transaction.toPublicKey == AppViewModel.shared.publicKey ||
                    AppViewModel.shared.user.friendsSet.contains(transaction.toPublicKey) {
                    retTransactions.append(transaction)
                }
            }
        }
        return retTransactions
    }
    
    func pendingTransactions(for address: String) -> [Transaction] {
        var retPendingTransactions: [Transaction] = []
        for transaction in pendingTransactions {
            if transaction.fromPublicKey == address || transaction.toPublicKey == address {
                retPendingTransactions.append(transaction)
            }
        }
        return retPendingTransactions
    }
    
    func minedBlocks(forAddress address: String) -> [Block] {
        var retBlocks: [Block] = []
        for block in chain {
            if block.minerPublicKey == address {
                retBlocks.append(block)
            }
        }
        return retBlocks
    }
    
    func getBalanceOfWallet(address: String) -> Int {
        var bal = 0
        
        for block in chain {
            for transaction in block.transactions {
                if transaction.fromPublicKey == address {
                    bal -= transaction.amount
                }
                
                if transaction.toPublicKey == address {
                    bal += transaction.amount
                }
            }
        }
        
        return bal
    }
    
    func numTransactionsOfWallet(address: String) -> Int {
        var count = 0
        
        for block in chain {
            for transaction in block.transactions {
                if transaction.fromPublicKey == address || transaction.toPublicKey == address {
                    count += 1
                }
            }
        }
        
        return count
    }
    
    func numReceivedBalance(address: String) -> Int {
        var count = 0
        
        for block in chain {
            for transaction in block.transactions {
                if transaction.toPublicKey == address {
                    count += transaction.amount
                }
            }
        }
        
        return count
    }
    
    func numSentBalance(address: String) -> Int {
        var count = 0
        
        for block in chain {
            for transaction in block.transactions {
                if transaction.fromPublicKey == address {
                    count += transaction.amount
                }
            }
        }
        
        return count
    }
    
    func numMinedBlocks(address: String) -> Int {
        var count = 0
        
        for block in chain {
            if block.minerPublicKey == address {
                count += 1
            }
        }
        
        return count
    }
    
    func numReceivedRewards(address: String) -> Int {
        var count = 0
        
        for block in chain {
            for transaction in block.transactions {
                if transaction.fromPublicKey == "" && transaction.note == "Mining Reward" {
                    count += transaction.amount
                }
            }
        }
        
        return count
    }
    
    func confirmedTransactions(address: String) -> [Transaction] {
        var confirmedTransactions: [Transaction] = []
        
        for block in chain {
            for transaction in block.transactions {
                if transaction.fromPublicKey == address || transaction.toPublicKey == address {
                    confirmedTransactions.append(transaction)
                }
            }
        }
        
        return confirmedTransactions
    }
    
    var allConfirmedTransactions: [Transaction] {
        var confirmedTransactions: [Transaction] = []
        
        for block in chain {
            for transaction in block.transactions {
                confirmedTransactions.append(transaction)
            }
        }
        
        return confirmedTransactions
    }
    
    func latestBlock() -> Block? {
        chain.last
    }
    
    private func isChainValid() -> Bool {
        var balances: [String:Int] = [:]
        for (i, block) in chain.enumerated() {
            if i != 0 {
                if block.previousHash != chain[i-1].hash {
                    return false
                }
            }
            
            if block.hash != CryptoService.hashBlock(block) {
                return false
            }
            
            for transaction in block.transactions {
                if balances[transaction.fromPublicKey] != nil {
                    balances[transaction.fromPublicKey]! -= transaction.amount
                } else {
                    balances[transaction.fromPublicKey] = -transaction.amount
                }
                if balances[transaction.toPublicKey] != nil {
                    balances[transaction.fromPublicKey]! += transaction.amount
                } else {
                    balances[transaction.fromPublicKey] = transaction.amount
                }
                if !transaction.isValidSignature() {
                    return false
                }
            }
        }
        
        for user in balances.keys {
            if let balance = balances[user], balance < 0 {
                return false
            }
        }
        
        return true
    }
    
}























//    var publishedTransactions: [Transaction] {
//        // Maybe use a minHeap in the future becuase it has a better BigO for sorting
//        var publishedTransactions: [Transaction] = []
//        for block in chain {
//            for transaction in block.transactions {
//                publishedTransactions.append(transaction)
//            }
//        }
//
//        return publishedTransactions.sorted { t1, t2 in
//            t1.timeStamp.longStringToDate() > t2.timeStamp.longStringToDate()
//        }
//    }
    
//    func confirmedTransactions(forPrivateKey privateKey: String) -> [Transaction] {
//        var confirmedTransactions: [Transaction] = []
//        for block in chain {
//            for transaction in block.transactions {
//                if transaction.toAddress == CryptoService.getPublicKeyString(forPrivateKeyString: privateKey) ?? "" ||
//                    transaction.fromAddress ?? "" == CryptoService.getPublicKeyString(forPrivateKeyString: privateKey) ?? ""
//                {
//                    confirmedTransactions.append(transaction)
//                }
//            }
//        }
//        return confirmedTransactions.sorted { t1, t2 in
//            t1.timeStamp.longStringToDate() > t2.timeStamp.longStringToDate()
//        }
//    }

//    func pendingTransactions(forPrivateKey privateKey: String) -> [Transaction] {
//        let pendingTransactionsList = Array(pendingTransactions.values) as [Transaction]
//        return pendingTransactionsList.filter { transaction in
//            if let fromAddress = transaction.fromAddress {
//                return fromAddress == CryptoService.getPublicKeyString(forPrivateKeyString: privateKey) ?? ""
//            }
//            return false
//        }
//    }
    
//    mutating func addPendingTransaction(_ transaction: Transaction) {
//        // No from address
//        guard let fromAddress = transaction.fromAddress else {
//            print("no from address")
//            return
//        }
//
//        // Not enough balance
//        if transaction.amount > getBalanceOfWallet(address: fromAddress) {
//            print("not enough balance")
//            return
//        }
//
//        // Invalid signature
//        if !CryptoService.isValidSignature(transaction: transaction) {
//            print("Invalidsignature")
//            return
//        }
//
//        pendingTransactions[transaction.id] = transaction
//        FirebaseDatabaseService.shared.addPendingTransaction(transaction: transaction)
//    }
