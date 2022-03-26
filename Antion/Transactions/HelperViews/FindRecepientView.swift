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
    
    @StateObject var viewModel = TransactionsViewModel()
//    @EnvironmentObject var viewModel: TransactionsViewModel
    
    @State private var searchText = ""
    
    @State private var otherUser: Friend = Friend(publicKey: "", name: "", profilePicUrl: "")
    @State private var showPayRequest = false
    
    var filteredFriends: [Friend] {
        if searchText.isEmpty {
            return AppViewModel.shared.user.friends.sorted{ $0.name > $1.name }
        }
        return AppViewModel.shared.user.friends.sorted{ $0.name > $1.name }.filter { $0.publicKey.contains(searchText) || $0.name.contains(searchText) }
    }
    
    var body: some View {
        VStack {
            
            List {
                Section("Friends") {
                    ForEach(filteredFriends) { friend in
                        OtherUserRecepientView(otherUser: friend, bindingOtherUser: $otherUser, showPayRequest: $showPayRequest)
                    }
                }
                Section("Other Users on Antion") {
                    ForEach(viewModel.searchUsers) { user in
                        if user.publicKey != appViewModel.user.publicKey && !AppViewModel.shared.user.friendsSet.contains(user.publicKey) {
                            OtherUserRecepientView(otherUser: Friend(publicKey: user.publicKey, name: "Anonymous", profilePicUrl: ""), bindingOtherUser: $otherUser, showPayRequest: $showPayRequest)
                                .onAppear {
                                    if let lastUser = viewModel.searchUsers.last, user.publicKey == lastUser.publicKey {
                                        viewModel.nextPage()
                                    }
                                }
                        }
                    }
                    if viewModel.loadingNextPage {
                        Text("Loading...")
                    }
                }
            }
            
            // Navigation Links
                // To Create View
            NavigationLink(isActive: $showPayRequest) {
                CreateTransactionView(otherUser: otherUser, timeStamp: Date().toLongString(), parent: self)
            } label: {
                EmptyView()
            }
        }
            .searchable(text: $searchText)
            .navigationTitle("Look Up")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .onChange(of: searchText) { newValue in
                viewModel.querySearch(keyword: newValue)
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
