//
//  WalletAddFriendView.swift
//  Antion
//
//  Created by Trevor Schmidt on 3/2/22.
//

import SwiftUI

struct WalletAddFriendView: View {
    
    @ObservedObject var viewModel: WalletViewModel
    var walletState: WalletState
    
    var imageName: String {
        switch walletState {
        case .own:
            return ""
        case .friends:
            return "person.crop.circle.badge.checkmark"
        case .requested:
            return "person.crop.circle"
        case .pendingRequest:
            return "person.crop.circle"
        case .stranger:
            return "person.crop.circle.badge.plus"
        }
    }
    
    var buttonText: String {
        switch walletState {
        case .own:
            return ""
        case .friends:
            return "Friends"
        case .requested:
            return "Accept Friend Request?"
        case .pendingRequest:
            return "Request Sent"
        case .stranger:
            return "Add Friend"
        }
    }
    
    var body: some View {
        if walletState != .own {
            Button {
                viewModel.addFriendButtonPressed()
            } label: {
                Image(systemName: imageName)
                    .font(.title)
                Text(buttonText)
            }
                .padding(.top, -10)
        }
    }
}

//struct WalletAddFriendView_Previews: PreviewProvider {
//    static var previews: some View {
//        WalletAddFriendView()
//    }
//}
