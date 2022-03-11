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
    
    @State private var selectedTransaction: ConfirmedTransaction?
    @State private var createNewTransaction = false
    
    var body: some View {
        ZStack {
            // Transactions
            List {
                ForEach(viewModel.transactions) { transaction in
                    Button {
                        selectedTransaction = transaction
                    } label: {
                        PrettyTransactionView(transaction: transaction)
                            .foregroundColor(.primary)
                    }

                }
            }
                .padding(.top, -25)
                .task {
                    viewModel.fetchFeedTransactions()
                }
                .refreshable {
                    viewModel.fetchFeedTransactions()
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
