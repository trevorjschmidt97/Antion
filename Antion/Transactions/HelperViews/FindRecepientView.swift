//
//  RecepientTransactionView.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/28/21.
//

import SwiftUI

struct FindRecepientView: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var viewModel: TransactionsViewModel
    
    @State private var otherUser: Friend = Friend(publicKey: "", name: "", profilePicUrl: "")
    
    @State private var searchText = ""
    
    @State private var showProfileView = false
    @State private var showPayRequest = false
    
    enum SearchType {
        case name
        case publicKey
    }
    @State private var searchTypeSelection: SearchType = .name
    
    var body: some View {
        VStack {
            
            List {
                Section("Top People") {
                    ForEach(viewModel.topPeopleUsers.filter { $0.publicKey != appViewModel.publicKey}) { user in
                        OtherUserRecepientView(otherUser: user,
                                               bindingOtherUser: $otherUser,
                                               showPayRequest: $showPayRequest,
                                               showProfileView: $showProfileView)
                    }
                    
                }
                Section("Friends") {
                   
                }
                Section("Other Users on Antion") {
                    
                }
            }
            
            // Navigation Links
                // To Create View
            NavigationLink(isActive: $showPayRequest) {
                CreateTransactionView(parent: self, otherUser: otherUser)
            } label: {
                EmptyView()
            }
                // to Profile View
            NavigationLink(isActive: $showProfileView) {
                WalletView(publicKey: otherUser.publicKey, name: otherUser.name, profilePicUrl: otherUser.profilePicUrl)
            } label: {
                EmptyView()
            }
        }
        .searchable(text: $searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: searchTypeSelection == .name ? "Search by name" : "Search by public key")
            .navigationTitle("Look Up")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    ZStack {
                        Picker("Search Type", selection: $searchTypeSelection) {
                            Text("Name").tag(SearchType.name)
                            Text("Public Key").tag(SearchType.publicKey)
                        }
                            .pickerStyle(SegmentedPickerStyle())
                            .frame(maxWidth: 200)
                        
                        HStack {
                            Button("Cancel") {
                                presentationMode.wrappedValue.dismiss()
                            }
                            Spacer()
                        }
                    }
                }
            }
            .onAppear {
                viewModel.fetchRecepientsForTransaction()
            }
    }
}

//struct RecepientTransactionView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            FindRecepientView()
//        }
////        .environmentObject(BlockChain())
//    }
//}
