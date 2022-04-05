//
//  BlockView.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/23/21.
//

import SwiftUI

struct FullBlockView: View {
    
    var block: Block
    @State private var miner: Friend?
    @State private var previousBlock: Block?
    
    @State private var showFullTime = true
    
    @ViewBuilder
    func timeStamp() -> some View {
        HStack {
            Text("TimeStamp:")
            Spacer()
            Text("\(showFullTime ? block.timeStamp : block.timeStamp.longStringToDate().timeAgoDisplay())")
                .font(.system(.caption, design: .monospaced))
                .onTapGesture {
                    showFullTime.toggle()
                }
        }
        .padding(.top)
        .padding(.horizontal)
        Divider()
    }
    
    @ViewBuilder
    func previousHash() -> some View {
        HStack {
            Text("Previous Hash:")
            Spacer()
            VStack {
                Text("\(String(block.previousHash.prefix(22)))")
                Text("\(String(block.previousHash.suffix(22)))")
            }
            .font(.system(.caption, design: .monospaced))
        }
        .padding(.horizontal)
            .foregroundColor(.primary)
            .onTapGesture {
                previousBlock = AppViewModel.shared.blockChain.block(forHash: block.previousHash)
            }
        Divider()
    }
    
    @ViewBuilder
    func minerView() -> some View {
        HStack {
            Text("Miner Public Key:")
            Spacer()
            VStack {
                Text("@\(String(block.minerPublicKey.prefix(22)))")
                Text(" \(String(block.minerPublicKey.suffix(22)))")
            }
            .font(.system(.caption, design: .monospaced))
        }
            .padding(.horizontal)
            .foregroundColor(.primary)
            .onTapGesture {
                miner = Friend(publicKey: block.minerPublicKey, name: "Anonymous", profilePicUrl: "")
            }
        Divider()
    }
    
    @ViewBuilder
    func numberOfTransactions() -> some View {
        HStack {
            Text("Number of Transactions:")
            Spacer()
            Text("\(block.transactions.count)")
                .font(.system(.caption, design: .monospaced))
        }
            .padding(.horizontal)
        Divider()
    }
    
    @ViewBuilder
    func nonce() -> some View {
        HStack {
            Text("Nonce:")
            Spacer()
            Text("\(block.nonce)")
                .font(.system(.caption, design: .monospaced))
        }
            .padding(.horizontal)
        Divider()
    }
    
    @ViewBuilder
    func hash() -> some View {
        HStack {
            Text("Hash:")
            Spacer()
            VStack {
                Text("\(String(block.hash.prefix(22)))")
                Text("\(String(block.hash.suffix(22)))")
            }
            .font(.system(.caption, design: .monospaced))
        }
            .padding(.horizontal)
        Divider()
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            
            timeStamp()

            previousHash()
            
            minerView()

            numberOfTransactions()

            nonce()

            hash()
            
            HStack {
                Text("Transactions:")
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.horizontal)
            
            ForEach(block.transactions.sorted{ $0.timeStamp > $1.timeStamp }) { transaction in
                PrettyTransactionView(transaction: transaction, transactionType: .confirmed)
                    .padding(.horizontal)
                Divider()
            }
        }
            .navigationTitle("Block: \(block.index)")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $previousBlock) { selectedBlock in
                NavigationView {
                    FullBlockView(block: selectedBlock)
                        .toolbar {
                            ToolbarItemGroup(placement: .navigationBarLeading) {
                                Button("Done") {
                                    previousBlock = nil
                                }
                            }
                        }
                }
            }
            .sheet(item: $miner) { minerFriend in
                NavigationView {
                    WalletView(publicKey: minerFriend.publicKey, name: minerFriend.name, profilePicUrl: minerFriend.profilePicUrl)
                        .toolbar {
                            ToolbarItemGroup(placement: .navigationBarLeading) {
                                Button("Done") {
                                    miner = nil
                                }
                            }
                        }
                }
            }
    }
}
