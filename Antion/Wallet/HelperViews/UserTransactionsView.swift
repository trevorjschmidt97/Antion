//
//  UserTransactionsView.swift
//  Antion
//
//  Created by Trevor Schmidt on 1/25/22.
//

import SwiftUI

struct UserTransactionsView: View {
    
    // help people make good decisions about investing in crypto
    
    @EnvironmentObject var viewModel: WalletViewModel
    
    var body: some View {
        EmptyView()
//        Section("Received Requested Transactions") {
//            ForEach(viewModel.receivedRequestedTransactions) { transaction in
//                Divider()
//                    .padding(.leading)
//                NavigationLink {
//                    RawTransactionView(transaction: transaction)
//                        .padding(.horizontal)
//                } label: {
//                    PrettyTransactionView(transaction: transaction)
//                        .foregroundColor(.primary)
//                        .padding(.horizontal)
//                }
//            }
//        }
//        Section("Sent Requested Transactions") {
//            ForEach(viewModel.sendRequestedTransactions) { transaction in
//                Divider()
//                    .padding(.leading)
//                NavigationLink {
//                    RawTransactionView(transaction: transaction)
//                        .padding(.horizontal)
//                } label: {
//                    PrettyTransactionView(transaction: transaction)
//                        .foregroundColor(.primary)
//                        .padding(.horizontal)
//                }
//            }
//        }
//        Section("Pending Transactions") {
//            ForEach(viewModel.pendingTransactions) { transaction in
//                Divider()
//                    .padding(.leading)
//                NavigationLink {
//                    RawTransactionView(transaction: transaction)
//                        .padding(.horizontal)
//                } label: {
//                    PrettyTransactionView(transaction: transaction)
//                        .foregroundColor(.primary)
//                        .padding(.horizontal)
//                }
//            }
//        }
//        Section("Confirmed Transactions") {
//            ForEach(viewModel.confirmedTransactions) { transaction in
//                Divider()
//                    .padding(.leading)
//                NavigationLink {
//                    RawTransactionView(transaction: transaction)
//                        .padding(.horizontal)
//                } label: {
//                    PrettyTransactionView(transaction: transaction)
//                        .foregroundColor(.primary)
//                        .padding(.horizontal)
//                }
//            }
//        }
    }
}

//struct UserTransactionsView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserTransactionsView()
//    }
//}
