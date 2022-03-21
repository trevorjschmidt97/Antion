//
//  SearchUserView.swift
//  Antion
//
//  Created by Trevor Schmidt on 3/7/22.
//

import SwiftUI

struct SearchUserView: View {
    
    var user: Friend
    
    @State private var showWallet = false
    
    var body: some View {
        Button {
            showWallet.toggle()
        } label: {
            HStack {
                ProfilePicView(username: user.name, profilePicUrl: user.profilePicUrl, size: 50)
                VStack(alignment: .leading) {
                    Text(user.name)
                        .fontWeight(.bold)
                    Text(" Public Key: ")
                        .font(.system(.footnote, design: .monospaced))
                    Text(" @" + user.publicKey.prefix(22))
                        .font(.system(.footnote, design: .monospaced))
                    Text("  " + user.publicKey.suffix(22))
                        .font(.system(.footnote , design: .monospaced))
                }
                .padding(.leading, -10)
                Spacer()
                Image(systemName: "chevron.forward")
            }
        }
        .foregroundColor(.primary)
        .sheet(isPresented: $showWallet) {
            NavigationView {
                WalletView(publicKey: user.publicKey, name: user.name, profilePicUrl: user.profilePicUrl)
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarLeading) {
                            Button("Done") {
                                showWallet.toggle()
                            }
                        }
                    }
            }
        }
    }
}

//struct SearchUserView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchUserView()
//    }
//}
