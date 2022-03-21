//
//  ContentView.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/18/21.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    
    @State private var showExampleWallet = true
    
    var body: some View {
        if appViewModel.privateKey != nil {
            ZStack {
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
                
                if appViewModel.loadingUserInfo || appViewModel.loadingSearchUserInfo {
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
                .onAppear {
                    appViewModel.pullUserInfo()
                }
//                .sheet(isPresented: $showExampleWallet) {
//                    NavigationView {
//                        WalletView(publicKey: "06Gloj0KJ2K24NiSxuqToPCjQckLdAf1O1q3Y6HIpvk=", name: "Anonymous", profilePicUrl: "")
//                    }
//                }
                
            
        } else {
            NavigationView {
                    SignUpView()
            }
                .environmentObject(AuthViewModel())
//                .onAppear {
//                    
//                    showExampleWallet = true
//                    appViewModel.privateKey = "bNR+kZFojI4RjJSHr0zMJOSz56hDQSN1XmTI4R2zhvc="
//                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppViewModel.shared)
    }
}
