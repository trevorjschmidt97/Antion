//
//  TransactionsViewModel.swift
//  Antion
//
//  Created by Trevor Schmidt on 1/16/22.
//

import Foundation

class TransactionsViewModel: ObservableObject {
    
    @Published var transactions: [Transaction] = []
    
    @Published var searchUsers: [Friend] = []
    
    @Published var topPeopleUsers: [Friend] = []
    @Published var friends: [Friend] = []
    @Published var otherUsers: [Friend] = []
    
    func onAppear() {
        
    }
    
  
    
    func fetchRecepientsForTransaction() {
        FirebaseFirestoreService.shared.fetchRecepientsForTransaction { [weak self] retUsers in
            self?.topPeopleUsers = retUsers
        }
    }
    
    func postTransaction(_ transaction: Transaction) {
//        FirebaseFirestoreService.shared.postPendingTransaction(transaction)
    }
    
}
