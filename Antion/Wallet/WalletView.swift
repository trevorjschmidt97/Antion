//
//  ProfileView.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/22/21.
//

import SwiftUI
import AlertToast

struct WalletView: View {
    
    init(publicKey: String, name: String, profilePicUrl: String) {
        var user = User(publicKey: publicKey)
        user.name = name
        user.profilePicUrl = profilePicUrl
        
        self.viewModel = WalletViewModel(user: user)
    }
    
    @EnvironmentObject var appViewModel: AppViewModel
    @ObservedObject var viewModel: WalletViewModel
    
    enum PageSelection: Int {
        case transactions = 0
        case blocks = 1
        case friends = 2
    }
    @State private var pageSelection: PageSelection = .friends
    @State private var showingSettingsConfirmationDialog = false
    @State private var showingImagePicker = false
    @State private var showingColorPicker = false
    @State private var showCopied = false
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            WalletHeaderView(viewModel: viewModel, settingsButtonSelected: $showingSettingsConfirmationDialog, showCopied: $showCopied)

            Text("A " + appViewModel.blockChain.getBalanceOfWallet(address: viewModel.user.publicKey).formattedAmount())
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, -2)
            Text("current antion balance")
                .fontWeight(.bold)
                .padding(.top, -28)
            
            WalletSendRequestButtonView()
            
            WalletAddFriendView(viewModel: viewModel)
            
            WalletPickerView(pageSelection: $pageSelection, numFriends: viewModel.user.friends.count)
        
            ZStack(alignment: .top) {
                switch pageSelection {
                case .transactions:
                    WalletTransactionsView(viewModel: viewModel)
                case .blocks:
                    WalletBlocksView(viewModel: viewModel)
                case .friends:
                    WalletFriendsView(viewModel: viewModel)
                }
            }
                        
        }
        .navigationBarTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .environmentObject(viewModel)
        .confirmationDialog("", isPresented: $showingSettingsConfirmationDialog) {
            ConfirmationDialogView(profileState: viewModel.walletState,
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
        .toast(isPresenting: $showCopied,
            duration: 2,
            tapToDismiss: true,
            offsetY: 0.0,
            alert: {
            AlertToast(displayMode: .banner(.pop),
                                type: .complete(.green),
                                title: "Public Key Copied",
                                subTitle: nil,
                                style: nil)
             },
            onTap: nil,
            completion: nil)
    }
    
    
    
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            WalletView(publicKey: "zRgvFk5fj5kmzZboRtoCcVBWXlktYKsNfepv1wrE9JQ=", name: "Trev", profilePicUrl: "https://firebasestorage.googleapis.com/v0/b/w8trkr-3356b.appspot.com/o/userProfilePics%2FDcapBesjwuhYBbE3q5mG3gll4iy2.jpg?alt=media&token=7f316ec4-4685-4c7f-a63f-98b9461c101a")
//        }
//    }
//}
