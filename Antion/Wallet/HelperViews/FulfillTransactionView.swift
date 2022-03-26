//
//  PayRequestTransactionView.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/28/21.
//

import SwiftUI
import Combine
import AlertToast

struct FulfillTransactionView: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var incomingTransaction: Transaction
    
    var timeStamp: String
    var parent: FindRecepientView?

    var validAmount: Bool {
        if incomingTransaction.amount <= 0  {
            return false
        }
        if incomingTransaction.amount > appViewModel.blockChain.getBalanceOfWallet(address: appViewModel.user.publicKey) {
            return false
        }
        return true
    }
    
    @State private var signature = ""
    
    var isValidSignature: Bool {
        !signature.isEmpty
    }
    
    @State private var notEnoughBalanceError = false
    
    @State private var transaction: Transaction?
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                // DateStamp
                dateStampView()
                
                // First Person
                firstPersonView()
                
                // Second Person
                secondPersonView()
                
                // Amount
                amountView()
                
                // Note
                noteView()
            }
                VStack {
                    Spacer()
                    
                    // Signature
                    signatureView()
                    
                    // Sign / Submit Button
                    Button {
                        if !validAmount {
                            notEnoughBalanceError.toggle()
                        } else if signature == "" {
                            // Create the transaction
                            guard let privateKey = appViewModel.privateKey else { return }
                            let createTransaction = Transaction(fromPublicKey: appViewModel.user.publicKey, fromPrivateKey: privateKey, toPublicKey: incomingTransaction.toPublicKey, amount: incomingTransaction.amount, note: incomingTransaction.note, timeStamp: Date().toLongString())
                            signature = createTransaction.signature
                            transaction = createTransaction
                        } else {
                            guard let transaction = transaction else {
                                return
                            }
                            
                            appViewModel.fulfillTransaction(requestedTransaction: incomingTransaction, signedTransaction: transaction)
                            
                            presentationMode.wrappedValue.dismiss()
                        }
                    } label: {
                        HStack {
                            Spacer()
                            Text(signature == "" ? "SIGN" : "SUBMIT")
                                .fontWeight(.bold)
                                .padding()
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(0)
                        .background(AppViewModel.shared.accentColor)
                    }
                }
        }
            .toast(isPresenting: $notEnoughBalanceError,
                   duration: 2.0,
                    tapToDismiss: true,
                    offsetY: 0.0,
                    alert: { AlertToast(displayMode: .alert,
                                        type: .error(.red),
                                        title: "Oops",
                                        subTitle: "Not enough balance for transaction, you have \(appViewModel.blockChain.getBalanceOfWallet(address: appViewModel.publicKey).formattedAmount()) antion",
                                        style: nil)
                     },
                    onTap: nil,
                    completion: nil)
            .navigationTitle("Pay")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            
    }
    
    @ViewBuilder
    func dateStampView() -> some View {
        HStack {
            Text("**DateStamp:**")
            Spacer()
            Text("\(timeStamp)")
        }
            .padding(.top)
            .padding(.horizontal)
        Divider()
        
    }
    
    @ViewBuilder
    func firstPersonView() -> some View {
        selfView()
            .padding(.horizontal)
        Divider()
    }
    
    @ViewBuilder
    func secondPersonView() -> some View {
        otherView()
            .padding(.horizontal)
        Divider()
    }
    
    @ViewBuilder
    func amountView() -> some View {
        HStack {
            Text("Amount:")
                .fontWeight(.bold)
            Spacer()
            Text("A \(incomingTransaction.amount.formattedAmount())")
                .padding(.trailing, 20)
            
        }
        .padding(.horizontal)
        Divider()
    }
    
    @ViewBuilder
    func noteView() -> some View {
        Group {
            HStack {
                Text("Comments:")
                    .fontWeight(.bold)
                Spacer()
            }
            HStack {
                Text(incomingTransaction.note).padding(.all, 8)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func signatureView() -> some View {
        Divider()
        HStack {
            Text("Signature:")
                .bold()
                .padding(.horizontal)
            Spacer()
        }
        Text(signature.prefix(44))
            .font(.system(.footnote , design: .monospaced))
        Text(signature.suffix(44))
            .font(.system(.footnote , design: .monospaced))
    }
    
    @ViewBuilder
    func signSubmitButtonView() -> some View {
        HStack {
            Spacer()
            Text(signature != "" ? "SEND" : "SIGN")
                .fontWeight(.bold)
                .padding()
                .foregroundColor(.white)
            Spacer()
        }
        .padding(0)
        .background(AppViewModel.shared.accentColor)
    }
    
    
    func selfView() -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text("From: \(appViewModel.user.name)")
                    .fontWeight(.bold)
                Text("\tPublic Key:")
                Text("\t\t@" + appViewModel.publicKey.prefix(22))
                    .font(.system(.footnote , design: .monospaced))
                Text("\t\t " + appViewModel.publicKey.suffix(22))
                    .font(.system(.footnote , design: .monospaced))
            }
            Spacer()
            ProfilePicView(username: appViewModel.user.name,
                           profilePicUrl: appViewModel.user.profilePicUrl,
                           size: 55)
        }
    }
    
    func otherView() -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text("To: Anonymous")
                    .fontWeight(.bold)
                Text("\tPublic Key:")
                Text("\t\t@" + incomingTransaction.toPublicKey.prefix(22))
                    .font(.system(.footnote , design: .monospaced))
                Text("\t\t " + incomingTransaction.toPublicKey.suffix(22))
                    .font(.system(.footnote , design: .monospaced))
            }
            Spacer()
            ProfilePicView(username: "Anonymous",
                           profilePicUrl: "",
                           size: 55)
        }
    }
}

//struct PayRequestTransactionView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            CreateTransactionView(otherUser: Friend(publicKey: "", name: "", profilePicUrl: ""))
//
//        }
//        .environmentObject(AppViewModel.shared)
//    }
//}
