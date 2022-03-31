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
    
    @Binding var showCopied: Bool
    
    var body: some View {
        Group {
            Button("Copy Private Key") {
                AppViewModel.shared.requestBiometricUnlock { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let privateKey):
                            UIPasteboard.general.string = privateKey
                            showCopied.toggle()
                            let generator = UINotificationFeedbackGenerator()
                            generator.notificationOccurred(.success)
                            
//                            AppViewModel.shared.privateKey = privateKey
                        case .failure(let error):
                            if error == .deniedAccess {
                                AppViewModel.shared.showFailure(title: "Biometrics Denied", message: "Go to settings to allow \(AppViewModel.shared.biometricType() == .face ? "face-id" : "touch-id")", displayMode: .hud)
                            }
                            print(error.localizedDescription)
                        }
                    }
                }
            }
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


