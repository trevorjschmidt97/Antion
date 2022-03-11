//
//  BasicTransactionView.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/23/21.
//

import SwiftUI

struct PrettyTransactionView: View {
    
    var transaction: ConfirmedTransaction
    
    @State private var isShowingFullTransaction = false
    
    var fromToText: String {
        var retString = ""
        if transaction.fromPublicKey != "" {
            if transaction.fromPublicKey == AppViewModel.shared.publicKey {
                retString += "**You**"
            } else {
                retString += "**" + transaction.fromName + "**"
            }
        } else {
            retString += "**Block Reward**"
        }
        
        retString += " paid "
        
        if transaction.toPublicKey == AppViewModel.shared.publicKey {
            retString += "**You**"
        } else {
            retString += "**" + transaction.toName + "**"
        }
        
        
        return retString
    }
    
    var body: some View {
        HStack {
            VStack {
                ProfilePicView(username: transaction.fromName, profilePicUrl: transaction.fromProfilePicUrl, size: 50)
                    .padding(.vertical)
                HStack {
                    VStack {
                        Image(systemName: "heart")
                        Text(transaction.numLikes == 0 ? "" : String(transaction.numLikes))
                            .font(.caption)
                        Spacer()
                    }
                    VStack {
                        Image(systemName: "bubble.left")
                        Text(transaction.numComments == 0 ? "" : String(transaction.numComments))
                            .font(.caption)
                        Spacer()
                    }
                    
                }
                .padding(.leading, -13)
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
