//
//  TransactionsView.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/22/21.
//

import SwiftUI

struct TransactionsView: View {
    
    @State private var transactionsSelection: TransactionsSelection = TransactionsSelection.first()

    @State private var movingForward = true
    
    @State private var createNewTransaction = false
    
    var body: some View {
        ZStack {
            // Transactions
            ScrollView(.vertical, showsIndicators: false) {
                Picker("Selection", selection: $transactionsSelection) {
                    Text("Your Friends").tag(TransactionsSelection.friends)
                    Text("All Users").tag(TransactionsSelection.all)
                }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    .onChange(of: transactionsSelection) { newValue in
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred(intensity: 1.0)
                    }
                
                ZStack(alignment: .top) {
                    Group {
                        switch transactionsSelection {
                        case .friends:
                            VStack {
                                ForEach(AppViewModel.shared.blockChain.feedTransactions.sorted{ $0.timeStamp > $1.timeStamp }) { transaction in
                                    PrettyTransactionView(transaction: transaction, transactionType: .confirmed)
                                        .padding(.horizontal)
                                }
                            }

                            
                        case .all:
                            VStack {
                                ForEach(AppViewModel.shared.blockChain.allConfirmedTransactions.sorted{ $0.timeStamp > $1.timeStamp }) { transaction in
                                    PrettyTransactionView(transaction: transaction, transactionType: .confirmed)
                                        .padding(.horizontal)
                                }
                            }
                        }
                    }
                    .transition(.asymmetric(insertion: .move(edge: transactionsSelection == .friends ? .leading : .trailing),
                                            removal: .move(edge: transactionsSelection == .friends ? .trailing : .leading)))
                    .animation(.default, value: transactionsSelection)
                }
                    .padding(.bottom, 80)
            }
//                .addSwipeGesture {
//                    // left to right
//                    if transactionsSelection.canPrevious() {
//                        transactionsSelection = transactionsSelection.previous()
//                    }
//                } rightToLeft: {
//                    if transactionsSelection.canNext() {
//                        transactionsSelection = transactionsSelection.next()
//                    }
//                }
            
            
              
            // Picker and Send/Receive Button
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

enum TransactionsSelection: Int, CaseIterable {
    case friends
    case all
    
    static func first() -> TransactionsSelection {
        TransactionsSelection.allCases[0]
    }
    
    static func last() -> TransactionsSelection {
        TransactionsSelection.allCases[TransactionsSelection.allCases.count - 1]
    }
    
    func canNext() -> Bool {
        self.rawValue != TransactionsSelection.allCases.count - 1
    }
    
    func canPrevious() -> Bool {
        self.rawValue != 0
    }
    
    func previous() -> TransactionsSelection {
        return TransactionsSelection(rawValue: self.rawValue - 1) ?? TransactionsSelection.first()
    }
    
    func next() -> TransactionsSelection {
        return TransactionsSelection(rawValue: self.rawValue + 1) ?? TransactionsSelection.last()
    }
}
