//
//  WalletTransactionsView.swift
//  Antion
//
//  Created by Trevor Schmidt on 2/28/22.
//

import SwiftUI

struct WalletTransactionsView: View {
    
    @ObservedObject var viewModel: WalletViewModel
    
    var walletState: WalletState
    @State private var isShowingRequestedTransactions = true
    @State private var isShowingPendingTransactions = true
    @State private var isShowingConfirmedTransactions = true
    
    var body: some View {
        VStack {
            Text("""
                 This wallet has a total of **\(viewModel.user.name)** transactions on the blockchain. It has received **\(viewModel.user.name)** antion and sent **\(viewModel.user.name)** antion.
                 """)
                .padding(.vertical)
                .padding(.horizontal, 30)
            
            if walletState == .own {
                
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
        }
    }
}

//struct WalletTransactionsView_Previews: PreviewProvider {
//    static var previews: some View {
//        WalletTransactionsView(viewModel: WalletViewModel(publicKey: "", name: "", profilePicUrl: ""))
//    }
//}
