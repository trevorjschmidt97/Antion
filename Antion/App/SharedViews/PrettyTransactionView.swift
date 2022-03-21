//
//  BasicTransactionView.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/23/21.
//

import SwiftUI

struct PrettyTransactionView: View {
    
    var transaction: Transaction
    
    @State private var isShowingFullTransaction = false
    @State private var showSheet = false
    
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
        guard transaction.fromPublicKey != "" else { return "" }
        if transaction.fromPublicKey == AppViewModel.shared.publicKey {
            return AppViewModel.shared.profilePicUrl
        } else if AppViewModel.shared.user.friendsSet.contains(transaction.fromPublicKey) {
            return AppViewModel.shared.user.friendsMap[transaction.fromPublicKey]?.profilePicUrl ?? ""
        } else if AppViewModel.shared.user.otherRequestedFriendsSet.contains(transaction.fromPublicKey) {
            return AppViewModel.shared.user.otherRequestedFriendsMap[transaction.fromPublicKey]?.profilePicUrl ?? ""
        }
        return ""
    }
    
    var fromToText: String {
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
        
        retString += " paid "
        
        if transaction.toPublicKey == AppViewModel.shared.publicKey {
            retString += "**You**"
        } else {
            retString += "**" + toName + "**"
        }
        
        
        return retString
    }
    
    var body: some View {
        HStack {
            VStack {
                ProfilePicView(username: fromName,
                               profilePicUrl: fromProfilePicUrl,
                               size: 50)
                    .padding(.vertical)
//                HStack {
//                    VStack {
//                        Image(systemName: "heart")
//                        Text(transaction.amount == 0 ? "" : String(transaction.amount))
//                            .font(.caption)
//                        Spacer()
//                    }
//                    VStack {
//                        Image(systemName: "bubble.left")
//                        Text(transaction.amount == 0 ? "" : String(transaction.amount))
//                            .font(.caption)
//                        Spacer()
//                    }
//
//                }
//                .padding(.leading, -13)
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
                .padding(.bottom)
                Text("\(transaction.note)")
                    .fixedSize(horizontal: false, vertical: true)
                
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
                    Text("\(transaction.timeStamp)")
                        .toolbar {
                            ToolbarItemGroup(placement: .navigationBarLeading) {
                                Button("Done") {
                                    showSheet = false
                                }
                            }
                        }
                }
            }
//        .onTapGesture {
//            isShowingFullTransaction.toggle()
//        }
//        .sheet(isPresented: $isShowingFullTransaction, onDismiss: nil) {
//            PrettyTransactionView(transaction: transaction)
//        }
    }
}

//struct BasicTransactionView_Previews: PreviewProvider {
//    static var previews: some View {
//        List {
//            PrettyTransactionView(transaction: ConfirmedTransaction(timeStamp: "2022-01-26 18:10:45.2030", amount: 69, fromPublicKey: "zRgvFk5fj5kmzZboRtoCcVBWXlktYKsNfepv1wrE9JQ=", toPublicKey: "B6A6h/IAGegOKjU63gxznfQXylF43jPrx8iqBxg0ZaU=", note: "Pizza, Yum", signature: "4ZrWATgMqdCdv2bHPc5m6JRzHDm4Nmgrr0+3aG5Yt4LZVBJaLNEmTRioSWPttpATdZSCsI+CcSAYF5I9eqiLAw==", fromName: "Trevor Jay Schmidt", toName: "Sarah", fromProfilePicUrl: "https://firebasestorage.googleapis.com/v0/b/w8trkr-3356b.appspot.com/o/userProfilePics%2FDcapBesjwuhYBbE3q5mG3gll4iy2.jpg?alt=media&token=7f316ec4-4685-4c7f-a63f-98b9461c101a"))
//        }
//    }
//}
