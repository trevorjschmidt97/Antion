//
//  WalletTransactionsView.swift
//  Antion
//
//  Created by Trevor Schmidt on 2/28/22.
//

import SwiftUI

struct WalletTransactionsView: View {
    
    @ObservedObject var viewModel: WalletViewModel
    
    @State private var isShowingRequestedTransactions = true
    @State private var isShowingPendingTransactions = true
    @State private var isShowingConfirmedTransactions = true
    
    var body: some View {
        VStack {
            Text("""
                 This wallet has **\(AppViewModel.shared.blockChain.numTransactionsOfWallet(address: viewModel.user.publicKey))** confirmed transaction\(AppViewModel.shared.blockChain.numTransactionsOfWallet(address: viewModel.user.publicKey) == 1 ? "" : "s"). It has received **\(AppViewModel.shared.blockChain.numReceivedBalance(address: viewModel.user.publicKey).formattedAmount())** and sent **\(AppViewModel.shared.blockChain.numSentBalance(address: viewModel.user.publicKey).formattedAmount())** antion.
                 """)
                .multilineTextAlignment(.center)
                .padding(.vertical)
                .padding(.horizontal, 30)
            
            if viewModel.walletState == .own {
                if viewModel.user.requestedTransactions.count > 0 {
                    HStack {
                        Text("Requested Transactions")
                            .font(.title3)
                            .fontWeight(.bold)
                        Spacer()
                        Image(systemName: isShowingRequestedTransactions ? "chevron.down" : "chevron.up")
                    }
                    .font(.headline)
                    .padding(.horizontal)
                    .onTapGesture {
                        withAnimation {
                            isShowingRequestedTransactions.toggle()
                        }
                    }
                    
                    if isShowingRequestedTransactions {
                        ForEach(viewModel.user.requestedTransactions.sorted{ $0.timeStamp > $1.timeStamp }) { reqTransaction in
                            PrettyTransactionView(transaction: reqTransaction, transactionType: .requested)
                                .padding(.horizontal)
                        }
                    }
                }
                
                
                if AppViewModel.shared.blockChain.selfPendingTransactions.count > 0 {
                    HStack {
                        Text("Pending Transactions")
                            .font(.title3)
                            .fontWeight(.bold)
                        Spacer()
                        Image(systemName: isShowingPendingTransactions ? "chevron.down" : "chevron.up")
                    }
                    .font(.headline)
                    .padding(.horizontal)
                    .padding(.top)
                    .onTapGesture {
                        withAnimation {
                            isShowingPendingTransactions.toggle()
                        }
                    }
                    
                    if isShowingPendingTransactions {
                        ForEach(AppViewModel.shared.blockChain.selfPendingTransactions.sorted{ $0.timeStamp > $1.timeStamp }) { transaction in
                            PrettyTransactionView(transaction: transaction, transactionType: .pending)
                                .padding(.horizontal)
                            Divider()
                                .padding(.leading)
                        }
                    }
                }
                
            }
            
            HStack {
                Text("Confirmed Transactions")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
                Image(systemName: isShowingConfirmedTransactions ? "chevron.down" : "chevron.up")
            }
            .font(.headline)
            .padding(.horizontal)
            .padding(.top)
            .padding(.bottom, isShowingConfirmedTransactions && AppViewModel.shared.blockChain.confirmedTransactions(address: viewModel.user.publicKey).count > 0 ? 0 : 30)
            .onTapGesture {
                withAnimation {
                    isShowingConfirmedTransactions.toggle()
                }
            }
            
            if isShowingConfirmedTransactions {
                ForEach(AppViewModel.shared.blockChain.confirmedTransactions(address: viewModel.user.publicKey).sorted{ $0.timeStamp > $1.timeStamp }) { transaction in
                    PrettyTransactionView(transaction: transaction, transactionType: .confirmed)
                        .padding(.horizontal)
                    Divider()
                        .padding(.leading)
                }
            }
        }
    }
}

//struct WalletTransactionsView_Previews: PreviewProvider {
//    static var previews: some View {
//        WalletTransactionsView(viewModel: WalletViewModel(publicKey: "", name: "", profilePicUrl: ""))
//    }
//}
