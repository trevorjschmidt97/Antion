//
//  MiningView.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/22/21.
//

import SwiftUI

struct MiningView: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    
    @State private var isShowingMining = true
    @State private var isShowingBlockchain = true
    @State private var isShowingPendingTransactions = true
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            HStack {
                Text("Mining")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
                Image(systemName: isShowingMining ? "chevron.down" : "chevron.up")
            }
            .font(.headline)
            .padding(.horizontal)
            .onTapGesture {
                withAnimation {
                    isShowingMining.toggle()
                }
            }
            
            if isShowingMining {
                Text("You have mined \(appViewModel.blockChain.numMinedBlocks(address: appViewModel.user.publicKey)) block\(appViewModel.blockChain.numMinedBlocks(address: appViewModel.user.publicKey) == 1 ? "" : "s") and have received \(appViewModel.blockChain.numReceivedRewards(address: appViewModel.user.publicKey).formattedAmount()) antion as rewards")
                    .padding(30)
                    .multilineTextAlignment(.center)
                
                if !appViewModel.isMining {
                    Button("Start Mining?") {
                        appViewModel.startMining()
                    }
                    .font(.title)
                    .padding(.bottom)
                } else {
                    BasicBlockView(block: AppViewModel.shared.newBlock)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                        .overlay(RoundedRectangle(cornerRadius: 5.0).stroke(.primary, lineWidth: 2))
                        .padding(.horizontal)
                    
                    Button("Stop Mining?") {
                        appViewModel.isMining = false
                    }
                        .font(.title)
                        .foregroundColor(appViewModel.accentColor)
                        .padding()
                }
            }
            
            HStack {
                Text("Blockchain")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
                Image(systemName: isShowingBlockchain ? "chevron.down" : "chevron.up")
            }
            .font(.headline)
            .padding()
            .onTapGesture {
                withAnimation {
                    isShowingBlockchain.toggle()
                }
            }
            
            if isShowingBlockchain {
            
                ScrollView(.horizontal, showsIndicators: false) {
                    ScrollViewReader { reader in
                        HStack {
                            ForEach(appViewModel.blockChain.chain) { block in
                                VStack {
                                    BasicBlockView(block: block)
                                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                        .overlay(RoundedRectangle(cornerRadius: 5.0).stroke(.primary, lineWidth: 2))
                                }
                                if let latestBlock = appViewModel.blockChain.chain.last, block.hash != latestBlock.hash {
                                    Arrow()
                                        .frame(width: 50, height: 30)
                                        .rotationEffect(.degrees(90))
                                }
                            }
                            .onAppear {
                                if let latestBlock = appViewModel.blockChain.latestBlock() {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                        withAnimation {
                                            reader.scrollTo(latestBlock.id, anchor: .bottomTrailing)
                                        }
                                    }
                                }
                            }
                            .onChange(of: appViewModel.blockChain.chain) { newValue in
                                appViewModel.isMining = false // Essential to stop mining when someone else has mined a block
                                if let latestBlock = newValue.last {
                                    withAnimation {
                                        reader.scrollTo(latestBlock.id, anchor: .bottomTrailing)
                                    }
                                }
                            }
                        }
                            .padding()
                    }
                }
                
            }
            
            if !appViewModel.blockChain.pendingTransactions.isEmpty {
                HStack {
                    Text("Pending Transactions")
                        .font(.title3)
                        .fontWeight(.bold)
                    Spacer()
                    Image(systemName: isShowingPendingTransactions ? "chevron.down" : "chevron.up")
                }
                .font(.headline)
                .padding(.horizontal)
                .onTapGesture {
                    withAnimation {
                        isShowingPendingTransactions.toggle()
                    }
                }
                
                if isShowingPendingTransactions {
                    ForEach(appViewModel.blockChain.pendingTransactions.sorted{ $0.timeStamp > $1.timeStamp }) { pendingTransaction in
                        PrettyTransactionView(transaction: pendingTransaction, transactionType: .pending)
                            .padding(.horizontal)
                        Divider()
                    }
                }
            }
            
        }
            .navigationTitle("BlockChain")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct MiningView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MiningView()
        }
        .environmentObject(AppViewModel.shared)
    }
}
