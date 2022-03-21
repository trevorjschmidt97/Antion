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
                 This wallet has a total of **\(AppViewModel.shared.blockChain.numTransactionsOfWallet(address: viewModel.user.publicKey))** transaction\(AppViewModel.shared.blockChain.numTransactionsOfWallet(address: viewModel.user.publicKey) == 1 ? "" : "s") on the blockchain. It has received **\(AppViewModel.shared.blockChain.numReceivedBalance(address: viewModel.user.publicKey).formattedAmount())** antion and sent **\(AppViewModel.shared.blockChain.numSentBalance(address: viewModel.user.publicKey).formattedAmount())** antion.
                 """)
                .multilineTextAlignment(.center)
                .padding(.vertical)
                .padding(.horizontal, 30)
            
            if viewModel.walletState == .own {
                
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
                
            }
            
            if isShowingPendingTransactions && !AppViewModel.shared.blockChain.pendingTransactions(for: viewModel.user.publicKey).isEmpty {
                ForEach(AppViewModel.shared.blockChain.pendingTransactions(for: viewModel.user.publicKey)) { transaction in
                    PrettyTransactionView(transaction: transaction)
                        .padding(.horizontal)
                    Divider()
                        .padding(.leading)
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
            .onTapGesture {
                withAnimation {
                    isShowingConfirmedTransactions.toggle()
                }
            }
            
            if isShowingConfirmedTransactions {
                ForEach(AppViewModel.shared.blockChain.confirmedTransactions(address: viewModel.user.publicKey)) { transaction in
                    PrettyTransactionView(transaction: transaction)
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
