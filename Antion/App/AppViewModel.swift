//
//  AppViewModel.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/18/21.
//

import Foundation
import SwiftUI
import AlertToast

class AppViewModel: ObservableObject {
    private init() { }
    static let shared = AppViewModel()
    
    // MARK: Auth
    @AppStorage("userName") var name = "Anonymous"
    @AppStorage("userProfilePicUrl") var profilePicUrl = ""
    @Published var privateKey: String?
    var publicKey: String {
        CryptoService.getPublicKeyString(forPrivateKeyString: privateKey ?? "") ?? ""
    }
    
    func signOut() {
        name = ""
        profilePicUrl = ""
        loadingUserInfo = true
        user = blankUser
        privateKey = nil
    }
    
    // MARK: UserInfo
    @Published var user: User = blankUser
    @Published var blockChain: BlockChain = BlockChain()
    @Published var pendingTransactions: [Transaction] = []
    
    // MARK: Database Calls
    @Published var appIsLoading = true
    func onAppear() {
        if !appIsLoading { return }
        print("App did appear")        
        FirebaseDatabaseService.shared.pullBlockChain { [weak self] retBlockChain in
            DispatchQueue.main.async {
                self?.blockChain.chain = retBlockChain
                self?.appIsLoading = false
            }
        }
        
    }
    
    @Published var loadingUserInfo = true
    @Published var loadingSearchUserInfo = true
    func pullUserInfo() {
        guard publicKey != "" else { return }
        FirebaseFirestoreService.shared.fetchUserInfo(publicKey: publicKey.slashToDash()) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let result = result {
                    self.user = result
                    self.name = result.name
                    self.profilePicUrl = result.profilePicUrl
                    self.loadingUserInfo = false
                    self.loadingSearchUserInfo = false
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                        self.showSuccess(title: "Signed In", message: nil)
//                    }
                } else {
                    print("No user")
                    // Save new user
                    self.user = User(publicKey: self.publicKey)
                    let newUser = User(publicKey: self.publicKey)
                    let newSearchUser = SearchUser(publicKey: self.publicKey)
                    FirebaseFirestoreService.shared.storeNewUser(user: newUser) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(()):
                                print("New User Created")
                            case .failure(let error):
                                print("Failure creating new user: \(error.localizedDescription)")
                            }
                            self.loadingUserInfo = false
                        }
                    }
                    FirebaseFirestoreService.shared.storeNewSearchUser(searchUser: newSearchUser) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(()):
                                print("New SearchUser Created")
                            case .failure(let error):
                                print("Failure creating new searchUser: \(error.localizedDescription)")
                            }
                            self.loadingSearchUserInfo = false
                        }
                    }
                }
            }
        }
    }
    
    
    
    @Published var isMining = false
    func startMining(minerPublicKey: String) {
        print("Starting Mining")
        var index = 0
        var previousHash = ""
        var miningReward = 400
        let difficulty = 4
        
        if let latestBlock = blockChain.latestBlock() {
            index = latestBlock.index + 1
            previousHash = latestBlock.hash
            // Change this for different miningReward / difficulty
            miningReward = miningReward - latestBlock.index
//            difficulty = difficulty + latestBlock.index
        }
        
        // Get pending transactions
        var pendingTransactionsList = pendingTransactions
        var userBalances: [String:Int] = [:]
        for (i, transaction) in pendingTransactionsList.enumerated() {
            if !transaction.isValidSignature() {
                let badTransaction = pendingTransactionsList.remove(at: i)
                print("Transaction: \(badTransaction.id) invalid signature")
                continue
            }
            
            // Grab the balance if not already
            if userBalances[transaction.fromPublicKey] == nil {
                userBalances[transaction.fromPublicKey] = blockChain.getBalanceOfWallet(address: transaction.fromPublicKey)
            }
            if userBalances[transaction.toPublicKey] == nil {
                userBalances[transaction.toPublicKey] = blockChain.getBalanceOfWallet(address: transaction.toPublicKey)
            }
            
            if transaction.amount > userBalances[transaction.fromPublicKey]! {
                let badTransaction = pendingTransactionsList.remove(at: i)
                print("Transaction: \(badTransaction.id) not enough balance")
                continue
            }
            
            
            // Now reset the balances
            userBalances[transaction.fromPublicKey] = userBalances[transaction.fromPublicKey]! - transaction.amount
            userBalances[transaction.toPublicKey] = userBalances[transaction.toPublicKey]! + transaction.amount
        }
        
        // Add reward Transaction
        let rewardTransaction = Transaction(fromPublicKey: "", fromPrivateKey: "", toPublicKey: minerPublicKey, amount: miningReward, note: "Mining Reward")
        pendingTransactionsList.append(rewardTransaction)
        var newBlock = Block(index: index,
                             timeStamp: Date.now.toLongString(),
                             previousHash: previousHash,
                             minerPublicKey: minerPublicKey,
                             difficulty: difficulty,
                             nonce: 0,
                             hash: "",
                             transactions: pendingTransactionsList)
        
        // Mine the newBlock
        isMining = true
        DispatchQueue.init(label: "mine").async {
            while (newBlock.hash.prefix(difficulty) != String(repeating: "0", count: difficulty) && self.isMining) {
                if newBlock.nonce % 100000 == 0 {
                    print("Nonce: \(newBlock.nonce)")
                    print("Hash: \(newBlock.hash)")
                }
                newBlock.nonce += 1
                newBlock.hash = CryptoService.hashBlock(newBlock)
            }
            DispatchQueue.main.async {
                withAnimation {
                    if self.isMining {
                        self.blockChain.chain.append(newBlock)
                        FirebaseDatabaseService.shared.addBlockToChain(block: newBlock)
                        self.pendingTransactions.removeAll()
//                        FirebaseDatabaseService.shared.deletePendingTransaction(transactions: newBlock.transactions)
                    }
                    
                    self.isMining = false
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: Color
    @AppStorage("accentColorString") var accentColorString = "red" {
        didSet {
            UINavigationBar.appearance().tintColor = UIColor(AppViewModel.shared.accentColor)
        }
    }
    
    var accentColor: Color {
        switch accentColorString {
        case "blue": return Color.blue
        case "brown": return Color.brown
        case "cyan": return Color.cyan
        case "green": return Color.green
        case "orange": return Color.orange
        case "purple": return Color.purple
        case "red": return Color.red
        case "yellow": return Color.yellow
        case "black": return Color.primary
        default: return Color.green
        }
    }
//    var accentColorHex: String {
//        switch accentColorString {
//        case "blue": return "#007aff"
//        case "brown": return "#a2845e"
//        case "cyan": return "#32ade6"
//        case "green": return "#34c759"
//        case "orange": return "#ff9500"
//        case "purple": return "#af52de"
//        case "red": return "#ff3b30"
//        case "yellow": return "#ffcc00"
//        default: return "#34c759"
//        }
//    }
    
    // MARK: Alerts
    @Published var successShown = false
    @Published var successTitle: String?
    @Published var successMessage: String?
    @Published var successDisplayMode: AlertToast.DisplayMode = .alert
    
    @Published var failureShown = false
    @Published var failureTitle: String?
    @Published var failureMessage: String?
    @Published var failureDisplayMode: AlertToast.DisplayMode = .alert
    
    func showSuccess(title: String, message: String?, displayMode: AlertToast.DisplayMode = .hud) {
        withAnimation {
            successTitle = title
            successMessage = message
            successShown = true
            successDisplayMode = displayMode
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.successShown = false
            }
        }
    }
    
    func showFailure(title: String, message: String?, displayMode: AlertToast.DisplayMode = .alert) {
        withAnimation {
            failureTitle = title
            failureMessage = message
            failureDisplayMode = displayMode
            failureShown = true
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.failureShown = false
            }
        }
    }
    
}
