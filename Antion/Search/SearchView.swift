//
//  SearchView.swift
//  Antion
//
//  Created by Trevor Schmidt on 2/26/22.
//

import SwiftUI

struct SearchView: View {
    
    @StateObject var viewModel = SearchViewModel()
    
    @State private var searchText = ""
    
    var filteredFriends: [Friend] {
        if searchText.isEmpty {
            return AppViewModel.shared.user.friends.sorted{ $0.name > $1.name }
        }
        return AppViewModel.shared.user.friends.sorted{ $0.name > $1.name }.filter { $0.publicKey.contains(searchText) || $0.name.contains(searchText) }
    }
    
    var body: some View {
        List {
            Section("Friends") {
                ForEach(filteredFriends) { friend in
                    SearchUserView(user: friend)
                }
            }
            .padding(.top, -40)
            
            Section("All Users On Antion") {
                ForEach(viewModel.searchUsers) { user in
                    SearchUserView(user: Friend(publicKey: user.publicKey, name: "Anonymous", profilePicUrl: ""))
                        .onAppear {
                            if let lastUser = viewModel.searchUsers.last, user.publicKey == lastUser.publicKey {
                                viewModel.nextPage()
                            }
                        }
                        .transition(.move(edge: .bottom))
                }
                if viewModel.loadingNextPage {
                    Text("Loading...")
                }
            }
        }
        .searchable(text: $searchText, prompt: Text("Find others by name or public key"))
        .navigationBarTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: searchText) { newValue in
            viewModel.querySearch(keyword: newValue)
        }
    }
}

//struct SearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchView()
//    }
//}
