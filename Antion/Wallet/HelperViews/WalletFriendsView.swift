//
//  WalletFriendsView.swift
//  Antion
//
//  Created by Trevor Schmidt on 2/28/22.
//

import SwiftUI

struct WalletFriendsView: View {
    
    @ObservedObject var viewModel: WalletViewModel
    
    var walletState: WalletState
    @State private var isShowingRequestedFriends = true
    @State private var isShowingFriends = true
    
    var body: some View {
        VStack {
            if walletState == .own {
                HStack {
                    Text("Friend Requests")
                        .font(.title3)
                        .fontWeight(.bold)
                    Spacer()
                    Image(systemName: isShowingRequestedFriends ? "chevron.down" : "chevron.up")
                }
                .font(.headline)
                .padding(.horizontal)
                .onTapGesture {
                    withAnimation {
                        isShowingRequestedFriends.toggle()
                    }
                }
            }
            
            HStack {
                Text("Friends")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
                Image(systemName: isShowingFriends ? "chevron.down" : "chevron.up")
            }
            .font(.headline)
            .padding(.horizontal)
            .onTapGesture {
                withAnimation {
                    isShowingFriends.toggle()
                }
            }
        }
        .padding(.top)
    }
}

//struct WalletFriendsView_Previews: PreviewProvider {
//    static var previews: some View {
//        WalletFriendsView(viewModel: WalletViewModel(publicKey: "", name: "", profilePicUrl: ""))
//    }
//}
