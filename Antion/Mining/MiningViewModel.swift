//
//  MiningViewModel.swift
//  Antion
//
//  Created by Trevor Schmidt on 1/16/22.
//

import Foundation

class MiningViewModel: ObservableObject {
    
    @Published var blockChain: [Block] = []
    @Published var pendingTransactions: [ConfirmedTransaction] = []
    
    @Published var isMining = false
    
    var latestBlock: Block? {
        return blockChain.last
    }
    
    func onAppear() {
        FirebaseFirestoreService.shared.getPendingTransactions { [weak self] retTransactions in
            DispatchQueue.main.async {
                self?.pendingTransactions = retTransactions
            }
        }
        FirebaseFirestoreService.shared.getBlockchain { [weak self] retBlockchain in
            DispatchQueue.main.async {
                self?.blockChain = retBlockchain
            }
        }
    }
    
    func startMiningButtonTapped() {
        isMining = true
        
        // Start values
        var index = 0
        var previousHash = ""
        var miningReward = 400
        var difficulty = 4

        if let latestBlock = latestBlock {
            index = latestBlock.index + 1
            previousHash = latestBlock.hash
            // Change this for different miningReward / difficulty
            miningReward = Int(Double(miningReward) * pow(0.5, floor(Double(index)/100000)))
            difficulty = difficulty + (latestBlock.index / 10)
        }

        // Get pending transactions
        var pendingTransactionsList = pendingTransactions
//        var userBalances: [String:Int] = [:]
        
        // Check all pendingTransactions
        for (i, transaction) in pendingTransactionsList.enumerated() {
            // If is an invalid signaure
            if !transaction.isValidSignature() {
                let badTransaction = pendingTransactionsList.remove(at: i)
                print("Transaction: \(badTransaction.id) invalid signature")
                continue
            }
        }

        // Add reward Transaction
//        let rewardTransaction = ConfirmedTransaction(timeStamp: Date.now.toLongString(),
//                                            amount: miningReward,
//                                            fromPublicKey: "",
//                                            toPublicKey: AppViewModel.shared.userInfo.publicKey,
//                                            note: "Mining Reward",
//                                            signature: "",
//                                            fromName: "Mining Reward",
//                                            toName: AppViewModel.shared.userInfo.name,
//                                            fromProfilePicUrl: "")
//
//        pendingTransactionsList.append(rewardTransaction)
        var newBlock = exampleBlock

        
        // Mine the newBlock
        isMining = true
//        DispatchQueue.init(label: "mine").async {
//            while (newBlock.hash.prefix(difficulty) != String(repeating: "0", count: difficulty) && self.isMining) {
//                newBlock.nonce += 1
//                newBlock.hash = Block.computeBlockHash(block: newBlock)
//            }
//            DispatchQueue.main.async {
//                if self.isMining {
//                    // Do database stuff
//                    for transaction in newBlock.transactions {
//                        FirebaseFirestoreService.shared.removePendingTransaction(transaction)
//                        Task {
//                            await FirebaseFirestoreService.shared.savePublishedTransaction(transaction)
//                        }
//                    }
//                    FirebaseFirestoreService.shared.saveBlock(newBlock)
////                    FirebaseDatabaseService.shared.addBlockToChain(block: newBlock)
////                    self.pendingTransactions.removeAll()
////                    FirebaseDatabaseService.shared.deletePendingTransaction(transactions: newBlock.transactions)
//                }
//                
//                self.isMining = false
//            }
//        }

    }
}
