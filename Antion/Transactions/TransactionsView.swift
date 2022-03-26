//
//  TransactionsView.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/22/21.
//

import SwiftUI

struct TransactionsView: View {
    
    @State private var transactionsSelection = "friends"
    @State private var createNewTransaction = false
    
    var body: some View {
        ZStack {
            // Transactions
            VStack {
                Picker("Selection", selection: $transactionsSelection) {
                    Text("Your Friends").tag("friends")
                    Text("All Users").tag("all")
                }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                List {
                    ForEach(transactionsSelection == "friends" ? AppViewModel.shared.blockChain.feedTransactions.sorted{ $0.timeStamp > $1.timeStamp } : AppViewModel.shared.blockChain.allConfirmedTransactions.sorted{ $0.timeStamp > $1.timeStamp }) { transaction in
                        PrettyTransactionView(transaction: transaction, transactionType: .confirmed)
                    }
                }
            }
            
            // Send/Receive Button
            VStack {
                Spacer()
                Button {
                    createNewTransaction.toggle()
                } label: {
                    SendRecieveAntionButton()
                }
            }
            
        }
            .navigationTitle("Transactions")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $createNewTransaction, onDismiss: nil) {
                NavigationView {
                    FindRecepientView()
                }
            }
    }
}
