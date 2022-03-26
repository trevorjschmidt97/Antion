//
//  WalletPickerView.swift
//  Antion
//
//  Created by Trevor Schmidt on 2/28/22.
//

import SwiftUI

struct WalletPickerView: View {
    
    @Binding var pageSelection: WalletView.PageSelection
    
    var numFriends: Int
    var friendsString: String { "\(numFriends) Friend\(numFriends != 1 ? "s" : "")" }
    
    var body: some View {
        Picker("Selection", selection: $pageSelection) {
            Text("Transactions").tag(WalletView.PageSelection.transactions)
            Text("Blocks").tag(WalletView.PageSelection.blocks)
            Text("Friends").tag(WalletView.PageSelection.friends)
        }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .onChange(of: pageSelection) { newValue in
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred(intensity: 1.0)
            }
    }
}

//struct WalletPickerView_Previews: PreviewProvider {
//    static var previews: some View {
//        WalletPickerView(pageSelection: &Page)
//    }
//}
