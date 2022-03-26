//
//  WalletAddFriendView.swift
//  Antion
//
//  Created by Trevor Schmidt on 3/2/22.
//

import SwiftUI

struct WalletAddFriendView: View {
    
    @ObservedObject var viewModel: WalletViewModel
        
    @State private var showOptionsConfirmationDialog = false

    var body: some View {
        if viewModel.walletState != .own {
            Button {
                showOptionsConfirmationDialog.toggle()
            } label: {
                Image(systemName: viewModel.walletState.imageName)
                    .font(.headline)
                Text(viewModel.walletState.buttonText)
                    .font(.headline)
            }
                .padding(.top, 5)
                .padding(.bottom, 5)
                .foregroundColor(AppViewModel.shared.accentColor)
                .confirmationDialog("", isPresented: $showOptionsConfirmationDialog) {
                    Group {
                        switch viewModel.walletState {
                        case .own:
                            EmptyView()
                        case .friends:
                            Button("Unfriend \(viewModel.user.name)") {
                                let selfFriend = Friend(publicKey: AppViewModel.shared.user.publicKey, name: AppViewModel.shared.user.name, profilePicUrl: AppViewModel.shared.user.profilePicUrl)
                                let otherFriend = Friend(publicKey: viewModel.user.publicKey, name: viewModel.user.name, profilePicUrl: viewModel.user.profilePicUrl)
                                viewModel.unfriend(selfFriend: selfFriend, otherFriend: otherFriend)
                            }
                        case .selfRequested:
                            Button("Cancel Friend Request?") {
                                let selfFriend = Friend(publicKey: AppViewModel.shared.user.publicKey, name: AppViewModel.shared.user.name, profilePicUrl: AppViewModel.shared.user.profilePicUrl)
                                let otherFriend = Friend(publicKey: viewModel.user.publicKey, name: viewModel.user.name, profilePicUrl: viewModel.user.profilePicUrl)
                                viewModel.cancelFriendRequest(selfFriend: selfFriend, otherFriend: otherFriend)
                            }
                        case .otherRequested:
                            Button("Accept Friend Request?") {
                                let selfFriend = Friend(publicKey: AppViewModel.shared.user.publicKey, name: AppViewModel.shared.user.name, profilePicUrl: AppViewModel.shared.user.profilePicUrl)
                                let otherFriend = Friend(publicKey: viewModel.user.publicKey, name: viewModel.user.name, profilePicUrl: viewModel.user.profilePicUrl)
                                viewModel.acceptFriendRequest(selfFriend: selfFriend, otherFriend: otherFriend)
                            }
                            Button("Reject Friend Request?") {
                                let selfFriend = Friend(publicKey: AppViewModel.shared.user.publicKey, name: AppViewModel.shared.user.name, profilePicUrl: AppViewModel.shared.user.profilePicUrl)
                                let otherFriend = Friend(publicKey: viewModel.user.publicKey, name: viewModel.user.name, profilePicUrl: viewModel.user.profilePicUrl)
                                viewModel.rejectFriendRequest(selfFriend: selfFriend, otherFriend: otherFriend)
                            }
                        case .stranger:
                            Button("Send Friend Request?") {
                                viewModel.sendFriendRequest()
                            }
                        }
                        
                        Button("Cancel", role: .cancel) {}
                    }
                        .accentColor(AppViewModel.shared.accentColor)
                        .tint(AppViewModel.shared.accentColor)
                }
        }
    }
        
}

//struct WalletAddFriendView_Previews: PreviewProvider {
//    static var previews: some View {
//        WalletAddFriendView()
//    }
//}
