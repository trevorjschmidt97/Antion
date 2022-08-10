//
//  AppViewModel.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/18/21.
//

import Foundation
import SwiftUI
import AlertToast

public func printError(file: String = #file, function: String = #function, line: Int = #line ) {
    print("Error in file: \n\t\(file)\nfunction: \n\t\(function), line: \(line)")
}

class AppViewModel: ObservableObject {
    private init() { }
    static let shared = AppViewModel()
    
    // MARK: Caching user info
    @AppStorage("userName") var name = "Anonymous"
    @AppStorage("userProfilePicUrl") var profilePicUrl = ""
    
    // MARK: Auth
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
    
    // MARK: Database Calls
    @Published var blockChainLoading = true
    @Published var pendingTransactionsLoading = true
    func onAppear() {
        if blockChainLoading {
            FirebaseDatabaseService.shared.pullBlockChain { [weak self] result in
                self?.blockChainLoading = false
                guard let self = self else {
                    return
                }
                DispatchQueue.main.async {
                    switch result {
                    case .success(let retBlocks):
                        self.blockChain.chain = retBlocks
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
        
        if pendingTransactionsLoading {
            FirebaseDatabaseService.shared.pullPendingTransactions { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.pendingTransactionsLoading = false
                    switch result {
                    case .success(let retPendingTransactions):
                        withAnimation {
                            self.blockChain.pendingTransactions = retPendingTransactions
                        }
                    case .failure(let error):
                        printError()
                        print(error.localizedDescription)
                    }
                }
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
                    withAnimation {
                        self.user = result
                        self.name = result.name
                        self.profilePicUrl = result.profilePicUrl
                        self.loadingUserInfo = false
                        self.loadingSearchUserInfo = false
                    }
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
    
    func fulfillTransaction(requestedTransaction: Transaction, signedTransaction: Transaction) {
        deleteRequestedTransaction(transaction: requestedTransaction)
        postPendingTransaction(transaction: signedTransaction)
    }
    
    func postRequestedTransaction(transaction: Transaction) {
        FirebaseFirestoreService.shared.sendRequestedTransaction(transaction: transaction)
    }
    
    func deleteRequestedTransaction(transaction: Transaction) {
        FirebaseFirestoreService.shared.deleteRequestedTransaction(transaction: transaction)
    }
    
    func postPendingTransaction(transaction: Transaction) {
        FirebaseDatabaseService.shared.addPendingTransaction(transaction: transaction)
    }
    
    func name(for publicKey: String) -> String? {
        // If it's yourself
        if publicKey == user.publicKey {
            return user.name
        }
        // If it's a friend
        if let friend = user.friendsMap[publicKey] {
            return friend.name
        }
        // If they have requested to be your friend
        if let otherRequest = user.otherRequestedFriendsMap[publicKey] {
            return otherRequest.name
        }
        
        return nil
    }
    func profilePicUrl(for publicKey: String) -> String? {
        // If it's yourself
        if publicKey == user.publicKey {
            return user.profilePicUrl
        }
        // If it's a friend
        if let friend = user.friendsMap[publicKey] {
            return friend.profilePicUrl
        }
        // If they have requested to be your friend
        if let otherRequest = user.otherRequestedFriendsMap[publicKey] {
            return otherRequest.profilePicUrl
        }
        
        return nil
    }
    
    // MARK: Blockchain Mining
    @Published var isMining = false
    @Published var newBlock: Block = exampleBlock
    func startMining() {
        print("Starting Mining")
        var index = 0
        var previousHash = ""
        var miningReward = 40000
        var difficulty = 4
        
        if let latestBlock = blockChain.latestBlock() {
            index = latestBlock.index + 1
            previousHash = latestBlock.hash

            // Mining reward will half every 100000 blocks, starting at 400.00 antion
            miningReward = Int(Double(miningReward) * pow(0.5, floor(Double(index)/100000)))
            
            // Change of difficulty
            // We are striving for blocks to be published every 5 minutes
            // This will increase the difficulty in relation to the number of people that are mining
                // rather, in relation to how fast the blocks are mined
            // Therefore we use this function
            // nextDifficulty = (previousDifficulty * 2016 * 5) / (time to mine last 2016 blocks)
            
            let week = Int(floor(Double(index)/2016))
            if week > 0 && blockChain.chain.count >= ((week)*2016) {
                let firstOfWeekBlock = blockChain.chain[(week-1)*2016]
                let lastOfWeekBlock = blockChain.chain[((week-1)*2016)+2015]
                
                let previousDifficulty = firstOfWeekBlock.difficulty
                let minutesOfLastWeek = lastOfWeekBlock.timeStamp.longStringToDate().minutes(from: firstOfWeekBlock.timeStamp.longStringToDate())
                
                difficulty = (previousDifficulty * 2016 * 5) / minutesOfLastWeek
            }
        }
        
        // Get pending transactions
        var pendingTransactionsList = Array(blockChain.pendingTransactions.sorted{ $0.timeStamp < $1.timeStamp }.prefix(4095))
        
        print("Verifying Pending Transactions")
        var userBalances: [String:Int] = [:]
        for (i, transaction) in pendingTransactionsList.enumerated() {
            // If rewarded transaction or free transaction
            if transaction.fromPublicKey == "" {
                continue
            }
            
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
            
            // Check for amount
            if transaction.amount > userBalances[transaction.fromPublicKey]! {
                let badTransaction = pendingTransactionsList.remove(at: i)
                print("Transaction: \(badTransaction.id) not enough balance")
                continue
            }
            
            // Now update the balances
            userBalances[transaction.fromPublicKey] = userBalances[transaction.fromPublicKey]! - transaction.amount
            userBalances[transaction.toPublicKey] = userBalances[transaction.toPublicKey]! + transaction.amount
        }
        
        // Add reward Transaction
        let rewardTransaction = Transaction(fromPublicKey: "", fromPrivateKey: "", toPublicKey: user.publicKey, amount: miningReward, note: "Mining Reward", timeStamp: Date().toLongString())

        print("Creating New Block")
        newBlock = Block(index: index,
                             timeStamp: Date.now.toLongString(),
                             previousHash: previousHash,
                             minerPublicKey: user.publicKey,
                             difficulty: difficulty,
                             nonce: 0,
                             hash: "",
                             transactions: pendingTransactionsList)
                
        newBlock.transactions.append(rewardTransaction)
        
        // Mine the newBlock
        isMining = true
        
        Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true) { timer in
//            guard let self = self else { return }
            if self.newBlock.nonce % 100 == 0 {
                print("Mining Nonce: \(self.newBlock.nonce)")
            }
            if self.newBlock.hash.prefix(difficulty) != String(repeating: "0", count: difficulty) && self.isMining {
                DispatchQueue.main.async {
                    self.newBlock.nonce += 1
                    self.newBlock.hash = CryptoService.hashBlock(self.newBlock)
                }
            } else if self.isMining {
                withAnimation {
                    FirebaseDatabaseService.shared.addBlockToChain(block: self.newBlock)
                    for transaction in self.newBlock.transactions {
                        FirebaseDatabaseService.shared.removePendingTransaction(transaction)
                    }
                    self.blockChain.pendingTransactions.removeAll()
                }
                DispatchQueue.main.async {
                    self.isMining = false
                }
                timer.invalidate()
            }
        }
//        var timer: DispatchSourceTimer? = nil
//        let queue = DispatchQueue(label: "miningTimer")
//        timer = DispatchSource.makeTimerSource(queue: queue)
//        timer?.schedule(deadline: .now(), repeating: .milliseconds(10))
//
//        print("Starting Mining")
//        timer?.setEventHandler { [weak self] in
//            guard let self = self else { return }
//            if self.newBlock.nonce % 100 == 0 {
//                print("Mining Nonce: \(self.newBlock.nonce)")
//            }
//            if self.newBlock.hash.prefix(difficulty) != String(repeating: "0", count: difficulty) && self.isMining {
//                self.newBlock.nonce += 1
//                self.newBlock.hash = CryptoService.hashBlock(self.newBlock)
//            } else if self.isMining {
//                withAnimation {
//                    FirebaseDatabaseService.shared.addBlockToChain(block: self.newBlock)
//                    for transaction in self.newBlock.transactions {
//                        FirebaseDatabaseService.shared.removePendingTransaction(transaction)
//                    }
//                    self.blockChain.pendingTransactions.removeAll()
//                }
//                DispatchQueue.main.async {
//                    self.isMining = false
//                }
//                timer?.cancel()
//                timer = nil
//            }
//        }
//
//
//        timer?.resume()
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
        case "black": return Color.black
        default: return Color.green
        }
    }
    
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

//var privateKey: String?// = "SjRQh38G/50ur/Pwjsw4I7YzYE4HzU7E1dyHMxIcvYk="
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
