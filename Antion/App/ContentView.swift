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
        if appViewModel.privateKey != nil, !appViewModel.loadingUserInfo, !appViewModel.loadingSearchUserInfo {
            ZStack {
                TabView {
                    
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
                        .badge(appViewModel.user.numTabBadge)
                }
                
                if appViewModel.loadingUserInfo ||
                    appViewModel.loadingSearchUserInfo ||
                    appViewModel.blockChainLoading ||
                    appViewModel.pendingTransactionsLoading {
                    ZStack {
                        Color(.white)
                            .opacity(0.3)
                            .ignoresSafeArea()
                        
                        ProgressView("Loading")
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10)
                                            .fill(Color(.systemBackground))
                            )
                            .shadow(radius: 10)
                    }
                }
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
            .environmentObject(AppViewModel.shared)
    }
}
