//
//  TransactionUserSelectView.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/29/21.
//

import SwiftUI

struct OtherUserRecepientView: View {
    
    var otherUser: Friend
    @Binding var bindingOtherUser: Friend
    
    @Binding var showPayRequest: Bool
    
    @State private var showWallet = false
    
    var body: some View {
        ZStack {
            HStack {
                Group {
                    ProfilePicView(username: otherUser.name, profilePicUrl: otherUser.profilePicUrl, size: 50)
                    VStack(alignment: .leading) {
                        Text(otherUser.name)
                            .fontWeight(.bold)
                        Text("Public Key: ")
                            .font(.system(.footnote, design: .monospaced))
                        Text("@" + otherUser.publicKey.prefix(22))
                            .font(.system(.footnote, design: .monospaced))
                        Text(" " + otherUser.publicKey.suffix(22))
                            .font(.system(.footnote , design: .monospaced))
                    }
                    Spacer()
                }
                .onTapGesture {
                    bindingOtherUser = otherUser
                    showPayRequest.toggle()
                }
            }
            HStack {
                Spacer()
                Image(systemName: "info.circle")
                    .onTapGesture {
                        showWallet = true
                    }
            }
        }
        .sheet(isPresented: $showWallet) {
            NavigationView {
                WalletView(publicKey: otherUser.publicKey, name: otherUser.name, profilePicUrl: otherUser.profilePicUrl)
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarLeading) {
                            Button("Done") {
                                showWallet = false
                            }
                        }
                    }
            }
        }
    }
}
