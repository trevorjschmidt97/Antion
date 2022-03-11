//
//  TransactionView.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/23/21.
//

import SwiftUI

struct RawTransactionView: View {
    
    var transaction: ConfirmedTransaction
    
    var body: some View {
        VStack(alignment: .leading) {
            if let fromAddress = transaction.fromPublicKey {
                HStack {
                    Text("Sender Public Key:")
                    Spacer()
                    VStack {
                        Text("\t" + fromAddress.prefix(22))
                        Text("\t" + fromAddress.suffix(22))
                    }
                }
                .padding(.bottom, 2)
            }
            
            HStack {
                Text("Recepient Public Key:")
                Spacer()
                VStack {
                    Text("\t" + transaction.toPublicKey.prefix(22))
                    Text("\t" + transaction.toPublicKey.suffix(22))
                }
            }
            .padding(.bottom, 2)
            HStack {
                Text("TimeStamp: \(transaction.timeStamp)")
                Spacer()
                Text("A \(transaction.amount.formatted())")
            }
            .padding(.bottom, 2)
            Text("Comments: \(transaction.note)")
                .padding(.bottom, 2)
            if let signature = transaction.signature {
                Text("Signature: \(transaction.isValidSignature() ? "Valid" : "Invalid")")
                VStack(alignment: .leading) {
                    Text("\t" + signature.prefix(44))
                    Text("\t" + signature.suffix(44))
                }
            }
        }
        .font(.system(.caption, design: .monospaced))

    }
}

//struct TransactionView_Previews: PreviewProvider {
//    static var previews: some View {
//        RawTransactionView(transaction: exampleTransaction)
//    }
//}
