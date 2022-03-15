//
//  BasicBlockView.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/23/21.
//

import SwiftUI

struct BasicBlockView: View {
    
    var block: Block
    
    var body: some View {
        EmptyView()
//        VStack(alignment: .leading) {
//            Text("Block:   \(block.id)")
//                .padding(.bottom, 3)
//
//            HStack {
//                Text("TimeStamp:")
//                Spacer()
//                Text("\(block.timeStamp)")
//            }
//            Divider()
//
//            HStack {
//                Text("Previous Hash:")
//                Spacer()
//                VStack {
//                    Text("\(String(block.previousHash.prefix(22)))")
//                    Text("\(String(block.previousHash.suffix(22)))")
//                }
//            }
//            Divider()
//
//            HStack {
//                Text("Number of Transactions:")
//                Spacer()
//                Text("\(block.numTransactions)")
//            }
//            Divider()
//
//            HStack {
//                Text("Nonce:")
//                Spacer()
//                Text("\(block.nonce)")
//            }
//            Divider()
//
//            HStack {
//                Text("Hash:")
//                Spacer()
//                VStack {
//                    Text("\(String(block.hash.prefix(22)))")
//                    Text("\(String(block.hash.suffix(22)))")
//                }
//            }
//        }
//            .padding()
//            .font(.system(.caption, design: .monospaced))
    }
}

//struct BasicBlockView_Previews: PreviewProvider {
//    static var previews: some View {
//        BasicBlockView(block: exampleBlock)
//    }
//}
