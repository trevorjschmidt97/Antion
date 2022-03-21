//
//  TransactionUserSelectView.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/29/21.
//

import SwiftUI

struct OtherUserRecepientView: View {
    
    var otherUser: Friend
//    var name: String
//    var publicKey: String
//    var profilePicUrl: String?
    
//    @Binding var otherName: String
//    @Binding var otherPublicKey: String
//    @Binding var otherProfilePicUrl: String?
    @Binding var bindingOtherUser: Friend
    
    @Binding var showPayRequest: Bool
    @Binding var showProfileView: Bool
    
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
                        bindingOtherUser = otherUser
                        showProfileView.toggle()
                    }
            }
        }
    }
}
