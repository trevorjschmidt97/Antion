//
//  FullTransactionView.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/27/21.
//

import SwiftUI

struct FullTransactionView: View {
    
    var transaction: Transaction
    
    @State private var selectedWalletUser: Friend?
    
    @ViewBuilder
    func idView() -> some View {
        HStack {
            Text("**ID:**")
            Spacer()
            Text("\(transaction.id)")
                .font(.footnote)
        }
            .padding(.horizontal)
            .padding(.top)
        Divider()
    }
    
    @ViewBuilder
    func dateStampView() -> some View {
        HStack {
            Text("**DateStamp:**")
            Spacer()
            Text("\(transaction.timeStamp)")
        }
            .padding(.horizontal)
        Divider()
    }
    
    func name(forPublicKey: String) -> String {
        var fromName = "Anonymous"
        
        if forPublicKey == AppViewModel.shared.user.publicKey {
            fromName = "You"
        } else if let friend = AppViewModel.shared.user.friendsMap[forPublicKey] {
            fromName = friend.name
        } else if let otherReq = AppViewModel.shared.user.otherRequestedFriendsMap[forPublicKey] {
            fromName = otherReq.name
        }
        
        return fromName
    }
    
    func profilePicUrl(forPublicKey: String) -> String {
        var profilePicUrl = ""
        
        if forPublicKey == AppViewModel.shared.user.publicKey {
            profilePicUrl = AppViewModel.shared.user.profilePicUrl
        } else if let friend = AppViewModel.shared.user.friendsMap[forPublicKey] {
            profilePicUrl = friend.profilePicUrl
        } else if let otherReq = AppViewModel.shared.user.otherRequestedFriendsMap[forPublicKey] {
            profilePicUrl = otherReq.profilePicUrl
        }
        
        return profilePicUrl
    }
    
    @ViewBuilder
    func fromPersonView() -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text("From: \(name(forPublicKey: transaction.fromPublicKey))")
                    .fontWeight(.bold)
                Text("\tPublic Key:")
                Text("\t\t@" + transaction.fromPublicKey.prefix(22))
                    .font(.system(.footnote , design: .monospaced))
                Text("\t\t " + transaction.fromPublicKey.suffix(22))
                    .font(.system(.footnote , design: .monospaced))
            }
            Spacer()
            ProfilePicView(publicKey: transaction.fromPublicKey,
                           size: 55)
        }
        .padding(.horizontal)
        Divider()
    }
    
    @ViewBuilder
    func toPersonView() -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text("To: \(name(forPublicKey: transaction.toPublicKey))")
                    .fontWeight(.bold)
                Text("\tPublic Key:")
                Text("\t\t@" + transaction.toPublicKey.prefix(22))
                    .font(.system(.footnote , design: .monospaced))
                Text("\t\t " + transaction.toPublicKey.suffix(22))
                    .font(.system(.footnote , design: .monospaced))
            }
            Spacer()
            ProfilePicView(publicKey: transaction.toPublicKey, size: 55)
        }
        .padding(.horizontal)
        Divider()
    }
    
    @ViewBuilder
    func amountView() -> some View {
        HStack {
            Text("Amount:")
                .fontWeight(.bold)
            Spacer()
            Text("A \(transaction.amount.formattedAmount())")
        }
        .padding(.horizontal)
        Divider()
    }
    
    @ViewBuilder
    func signatureView() -> some View {
        if transaction.signature != "" {
            HStack {
                Text("Signature:")
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.horizontal)
            Text(transaction.signature.prefix(44))
                .font(.system(.footnote , design: .monospaced))
            Text(transaction.signature.suffix(44))
                .font(.system(.footnote , design: .monospaced))
            Divider()
        }
    }
    
    @ViewBuilder
    func commentsView() -> some View {
        HStack {
            Text("Comments:")
                .fontWeight(.bold)
            Spacer()
        }
            .padding(.horizontal)
        
        HStack {
            Text("\(transaction.note)")
                .multilineTextAlignment(.leading)
                .padding(3)
            Spacer()
        }
            .padding(.horizontal)
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            idView()
            
            dateStampView()
            
            fromPersonView()
                .foregroundColor(.primary)
                .onTapGesture {
                    selectedWalletUser = Friend(publicKey: transaction.fromPublicKey,
                                                name: name(forPublicKey: transaction.fromPublicKey),
                                                profilePicUrl: profilePicUrl(forPublicKey: transaction.fromPublicKey))
                }
            
            toPersonView()
                .foregroundColor(.primary)
                .onTapGesture {
                    selectedWalletUser = Friend(publicKey: transaction.toPublicKey,
                                                name: name(forPublicKey: transaction.toPublicKey),
                                                profilePicUrl: profilePicUrl(forPublicKey: transaction.toPublicKey))
                }
            
            amountView()
            
            signatureView()
            
            commentsView()
            
            Spacer()
        }
        .navigationTitle("Transaction Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedWalletUser) { walletUser in
            NavigationView {
                WalletView(publicKey: walletUser.publicKey, name: walletUser.name, profilePicUrl: walletUser.profilePicUrl)
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarLeading) {
                            Button("Done") {
                                selectedWalletUser = nil
                            }
                        }
                    }
            }
        }
    }
        
}

//struct FullTransactionView_Previews: PreviewProvider {
//    static var previews: some View {
//        FullTransactionView(transaction: exampleTransaction)
//    }
//}
//var id: String
//
//var fromPublicKey: String
//var toPublicKey: String
//
//var timeStamp: String
//var amount: Int
//
//var note: String
//var signature: String
