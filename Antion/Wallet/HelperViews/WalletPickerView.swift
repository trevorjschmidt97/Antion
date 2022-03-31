//
//  WalletPickerView.swift
//  Antion
//
//  Created by Trevor Schmidt on 2/28/22.
//

import SwiftUI

struct WalletPickerView: View {
    
    var walletState: WalletState
    @Binding var pageSelection: WalletView.PageSelection {
        willSet {
            print("Hello")
        }
    }
    @Binding var movingForward: Bool
    var numFriends: Int
    var friendsString: String { "\(numFriends) Friend\(numFriends != 1 ? "s" : "")" }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Picker("Selection", selection: $pageSelection) {
                    Text("Transactions").tag(WalletView.PageSelection.transactions)
                    Text("Blocks").tag(WalletView.PageSelection.blocks)
                    Text(friendsString).tag(WalletView.PageSelection.friends)
                }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    .animation(.none, value: friendsString)
                
                // Badges
                if walletState == .own {
                    // RequestedTransactions
                    if AppViewModel.shared.user.numRequestedTransactions > 0 {
                        ZStack {
                            Capsule()
                                .foregroundColor(.red)
                                .font(.caption)
                                .frame(width: 18, height: 18)
                            
                            Text("\(AppViewModel.shared.user.numRequestedTransactions)")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        .offset(x: -geo.size.width/6, y: -geo.size.height)
                    }
                    
                    // RequestedFriends
                    if AppViewModel.shared.user.numRequestedFriends > 0 {
                        ZStack {
                            Circle()
                                .foregroundColor(.red)
                                .font(.caption)
                                .frame(width: 18, height: 18)
                            
                            Text("\(AppViewModel.shared.user.numRequestedFriends)")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        .offset(x: 5*geo.size.width/11, y: -geo.size.height)
                    }
                }
            }
        }
        
    }
}

struct WalletPickerView_Previews: PreviewProvider {
    
    static var previews: some View {
        WalletPickerView_PreviewsView()
    }
}

struct WalletPickerView_PreviewsView : View {
    
    @State private var pageSelection: WalletView.PageSelection = .friends
    @State private var movingForward = true

     var body: some View {
         WalletPickerView(walletState: .own, pageSelection: $pageSelection, movingForward: $movingForward, numFriends: 2)
     }
}
