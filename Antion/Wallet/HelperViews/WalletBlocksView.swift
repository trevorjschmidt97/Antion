//
//  WalletBlocksView.swift
//  Antion
//
//  Created by Trevor Schmidt on 2/28/22.
//

import SwiftUI

struct WalletBlocksView: View {
    
    @ObservedObject var viewModel: WalletViewModel
    
    @State private var isShowingMinedBlocks = true
    
    var body: some View {
        VStack {
            Text("""
                 This wallet has mined **\(viewModel.user.name)** blocks on the blockchain. It has received **\(viewModel.user.name)** antion as rewards.
                 """)
                .padding(.vertical)
                .padding(.horizontal, 30)
            
            HStack {
                Text("Mined Blocks")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
                Image(systemName: isShowingMinedBlocks ? "chevron.down" : "chevron.up")
            }
            .font(.headline)
            .padding(.horizontal)
            .onTapGesture {
                withAnimation {
                    isShowingMinedBlocks.toggle()
                }
            }
        }
    }
}

//struct WalletBlocksView_Previews: PreviewProvider {
//    static var previews: some View {
//        WalletBlocksView(viewModel: WalletViewModel(publicKey: "", name: "", profilePicUrl: ""))
//    }
//}
