//
//  UserAcquaintancesView.swift
//  Antion
//
//  Created by Trevor Schmidt on 1/25/22.
//

import SwiftUI

struct UserAcquaintancesView: View {
    
    @EnvironmentObject var viewModel: WalletViewModel
    
    var body: some View {
        EmptyView()
//        ForEach(viewModel.acquaintances) { acquaintance in
//            let otherUser = Friend(publicKey: acquaintance.publicKey, name: acquaintance.name, profilePicUrl: acquaintance.profilePicUrl)
//            OtherUserSearchView(user: otherUser)
//        }
//        if viewModel.acquaintances.count == 0 {
//            Text("Find some more friends!")
//        }
    }
}

struct UserAcquaintancesView_Previews: PreviewProvider {
    static var previews: some View {
        UserAcquaintancesView()
    }
}
