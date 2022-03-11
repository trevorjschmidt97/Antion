//
//  ContentView.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/18/21.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        if appViewModel.privateKey != nil {
            Group {
                if appViewModel.loadingUserInfo {
                    Text("Loading")
                } else {
                    TabView {
                        NavigationView {
                            WalletView(publicKey: appViewModel.publicKey,
                                       name: appViewModel.name,
                                       profilePicUrl: appViewModel.profilePicUrl)
                        }
                            .tabItem {
                                VStack {
                                    Text("Wallet")
                                    Image(systemName: "wallet.pass")
                                }
                            }
                        
                        NavigationView {
                            TransactionsView()
                        }
                            .tabItem {
                                VStack {
                                    Text("Transactions")
                                    Image(systemName: "list.bullet")
                                }
                            }
                        
                        NavigationView {
                            MiningView()
                        }
                            .tabItem {
                                VStack {
                                    Text("Blockchain")
                                    Image(systemName: "link")
                                }
                            }
                        
                        NavigationView {
                            SearchView()
                        }
                            .tabItem {
                                VStack {
                                    Text("Search")
                                    Image(systemName: "magnifyingglass")
                                }
                            }
                    }
                }
            }
                .onAppear {
                    appViewModel.pullUserInfo()
                }
        } else {
            NavigationView {
                    SignUpView()
            }
                .environmentObject(AuthViewModel())
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
