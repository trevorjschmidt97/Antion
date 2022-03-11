//
//  ProfileView.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/22/21.
//

import SwiftUI

struct WalletView: View {
    
    init(publicKey: String, name: String, profilePicUrl: String) {
        self.viewModel = WalletViewModel(user: exampleUser)
        
//        if publicKey == AppViewModel.shared.publicKey {
//            walletState = .own
//        } else if AppViewModel.shared.userInfo.friendPublicKeys.contains(publicKey) {
//            walletState = .friends
//        } else if AppViewModel.shared.userInfo.selfRequestedFriendPublicKeys.contains(publicKey) {
//            walletState = .requested
//        } else {
//            walletState = .stranger
//        }
        
        walletState = .own
    }
    
    @ObservedObject var viewModel: WalletViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    
    @State private var walletState: WalletState
    
    enum PageSelection: Int {
        case transactions = 0
        case blocks = 1
        case friends = 2
    }
    @State private var pageSelection: PageSelection = .transactions
    @State private var showingSettingsConfirmationDialog = false
    @State private var showingImagePicker = false
    @State private var showingColorPicker = false
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            WalletHeaderView(publicKey: viewModel.user.publicKey, name: viewModel.user.name, profilePicUrl: viewModel.user.profilePicUrl, settingsButtonSelected: $showingSettingsConfirmationDialog)

            Text("327.01")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, -5)
            Text("current antion balance")
                .fontWeight(.bold)
                .padding(.top, -30)
            
            WalletSendRequestButtonView()
            
            WalletAddFriendView(viewModel: viewModel, walletState: walletState)
            
            WalletPickerView(pageSelection: $pageSelection, numFriends: viewModel.user.numFriends)
            
            ZStack(alignment: .top) {
                switch pageSelection {
                case .transactions:
                    WalletTransactionsView(viewModel: viewModel, walletState: walletState)
                case .blocks:
                    WalletBlocksView(viewModel: viewModel)
                case .friends:
                    WalletFriendsView(viewModel: viewModel, walletState: walletState)
                }
            }
                        
        }
        .onAppear {
            viewModel.onAppear()
        }
        .navigationBarTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .environmentObject(viewModel)
        .confirmationDialog("", isPresented: $showingSettingsConfirmationDialog) {
            ConfirmationDialogView(profileState: walletState,
                                   showingImagePicker: $showingImagePicker,
                                   showingColorPicker: $showingColorPicker)
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: {
            viewModel.updateProfilePicture()
        }, content: {
            ImagePickerView(image: $viewModel.inputImage)
        })
        .confirmationDialog("Change Color", isPresented: $showingColorPicker) {
            ChangeAppColorView(alertIsPresented: $showingSettingsConfirmationDialog)
        }
    }
    
    
    
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WalletView(publicKey: "zRgvFk5fj5kmzZboRtoCcVBWXlktYKsNfepv1wrE9JQ=", name: "Trev", profilePicUrl: "https://firebasestorage.googleapis.com/v0/b/w8trkr-3356b.appspot.com/o/userProfilePics%2FDcapBesjwuhYBbE3q5mG3gll4iy2.jpg?alt=media&token=7f316ec4-4685-4c7f-a63f-98b9461c101a")
        }
    }
}
