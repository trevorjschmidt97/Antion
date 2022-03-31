//
//  WalletHeaderView.swift
//  Antion
//
//  Created by Trevor Schmidt on 2/28/22.
//

import SwiftUI

struct WalletHeaderView: View {
    
    @ObservedObject var viewModel: WalletViewModel
    
    @Binding var settingsButtonSelected: Bool
    @Binding var showCopied: Bool
    
    @State private var showOptionsConfirmationDialog = false
    
    var appColor = AppViewModel.shared.accentColor
    
    var showPrivate: Bool {
        viewModel.walletState == .own || viewModel.walletState == .friends || viewModel.walletState == .otherRequested
    }
    
    var body: some View {
        HStack {
            ProfilePicView(publicKey: viewModel.user.publicKey, username:showPrivate ? viewModel.user.name : "Anonymous", profilePicUrl:showPrivate ? viewModel.user.profilePicUrl : "", size: 80)
            VStack(alignment: .leading) {
                Text(showPrivate ? viewModel.user.name : "Anonymous")
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text("Public Key:")
                    .font(.system(.caption, design: .monospaced))
                Text("@" + viewModel.user.publicKey.prefix(22))
                    .font(.system(.caption, design: .monospaced))
                Text(" " + viewModel.user.publicKey.suffix(22))
                    .font(.system(.caption, design: .monospaced))
            }
            .padding(.leading, -5)
            
            Spacer()
            
            Button {
                UIPasteboard.general.string = viewModel.user.publicKey
                showCopied.toggle()
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            } label: {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 20))
            }
                .foregroundColor(appColor)
            
            if viewModel.walletState == .own {
                Button {
                    settingsButtonSelected.toggle()
                } label: {
                    Image(systemName: "gearshape")
                        .font(.system(size: 20))
                        
                }
                    .foregroundColor(appColor)
            } else {
                Button {
                    showOptionsConfirmationDialog.toggle()
                } label: {
                    Image(systemName: viewModel.walletState.imageName)
                        .font(.system(size: 20))
                }
                .foregroundColor(appColor)
            }

            
        }
        .padding(.horizontal)
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

//struct WalletHeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        WalletHeaderView(publicKey: "", name: "", profilePicUrl: "")
//    }
//}
