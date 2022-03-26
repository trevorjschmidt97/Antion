//
//  PayRequestTransactionView.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/28/21.
//

import SwiftUI
import Combine
import AlertToast

struct CreateTransactionView: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    @Environment(\.presentationMode) var presentationMode
    var otherUser: Friend

    @State private var transactionType: TransactionType = .pay
    
    var timeStamp: String
    var parent: FindRecepientView?
    
    @State private var amountInput = ""
    @State private var commentsInput = ""
    @State private var signature = ""
    
    @FocusState private var focus: String?
    
    var intAmountInput: Int {
        Int(amountInput
            .replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: "A", with: "")
            .replacingOccurrences(of: " ", with: "")) ?? 0
    }
    var validAmount: Bool {
        if intAmountInput <= 0  {
            return false
        }
        if intAmountInput > appViewModel.blockChain.getBalanceOfWallet(address: appViewModel.user.publicKey) {
            return false
        }
        return true
    }
    var isValidSignature: Bool {
        if signature.isEmpty { return false }
        guard let transaction = transaction else { return false }
        
        let transactionSignature = transaction.signature
        guard let privateKey = appViewModel.privateKey else { return false }
        
        let newTransaction = Transaction(fromPublicKey: appViewModel.publicKey, fromPrivateKey: privateKey, toPublicKey: otherUser.publicKey, amount: intAmountInput, note: commentsInput, timeStamp: timeStamp)
        
        return CryptoService.isValidSignature(transaction: newTransaction, signature: transactionSignature)
    }
    
    @State private var invalidAmountError = false
    @State private var notEnoughBalanceError = false
    @State private var noCommentsError = false
    
    @State private var transaction: Transaction?
    
    var canSendRequest: Bool {
        intAmountInput > 0 && !commentsInput.isEmpty
    }
    
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
            
            if transactionType == .pay && focus == nil {
                VStack {
                    Spacer()
                    
                    // Signature
                    signatureView()
                    
                    // Sign / Submit Button
                    Button {
                        if intAmountInput <= 0 {
                            invalidAmountError.toggle()
                        } else if !validAmount {
                            notEnoughBalanceError.toggle()
                        } else if commentsInput.isEmpty {
                            noCommentsError.toggle()
                        } else if signature == "" {
                            // Create the transaction
                            guard let privateKey = appViewModel.privateKey else { return }
                            
                            let createTransaction = Transaction(fromPublicKey: appViewModel.user.publicKey, fromPrivateKey: privateKey, toPublicKey: otherUser.publicKey, amount: intAmountInput, note: commentsInput, timeStamp: timeStamp)
                            
                            signature = createTransaction.signature
                            transaction = createTransaction
                            
                        } else if !isValidSignature {
                            // Create a new transaction to check if valid
                            guard let privateKey = appViewModel.privateKey else { return }
                            let createTransaction = Transaction(fromPublicKey: appViewModel.user.publicKey, fromPrivateKey: privateKey, toPublicKey: otherUser.publicKey, amount: intAmountInput, note: commentsInput, timeStamp: timeStamp)
                            signature = createTransaction.signature
                            transaction = createTransaction
                        } else {
                            guard let transaction = transaction else {
                                return
                            }
                            appViewModel.postPendingTransaction(transaction: transaction)
                            presentationMode.wrappedValue.dismiss()
                            if let parent = parent {
                                parent.presentationMode.wrappedValue.dismiss()
                            }
                        }
                    } label: {
                        HStack {
                            Spacer()
                            Text(signature == "" ? "SIGN" : !isValidSignature ? "RE-SIGN" : "SUBMIT")
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
            
        }
            .toast(isPresenting: $invalidAmountError,
                   duration: 2.0,
                    tapToDismiss: true,
                    offsetY: 0.0,
                    alert: { AlertToast(displayMode: .alert,
                                        type: .error(.red),
                                        title: "Oops",
                                        subTitle: "Transaction must have positive amount before signing",
                                        style: nil)
                     },
                    onTap: nil,
                    completion: nil)
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
            .toast(isPresenting: $noCommentsError,
                   duration: 2.0,
                    tapToDismiss: true,
                    offsetY: 0.0,
                    alert: { AlertToast(displayMode: .alert,
                                        type: .error(.red),
                                        title: "Oops",
                                        subTitle: "You must include comments on your transaction",
                                        style: nil)
                     },
                    onTap: nil,
                    completion: nil)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    keyboardToolBarItemView()
                }
                ToolbarItem(placement: .principal) {
                    principleToolBarItemView()
                }
            }
            
    }
    
    @ViewBuilder
    func dateStampView() -> some View {
        if transactionType == .pay {
            HStack {
                Text("**DateStamp:**")
                Spacer()
                Text("\(timeStamp)")
            }
                .padding(.top)
                .padding(.horizontal)
            Divider()
        }
    }
    
    @ViewBuilder
    func firstPersonView() -> some View {
        Group {
            if transactionType == .pay {
                selfView()
            } else {
                otherView()
                    .padding(.top)
            }
        }
            .padding(.horizontal)
        Divider()
    }
    
    @ViewBuilder
    func secondPersonView() -> some View {
        Group {
            if transactionType == .pay {
                otherView()
            } else {
                selfView()
            }
        }
            .padding(.horizontal)
        Divider()
    }
    
    @ViewBuilder
    func amountView() -> some View {
        HStack {
            Text("Amount:")
                .fontWeight(.bold)
            Spacer()
            
            TextField("Amount", text: $amountInput, prompt: Text("A"))
                .onReceive(Just(amountInput)) { newValue in
                    var filtered = newValue.filter { "0123456789".contains($0) }
                    filtered = filtered.replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
                    if filtered.count == 1 {
                        filtered = "A 0.0" + filtered
                    } else if filtered.count == 2 {
                        filtered = "A 0." + filtered
                    } else if filtered.count > 2 {
                        filtered = "A " + filtered.prefix(filtered.count-2) + "." + filtered.suffix(2)
                    }
                    if filtered != newValue {
                        amountInput = filtered
                    }
                }
                .multilineTextAlignment(.trailing)
                .padding(.trailing, 20)
                .keyboardType(.decimalPad)
                .focused($focus, equals: "amount")
            
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
            ZStack {
                TextEditor(text: $commentsInput)
                    .multilineTextAlignment(.leading)
                    .focused($focus, equals: "Comments")
                Text(commentsInput).opacity(0).padding(.all, 8)
            }
//            TextField("Comments", text: $commentsInput, prompt: Text("Comments"))
//                    .multilineTextAlignment(.leading)
//                    .focused($focus, equals: "Comments")
//                    .padding(.bottom, 30)
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
    
    @ViewBuilder
    func principleToolBarItemView() -> some View {
        ZStack {
            Picker("Transaction Type", selection: $transactionType) {
                Text("Pay").tag(TransactionType.pay)
                Text("Request").tag(TransactionType.request)
            }
                .pickerStyle(SegmentedPickerStyle())
                .frame(maxWidth: 200)
            
            HStack {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                Spacer()
                if transactionType == .request {
                    Button("Send") {
                        let newRequestedTransaction = Transaction(id: UUID().uuidString, fromPublicKey: otherUser.publicKey, toPublicKey: appViewModel.user.publicKey, timeStamp: timeStamp, amount: intAmountInput, note: commentsInput, signature: "")
                        
                        appViewModel.postRequestedTransaction(transaction: newRequestedTransaction)
                        presentationMode.wrappedValue.dismiss()
                        if let parent = parent {
                            parent.presentationMode.wrappedValue.dismiss()
                        }
                    }
                        .disabled(!canSendRequest)
                }
            }
        }
    }
    
    @ViewBuilder
    func keyboardToolBarItemView() -> some View {
        HStack {
            Spacer()
            Button {
                focus = nil
            } label: {
                Image(systemName: "keyboard.chevron.compact.down")
            }
        }
    }
    
    func selfView() -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(transactionType == .pay ? "From" : "To"): \(appViewModel.user.name)")
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
                Text("\(transactionType == .pay ? "To" : "From"): \(otherUser.name)")
                    .fontWeight(.bold)
                Text("\tPublic Key:")
                Text("\t\t@" + otherUser.publicKey.prefix(22))
                    .font(.system(.footnote , design: .monospaced))
                Text("\t\t " + otherUser.publicKey.suffix(22))
                    .font(.system(.footnote , design: .monospaced))
            }
            Spacer()
            ProfilePicView(username: otherUser.name,
                           profilePicUrl: otherUser.profilePicUrl,
                           size: 55)
        }
    }
    enum TransactionType {
        case pay
        case request
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
