//
//  SearchView.swift
//  Antion
//
//  Created by Trevor Schmidt on 2/26/22.
//

import SwiftUI

struct SearchView: View {
    
    @StateObject var viewModel = SearchViewModel()
    
    @State private var selectedUser: SearchUser?
    
    @State private var searchText = ""
    
    enum SearchType: String {
        case name = "name"
        case publicKey = "public key"
    }
    @State private var searchTypeSelection: SearchType = .name
    
    var body: some View {
        List {
            ForEach(viewModel.searchUsers) { user in
                Button {
                    selectedUser = user
                } label: {
                    SearchUserView(user: user)
                }
                .onAppear {
                    if let lastUser = viewModel.searchUsers.last, user.publicKey == lastUser.publicKey {
                        print("Last User \(lastUser.publicKey)")
                        viewModel.querySearch(keyword: searchText)
                    }
                }
            }
        }
        .searchable(text: $searchText, prompt: Text("Find by \(searchTypeSelection.rawValue)"))
        .onAppear {
            viewModel.onAppear()
        }
        .navigationBarTitle("Search")
        .toolbar {
            ToolbarItem(placement: .principal) {
                Picker("Search Type", selection: $searchTypeSelection) {
                    Text("Name").tag(SearchType.name)
                    Text("Public Key").tag(SearchType.publicKey)
                }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(maxWidth: 200)
            }
        }
        .sheet(item: $selectedUser, onDismiss: nil) { user in
            NavigationView {
                WalletView(publicKey: user.publicKey, name: user.name, profilePicUrl: user.profilePicUrl)
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarLeading) {
                            Button("Done") {
                                selectedUser = nil
                            }
                        }
                    }
            }
        }
    }
}

//struct SearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchView()
//    }
//}
