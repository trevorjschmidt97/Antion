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
    
    func block(forHash: String) -> Block {
        for block in chain {
            if block.hash == forHash {
                return block
            }
        }
        return chain[0]
    }
    
    var selfPendingTransactions: [Transaction] {
        var retPendingTransactions: [Transaction] = []
        for transaction in pendingTransactions {
            if transaction.fromPublicKey == AppViewModel.shared.publicKey || transaction.toPublicKey == AppViewModel.shared.publicKey {
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
            if transaction.fromPublicKey == address {
                retPendingTransactions.append(transaction)
            }
        }
        return retPendingTransactions
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
                if transaction.fromPublicKey == "" && transaction.note == "Mining Reward" && transaction.toPublicKey == address {
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
