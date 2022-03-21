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
                                viewModel.unfriend()
                            }
                        case .selfRequested:
                            Button("Cancel Friend Request?") {
                                viewModel.cancelFriendRequest()
                            }
                        case .otherRequested:
                            Button("Accept Friend Request?") {
                                viewModel.acceptFriendRequest()
                            }
                            Button("Reject Friend Request?") {
                                viewModel.rejectFriendRequest()
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
