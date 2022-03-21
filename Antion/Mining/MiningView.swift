//
//  MiningView.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/22/21.
//

import SwiftUI

struct MiningView: View {
    
    @StateObject var viewModel = MiningViewModel()
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
                
                Button("Start Mining?") {
                    appViewModel.startMining(minerPublicKey: "zRgvFk5fj5kmzZboRtoCcVBWXlktYKsNfepv1wrE9JQ=")
                }
                .font(.title)
                .padding(.bottom)
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
                            ForEach(viewModel.blockChain) { block in
                                VStack {
                                    BasicBlockView(block: block)
                                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                        .overlay(RoundedRectangle(cornerRadius: 5.0).stroke(.primary, lineWidth: 2))
                                        .onTapGesture {
                                            print("Hello")
                                        }
                                }
                                Arrow()
                                    .frame(width: 50, height: 30)
                                    .rotationEffect(.degrees(90))
                            }
                            Button {
                                viewModel.startMiningButtonTapped()
                            } label: {
                                VStack {
                                    Text("Start Mining")
                                    Text("From This Block")
                                }
                                .font(.system(.caption, design: .monospaced))
                            }
                            .onAppear {
                                if let latestBlock = viewModel.latestBlock {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                        withAnimation {
                                            reader.scrollTo(latestBlock.id, anchor: .bottomTrailing)
                                        }
                                    }
                                }
                            }
                            .onChange(of: viewModel.blockChain) { newValue in
                                if let latestBlock = viewModel.latestBlock {
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
                ForEach(appViewModel.blockChain.pendingTransactions) { pendingTransaction in
                    PrettyTransactionView(transaction: pendingTransaction)
                        .padding(.horizontal)
                    Divider()
                }
            }
            
        }
            .onAppear {
                viewModel.onAppear()
            }
            .navigationTitle("BlockChain")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if viewModel.isMining {
                        Button("Stop Mining") {
                            viewModel.isMining = false
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if viewModel.isMining {
                        ProgressView()
                    }
                }
            }
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
