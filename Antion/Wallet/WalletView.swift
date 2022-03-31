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
    
    @State private var pageSelection: PageSelection = .transactions
    @State private var movingForward = true
    
    @State private var showingSettingsConfirmationDialog = false
    @State private var showingImagePicker = false
    @State private var showAbout = false
    @State private var showingNameTextField = false
    @State private var nameText = ""
    @State private var showingColorPicker = false
    @State private var showCopied = false
    @State private var createNewTransaction = false
    
    var body: some View {
//        GeometryReader { proxy in
            
            ScrollView(.vertical, showsIndicators: true) {
                WalletHeaderView(viewModel: viewModel, settingsButtonSelected: $showingSettingsConfirmationDialog, showCopied: $showCopied)
                    .confirmationDialog("", isPresented: $showingSettingsConfirmationDialog) {
                        ConfirmationDialogView(profileState: viewModel.walletState,
                                               showingImagePicker: $showingImagePicker,
                                               showingColorPicker: $showingColorPicker,
                                               showingNameTextField: $showingNameTextField,
                                               showAbout: $showAbout, showCopied: $showCopied)
                    }
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

                Text("A " + appViewModel.blockChain.getBalanceOfWallet(address: viewModel.user.publicKey).formattedAmount())
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, -2)
                Text("current antion balance")
                    .fontWeight(.bold)
                    .padding(.top, -28)
                
                if viewModel.walletState != .own {
                    WalletSendRequestButtonView(createNewTransaction: $createNewTransaction)
                }
                
    //            WalletAddFriendView(viewModel: viewModel)
                
                WalletPickerView(walletState: viewModel.walletState, pageSelection: $pageSelection, movingForward: $movingForward, numFriends: viewModel.user.friends.count)
                    .padding(.bottom)
            
                ZStack(alignment: .top) {
                    Group {
                        switch pageSelection {
                        case .transactions:
                            WalletTransactionsView(viewModel: viewModel)
                        case .blocks:
                            WalletBlocksView(viewModel: viewModel)
                        case .friends:
                            WalletFriendsView(viewModel: viewModel)
                        }
                    }
//                    .animation(.default, value: pageSelection)
//                    .transition(.asymmetric(insertion: .move(edge: movingForward ? .trailing : .leading),
//                                            removal: .move(edge: movingForward ? .leading : .trailing)))
                    
                }
                    .addSwipeGesture {
                        // left to right
                        movingForward = false
                        if pageSelection.canPrevious() {
                            withAnimation {
                                pageSelection.goPrevious()
                            }
                        }
                    } rightToLeft: {
                        // right to left
                        movingForward = true
                        if pageSelection.canNext() {
                            withAnimation {
                                pageSelection.goNext()
                            }
                        }
                    }

            }
                        
        
        .navigationBarTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .environmentObject(viewModel)
        .sheet(isPresented: $showAbout) {
            NavigationView {
                ScrollView(.vertical, showsIndicators: false) {
                    Text("Antion was created for the BYU App Competition sponsored by BYU's Rollins Center for Entrepreneurship and Technology.\n\nWe are grateful for the center's encouragement and support.\n\nThank you.")
                        .multilineTextAlignment(.center)
                        .padding()
                }
                    .navigationTitle("About Antion")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarLeading) {
                            Button("Done") {
                                showAbout = false
                            }
                        }
                    }
            }
        }
        .sheet(isPresented: $createNewTransaction, onDismiss: nil) {
            if viewModel.walletState == .own {
                NavigationView {
                    FindRecepientView()
                }
            } else {
                let showPrivate = viewModel.walletState == .own || viewModel.walletState == .friends || viewModel.walletState == .otherRequested
                NavigationView {
                    CreateTransactionView(otherUser: Friend(publicKey: viewModel.user.publicKey, name: showPrivate ? viewModel.user.name : "Anonymous", profilePicUrl: showPrivate ? viewModel.user.profilePicUrl : ""), timeStamp: Date().toLongString())
                }
            }
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: {
            viewModel.updateProfilePicture()
        }, content: {
            ImagePickerView(image: $viewModel.inputImage)
        })
        .textFieldAlert(isPresented: $showingNameTextField, title: "Change Name", text: nameText, placeholder: "...", action: { newName in
            guard let newName = newName else {
                print("error unwrapping text optional from textFieldAlert")
                return
            }
            print(newName)
            viewModel.updateName(newName: newName)
        })
    }
    
    
    
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WalletView(publicKey: "SjRQh38G/50ur/Pwjsw4I7YzYE4HzU7E1dyHMxIcvYk=", name: "Anakin", profilePicUrl: "")
                .environmentObject(AppViewModel.shared)
        }
    }
}

extension WalletView {
    enum PageSelection: Int, CaseIterable {
        case transactions
        case blocks
        case friends
        
        static var movingForward: Bool = true
        static var previous: PageSelection = .transactions
        
        static func first() -> PageSelection {
            PageSelection.allCases[0]
        }
        
        static func last() -> PageSelection {
            PageSelection.allCases[PageSelection.allCases.count - 1]
        }
        
        func canNext() -> Bool {
            self.rawValue != PageSelection.allCases.count - 1
        }
        
        func canPrevious() -> Bool {
            self.rawValue != 0
        }
        
        func previous() -> PageSelection {
            return PageSelection(rawValue: self.rawValue - 1) ?? PageSelection.first()
        }
        mutating func goPrevious() {
            self = previous()
        }
        
        func next() -> PageSelection {
            return PageSelection(rawValue: self.rawValue + 1) ?? PageSelection.last()
        }
        mutating func goNext() {
            self = next()
        }
    }
}
