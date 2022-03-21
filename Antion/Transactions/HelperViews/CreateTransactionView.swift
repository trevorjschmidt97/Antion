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
    @EnvironmentObject var viewModel: TransactionsViewModel
    
    @Environment(\.presentationMode) var presentationMode
    var parent: FindRecepientView
    
    var otherUser: Friend

    enum TransactionType {
        case pay
        case request
    }
    @State private var transactionType: TransactionType = .pay
    
    var dateStamp = Date.now.toLongString()
    @State private var amountInput = ""
    var intAmountInput: Int {
        Int(amountInput.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "$", with: "")) ?? 0
    }
    var validAmount: Bool {
        if intAmountInput <= 0  {
            return false
        }
        return true
    }
    @State private var commentsInput = ""
    @State private var signature = ""
    @State private var previousAmount = 0
    @State private var previousComments = ""
    
    @FocusState private var focus: String?
    @State private var invalidAmountError = false
    @State private var notEnoughBalanceError = false
    
    var isValidSignature: Bool {
        if signature.isEmpty { return false }
        if commentsInput != previousComments { return false }
        if previousAmount != intAmountInput { return false }
        return true
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
                        } else if !isValidSignature {
                            guard appViewModel.privateKey != "" else {
                                return
                            }
                            signature = ""
//                            signature = Transaction.signature(privateKey: privateKey, timeStamp: dateStamp, amount: intAmountInput, fromPublicKey: appViewModel.publicKey, toPublicKey: otherUser.publicKey, note: commentsInput)
                            previousAmount = intAmountInput
                            previousComments = commentsInput
                        } else {
//                            let transaction = ConfirmedTransaction(timeStamp: dateStamp,
//                                                          amount: intAmountInput,
//                                                          fromPublicKey: appViewModel.user.publicKey,
//                                                          toPublicKey: otherUser.publicKey,
//                                                          note: commentsInput,
//                                                          signature: signature,
//                                                          fromName: appViewModel.user.name,
//                                                          toName: otherUser.name,
//                                                          fromProfilePicUrl: appViewModel.user.profilePicUrl)
//                            viewModel.postTransaction(transaction)
                            presentationMode.wrappedValue.dismiss()
                            parent.presentationMode.wrappedValue.dismiss()
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
                                        subTitle: "Not enough balance for transaction, you have $formattedBalance",
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
                Text("\(dateStamp)")
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
            
            TextField("Amount", text: $amountInput, prompt: Text("$"))
                .onReceive(Just(amountInput)) { newValue in
                    var filtered = newValue.filter { "0123456789".contains($0) }
                    filtered = filtered.replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
                    if filtered.count == 1 {
                        filtered = "$0.0" + filtered
                    } else if filtered.count == 2 {
                        filtered = "$0." + filtered
                    } else if filtered.count > 2 {
                        filtered = "$" + filtered.prefix(filtered.count-2) + "." + filtered.suffix(2)
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
                Text("Note:")
                    .fontWeight(.bold)
                Spacer()
            }
            TextField("Note", text: $commentsInput, prompt: Text("Optional"))
                    .multilineTextAlignment(.leading)
                    .focused($focus, equals: "note")
                    .padding(.bottom, 30)
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
                    parent.presentationMode.wrappedValue.dismiss()
                }
                Spacer()
                if transactionType == .request {
                    Button("Send") {
                        presentationMode.wrappedValue.dismiss()
                        parent.presentationMode.wrappedValue.dismiss()
                    }
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

}

struct PayRequestTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CreateTransactionView(parent: FindRecepientView(), otherUser: Friend(publicKey: "", name: "", profilePicUrl: ""))

        }
        .environmentObject(AppViewModel.shared)
    }
}
