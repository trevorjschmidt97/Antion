//
//  BasicTransactionView.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/23/21.
//

import SwiftUI

struct PrettyTransactionView: View {
    
    var transaction: Transaction
    var transactionType: TransactionType
    
    enum TransactionType {
        case confirmed
        case pending
        case requested
    }
    
    @State private var isShowingFullTransaction = false
    @State private var showSheet = false
    @State private var requestedTransaction: Transaction?
    
    var fromName: String {
        guard transaction.fromPublicKey != "" else { return "Block Reward" }
        if transaction.fromPublicKey == AppViewModel.shared.publicKey {
            return AppViewModel.shared.name
        } else if AppViewModel.shared.user.friendsSet.contains(transaction.fromPublicKey) {
            return AppViewModel.shared.user.friendsMap[transaction.fromPublicKey]?.name ?? "Anonymous"
        } else if AppViewModel.shared.user.otherRequestedFriendsSet.contains(transaction.fromPublicKey) {
            return AppViewModel.shared.user.otherRequestedFriendsMap[transaction.fromPublicKey]?.name ?? "Anonymous"
        }
        return "Anonymous"
    }
    
    var toName: String {
        guard transaction.toPublicKey != "" else { return "Block Reward" }
        if transaction.toPublicKey == AppViewModel.shared.publicKey {
            return AppViewModel.shared.name
        } else if AppViewModel.shared.user.friendsSet.contains(transaction.toPublicKey) {
            return AppViewModel.shared.user.friendsMap[transaction.toPublicKey]?.name ?? "Anonymous"
        } else if AppViewModel.shared.user.otherRequestedFriendsSet.contains(transaction.toPublicKey) {
            return AppViewModel.shared.user.otherRequestedFriendsMap[transaction.toPublicKey]?.name ?? "Anonymous"
        }
        return "Anonymous"
    }
    
    var fromProfilePicUrl: String {
        var publicKey = transaction.fromPublicKey
        if transactionType == .requested {
            publicKey = transaction.toPublicKey
        }
        
        guard publicKey != "" else { return "" }
        if publicKey == AppViewModel.shared.publicKey {
            return AppViewModel.shared.profilePicUrl
        } else if AppViewModel.shared.user.friendsSet.contains(publicKey) {
            return AppViewModel.shared.user.friendsMap[publicKey]?.profilePicUrl ?? ""
        } else if AppViewModel.shared.user.otherRequestedFriendsSet.contains(publicKey) {
            return AppViewModel.shared.user.otherRequestedFriendsMap[publicKey]?.profilePicUrl ?? ""
        }
        return ""
    }
    
    var fromToText: String {
        if transaction.fromPublicKey == "" && transaction.note == "Welcome to Antion" {
            return "**" + toName + "'s** first transaction"
        }
        switch transactionType {
        case .confirmed:
            var retString = ""
            if transaction.fromPublicKey != "" {
                if transaction.fromPublicKey == AppViewModel.shared.publicKey {
                    retString += "**You**"
                } else {
                    retString += "**" + fromName + "**"
                }
            } else {
                retString += "**Block Reward**"
            }
            
            if transactionType == .confirmed {
                retString += " paid "
            }
            
            if transaction.toPublicKey == AppViewModel.shared.publicKey {
                retString += "**You**"
            } else {
                retString += "**" + toName + "**"
            }
            return retString
        case .pending:
            var retString = ""
            
            if transaction.fromPublicKey == AppViewModel.shared.publicKey {
                retString += "**Your**"
            } else {
                retString += "**" + fromName + "'s**"
            }
            
            
            retString += " transaction to "
            if transaction.toPublicKey == AppViewModel.shared.publicKey {
                retString += "**You**"
            } else {
                retString += "**\(toName)**"
            }
            
            retString += " is pending"
            
            return retString
        case .requested:
            var retRequestedString = ""
            if transaction.toPublicKey == AppViewModel.shared.publicKey {
                retRequestedString += "**You**"
            } else {
                retRequestedString += "**" + toName + "**"
            }
            
            retRequestedString += " \(transaction.toPublicKey == AppViewModel.shared.publicKey ? "request" : "requests") antion from "
            
            if transaction.fromPublicKey == AppViewModel.shared.publicKey {
                retRequestedString += "**You**"
            } else {
                retRequestedString += "**" + fromName + "**"
            }
            return retRequestedString
        }
    }
    
    var body: some View {
        HStack {
            VStack {
                ProfilePicView(username: fromName,
                               profilePicUrl: fromProfilePicUrl,
                               size: 50)
                    .padding(.vertical)
                Spacer()
            }
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text(.init(fromToText))
                            .fixedSize(horizontal: false, vertical: true)
                        Text("\(transaction.timeStamp.longStringToDate().timeAgoDisplay())")
                            .font(.caption)
                            .padding(.top, -5)
                    }
                    .padding(.bottom, 0.1)
                    Spacer()
                    Text("\(transaction.formattedAmount) A")
                }
                .padding(.bottom, 3)
                Text("\(transaction.note)")
                    .fixedSize(horizontal: false, vertical: true)
                
                if transactionType == .requested {
                    if transaction.toPublicKey == AppViewModel.shared.publicKey {
                        HStack {
                            Button {
                                AppViewModel.shared.deleteRequestedTransaction(transaction: transaction)
                            } label: {
                                HStack {
                                    Spacer()
                                    Text("Cancel")
                                        .fontWeight(.bold)
                                    Spacer()
                                }
                                    .foregroundColor(.white)
                                    .padding(.vertical, 4)
                                    .background(AppViewModel.shared.accentColor)
                                    .cornerRadius(20)
                                    .padding(.horizontal, 1)
                            }
                        }
                        .padding(.horizontal)
                    } else {
                        HStack {
                            Button {
                                AppViewModel.shared.deleteRequestedTransaction(transaction: transaction)
                            } label: {
                                HStack {
                                    Spacer()
                                    Text("Decline")
                                        .fontWeight(.bold)
                                    Spacer()
                                }
                                    .foregroundColor(.white)
                                    .padding(.vertical, 4)
                                    .background(AppViewModel.shared.accentColor)
                                    .cornerRadius(20)
                                    .padding(.horizontal, 1)
                            }
                            
                            
                            
                            Button {
                                requestedTransaction = transaction
                            } label: {
                                HStack {
                                    Spacer()
                                    Text("Pay")
                                        .fontWeight(.bold)
                                    Spacer()
                                }
                                    .foregroundColor(.white)
                                    .padding(.vertical, 4)
                                    .background(AppViewModel.shared.accentColor)
                                    .cornerRadius(20)
                                    .padding(.horizontal, 1)
                            }

                        }
                            .padding(.horizontal)
                    }

                }
                
                Spacer()
            }
            .padding(.top)
            .padding(.bottom, 3)
        }
            .onTapGesture {
                showSheet.toggle()
            }
            .sheet(isPresented: $showSheet) {
                NavigationView {
                    FullTransactionView(transaction: transaction)
                        .toolbar {
                            ToolbarItemGroup(placement: .navigationBarLeading) {
                                Button("Done") {
                                    showSheet = false
                                }
                            }
                        }
                }
            }
            .sheet(item: $requestedTransaction) { requestedTransaction in
                NavigationView {
                    FulfillTransactionView(incomingTransaction: requestedTransaction, timeStamp: Date().toLongString())
                }
            }
    }
}


// MARK: For Future: Comments/Likes Count
//HStack {
//    VStack {
//        Image(systemName: "heart")
//        Text(transaction.amount == 0 ? "" : String(transaction.amount))
//            .font(.caption)
//        Spacer()
//    }
//    VStack {
//        Image(systemName: "bubble.left")
//        Text(transaction.amount == 0 ? "" : String(transaction.amount))
//            .font(.caption)
//        Spacer()
//    }
//
//}
//.padding(.leading, -13)
