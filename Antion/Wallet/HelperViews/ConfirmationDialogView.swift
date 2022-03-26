//
//  ConfirmationDialogView.swift
//  ConfirmationDialogView
//
//  Created by Trevor Schmidt on 8/26/21.
//

import SwiftUI

struct ConfirmationDialogView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    var profileState: WalletState
    @Binding var showingImagePicker: Bool
    @Binding var showingColorPicker: Bool
    @Binding var showingNameTextField: Bool
    @Binding var showAbout: Bool
    
    var body: some View {
        Group {
            Button("Change App Color") {
                showingColorPicker = true
            }
            Button("Change Name") {
                showingNameTextField = true
            }
            Button("Update Profile Picture") {
                showingImagePicker = true
            }
            Button("About Antion") {
                showAbout = true
            }
            Button("Sign Out") {
                appViewModel.signOut()
            }
            Button("Cancel", role: .cancel) {}
        }
            .accentColor(appViewModel.accentColor)
            .tint(appViewModel.accentColor)
    }
}


