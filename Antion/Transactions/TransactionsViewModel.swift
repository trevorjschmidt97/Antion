//
//  TransactionsViewModel.swift
//  Antion
//
//  Created by Trevor Schmidt on 1/16/22.
//

import Foundation

class TransactionsViewModel: ObservableObject {
    
    @Published var transactions: [ConfirmedTransaction] = []
    
    @Published var searchUsers: [OtherUser] = []
    
    @Published var topPeopleUsers: [OtherUser] = []
    @Published var friends: [OtherUser] = []
    @Published var otherUsers: [OtherUser] = []
    
    func onAppear() {
        
    }
    
    @MainActor
    func fetchFeedTransactions() {
        guard AppViewModel.shared.publicKey != "" else { return }
        Task {
            if let retTransactions = try? await FirebaseFirestoreService.shared.fetchFeedTransactions(forPublicKey: AppViewModel.shared.publicKey) {
                transactions = retTransactions
            }
        }
    }
    
    func fetchRecepientsForTransaction() {
        FirebaseFirestoreService.shared.fetchRecepientsForTransaction { [weak self] retUsers in
            self?.topPeopleUsers = retUsers
        }
    }
    
    func postTransaction(_ transaction: ConfirmedTransaction) {
        FirebaseFirestoreService.shared.postPendingTransaction(transaction)
    }
    
}
