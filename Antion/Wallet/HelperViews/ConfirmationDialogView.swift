//
//  ConfirmationDialogView.swift
//  ConfirmationDialogView
//
//  Created by Trevor Schmidt on 8/26/21.
//

import SwiftUI

struct ConfirmationDialogView: View {
//    @EnvironmentObject var blockChain: BlockChain
    var profileState: WalletState
    @Binding var showingImagePicker: Bool
    @Binding var showingColorPicker: Bool
    
    var body: some View {
        Group {
            switch profileState {
            case .own:
                Button("Change App Color") {
                    showingColorPicker = true
                }
                Button("Update Profile Picture") {
                    showingImagePicker = true
                }
                Button("Sign Out") {
                    AppViewModel.shared.privateKey = nil
                }
            case .friends:
                EmptyView()
            case .requested:
                EmptyView()
            case .pendingRequest:
                EmptyView()
            case .stranger:
                EmptyView()
            }
            Button("Cancel", role: .cancel) {}
        }
            .accentColor(AppViewModel.shared.accentColor)
            .tint(AppViewModel.shared.accentColor)
    }
}


