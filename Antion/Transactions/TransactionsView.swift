//
//  TransactionsView.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/22/21.
//

import SwiftUI

struct TransactionsView: View {
    
    @StateObject var viewModel = TransactionsViewModel()
    @State private var searchText = ""
    
    @State private var transactionsSelection = true
    
    @State private var selectedTransaction: Transaction?
    @State private var createNewTransaction = false
    var body: some View {
        ZStack {
            // Transactions
            VStack {
                Picker("Selection", selection: $transactionsSelection) {
                    Text("Friends").tag(true)
                    Text("Worldwide").tag(false)
                }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                List {
                    ForEach(transactionsSelection ? AppViewModel.shared.blockChain.feedTransactions : AppViewModel.shared.blockChain.allConfirmedTransactions) { transaction in
                        PrettyTransactionView(transaction: transaction)
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
            .onAppear {
                viewModel.onAppear()
            }
            .navigationTitle("Transactions")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $createNewTransaction, onDismiss: nil) {
                NavigationView {
                    FindRecepientView()
                }
            }
            .sheet(item: $selectedTransaction, onDismiss: nil) { transaction in
                NavigationView {
                    Text("\(transaction.timeStamp)")
                        .toolbar {
                            ToolbarItemGroup(placement: .navigationBarLeading) {
                                Button("Done") {
                                    selectedTransaction = nil
                                }
                            }
                        }
                }
            }
            .environmentObject(viewModel)
    }
}
