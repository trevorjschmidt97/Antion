//
//  WalletFriendsView.swift
//  Antion
//
//  Created by Trevor Schmidt on 2/28/22.
//

import SwiftUI

struct WalletFriendsView: View {
    
    @ObservedObject var viewModel: WalletViewModel
    
    @State private var isShowingRequestedFriends = true
    @State private var isShowingFriends = true
    
    var body: some View {
        VStack {
            if viewModel.walletState == .own && !viewModel.user.requestedFriends.isEmpty {
                HStack {
                    Text("Friend Requests")
                        .font(.title3)
                        .fontWeight(.bold)
                    Spacer()
                    Image(systemName: isShowingRequestedFriends ? "chevron.down" : "chevron.up")
                }
                .font(.headline)
                .padding(.horizontal)
                .padding(.bottom)
                .onTapGesture {
                    withAnimation {
                        isShowingRequestedFriends.toggle()
                    }
                }
                
                if isShowingRequestedFriends {
                    ForEach(viewModel.user.requestedFriends) { requestedFriend in
                        RequestedFriendView(viewModel: viewModel, requestedFriend: requestedFriend)
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
            .padding(.bottom)
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
