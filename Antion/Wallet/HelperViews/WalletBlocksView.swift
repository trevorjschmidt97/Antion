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
    
    var blocks: [Block] {
        AppViewModel.shared.blockChain.minedBlocks(forAddress: viewModel.user.publicKey)
    }
    
    var body: some View {
        VStack {
            Text("""
                 This wallet has mined **\(AppViewModel.shared.blockChain.numMinedBlocks(address: viewModel.user.publicKey))** blocks on the blockchain. It has received **\(AppViewModel.shared.blockChain.numReceivedRewards(address: viewModel.user.publicKey).formattedAmount())** antion as rewards.
                 """)
                .multilineTextAlignment(.center)
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
            
            if isShowingMinedBlocks {
                if blocks.isEmpty {
                    Spacer()
                    Text("No Blocks")
                    Spacer()
                } else {
                    ForEach(blocks) { block in
                        BasicBlockView(block: block)
                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                            .overlay(RoundedRectangle(cornerRadius: 5.0).stroke(.primary, lineWidth: 2))
                            .padding(.horizontal)
                        Divider()
                    }
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
