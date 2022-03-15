//
//  FirebaseFirestoreService.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/18/21.
//

import FirebaseFirestore
import CodableFirebase

struct FirebaseFirestoreService {
    private init() { }
    static let shared = FirebaseFirestoreService()
    
    let rootRef = Firestore.firestore()
    
    struct Keys {
        //Auth
        static let PhoneNumbers = "PhoneNumbers"
        static let CountPhoneNumbers = "CountPhoneNumbers"
        static let countPhoneNumbers = "countPhoneNumbers"
        static let count = "count"
        
        // Wallet
        static let Users = "Users"
        
        static let UserUnspentTransactions = "UserUnspentTransactions"
        static let UserRequestedTransactions = "UserReceivedRequestedTransactions"
        static let UserPendingTransactions = "UserPendingTransactions"
        static let UserConfirmedTransactions = "UserConfirmedTransactions"
        
        static let UserMinedBlocks = "UserMinedBlocks"
        
        static let UserFriends = "UserFriends"
        
        // Feed Transactions
        static let FeedTransactions = "FeedTransactions"
        static let UserFeedTransactions = "UserFeedTransactions"
        
        // BlockChain
        static let Blockchain = "Blockchain"
        static let PendingTransactions = "PendingTransactions"
        static let ConfirmedTransactions = "ConfirmedTransactions"
        
        // SearchUsers
        static let SearchUsers = "SearchUsers"
        static let nameKeyWords = "nameKeyWords"
        static let publicKeyKeywords = "publicKeyKeywords"
        static let publicKeyLowercased = "publicKeyLowercased"
        
        // User Model
        static let publicKey = "publicKey"
        static let name = "name"
        static let profilePicUrl = "profilePicUrl"
        static let balance = "balance"
        
        static let numFriends = "numFriends"
        static let numReceivedRequestedTransactions = "numReceivedRequestedTransactions"
        static let numReceivedRequestedFriendRequests = "numReceivedRequestedFriendRequests"
        
        static let numConfirmedTransactions = "numConfirmedTransactions"
        static let numReceivedAntion = "numReceivedAntion"
        static let numSentAntion = "numSentAntion"
        static let numMinedBlocks = "numMinedBlocks"
        static let numRewardAntion = "numRewardAntion"
        
        static let friendPublicKeys = "friendPublicKeys"
        static let selfRequestedFriendPublicKeys = "selfRequestedFriendPublicKeys"
        static let otherRequestedFriendPublicKeys = "otherRequestedFriendPublicKeys"
        
        static let toProfilePicUrl = "toProfilePicUrl"
        static let fromProfilePicUrl = "fromProfilePicUrl"
        static let toPublicKey = "toPublicKey"
    }
    
    enum FirestoreError: String, LocalizedError {
        case UnwrappingSnapshotFailed = "UnwrappingSnapshotFailed"
        case CodingModelFailed
    }
    
    // MARK: Authentication
    
    
    
    
    // MARK: UserLoggedIn

    func fetchUserInfo(publicKey: String, completion: @escaping (User?) -> Void) {
        completion(nil)
//        rootRef.collection(Keys.Users).document(publicKey.slashToDash()).getDocument { document, error in
//            guard error == nil else {
//                print(error?.localizedDescription ?? "error")
//                completion(nil)
//                return
//            }
//            if let document = document, document.exists, let data = document.data() {
//                let user = try! FirebaseDecoder().decode(User.self, from: data)
//                completion(user)
//            } else {
//                print("Document does not exist")
//                completion(nil)
//            }
//        }
    }
    
    // MARK: ProfilePage
    
    func getFriends(forPublicKey publicKey: String, completion: @escaping ([Friend]) -> Void) {
        completion([])
//        rootRef
//            .collection(Keys.Users)
//            .document(publicKey.slashToDash())
//            .collection(Keys.UserFriends)
//            .getDocuments { querySnapshot, error in
//                guard let documents = querySnapshot?.documents else {
//                    print("No documents")
//                    completion([])
//                    return
//                }
//
//
//
//                let acquaintances = documents.map { queryDocumentSnapshot -> Friend in
//                    return try! FirebaseDecoder().decode(Friend.self, from: queryDocumentSnapshot.data())
//                }
//
//                completion(acquaintances)
//        }
    }
    
    func getPendingTransactions(forPublicKey publicKey: String, completion: @escaping ([ConfirmedTransaction]) -> Void) {
        completion([])
//        rootRef.collection(Keys.Users).document(publicKey.slashToDash()).collection(Keys.UserPendingTransactions).order(by: "timeStamp", descending: true).addSnapshotListener { snapshot, error in
//            guard let documents = snapshot?.documents else {
//                completion([])
//                return
//            }
//            let transactions = documents.map { qSnapshot in
//                return try! FirebaseDecoder().decode(ConfirmedTransaction.self, from: qSnapshot.data())
//            }
//            completion(transactions)
//        }
    }
    
    func getConfirmedTransactions(forPublicKey publicKey: String, completion: @escaping ([ConfirmedTransaction]) -> Void) {
        completion([])
//        return
//        rootRef.collection(Keys.Users).document(publicKey.slashToDash()).collection(Keys.UserConfirmedTransactions).order(by: "timeStamp", descending: true).addSnapshotListener { snapshot, error in
//            guard let documents = snapshot?.documents else {
//                completion([])
//                return
//            }
//            let transactions = documents.map { qSnapshot in
//                return try! FirebaseDecoder().decode(Transaction.self, from: qSnapshot.data())
//            }
//            completion(transactions)
//        }
    }
    
    func getSentRequestedTransactions(forPublicKey publicKey: String, completion: @escaping ([ConfirmedTransaction]) -> Void) {
        completion([])
//        rootRef.collection(Keys.Users).document(publicKey.slashToDash()).collection(Keys.UserSentRequestedTransactions).order(by: "timeStamp", descending: true).addSnapshotListener { snapshot, error in
//            guard let documents = snapshot?.documents else {
//                completion([])
//                return
//            }
//            let transactions = documents.map { qSnapshot in
//                return try! FirebaseDecoder().decode(Transaction.self, from: qSnapshot.data())
//            }
//            completion(transactions)
//        }
    }
    
    func getReceivedRequestedTransactions(forPublicKey publicKey: String, completion: @escaping ([ConfirmedTransaction]) -> Void) {
        completion([])
//        rootRef.collection(Keys.Users).document(publicKey.slashToDash()).collection(Keys.UserReceivedRequestedTransactions).order(by: "timeStamp", descending: true).addSnapshotListener { snapshot, error in
//            guard let documents = snapshot?.documents else {
//                completion([])
//                return
//            }
//            let transactions = documents.map { qSnapshot in
//                return try! FirebaseDecoder().decode(Transaction.self, from: qSnapshot.data())
//            }
//            completion(transactions)
//        }
    }
    
    func updateProfilePicUrl(publicKey: String, profilePicUrl: String) {
        
        // Update Users/{publicKey}/profilePicUrl
//        rootRef.collection(Keys.Users).document(publicKey.slashToDash()).updateData([Keys.profilePicUrl: profilePicUrl])
        
        // Update SearchUsers/{publicKey}/profilePicUrl
//        rootRef.collection(Keys.SearchUsers).document(publicKey.slashToDash()).updateData([Keys.profilePicUrl: profilePicUrl])
        
        // For acquaintance in acquaintances
            // Update in Users/{acquaintancePublicKey}/Acquaintances/{publicKey}/profilePicUrl
        
        // For each transaction in requestedTransactions
//        rootRef.collection(Keys.Users).document(publicKey.slashToDash()).collection(Keys.UserReceivedRequestedTransactions).getDocuments { querySnapshot, error in
//            if let documents = querySnapshot?.documents, !documents.isEmpty {
//                for document in documents {
//                    document.reference.updateData([Keys.fromProfilePicUrl:profilePicUrl])
//                    rootRef.collection(Keys.Users).document((document.data()[Keys.toPublicKey] as! String).slashToDash()).collection(Keys.UserSentRequestedTransactions).document(document.documentID).updateData([Keys.toProfilePicUrl: profilePicUrl])
//                }
//            }
//        }
            // Update in Users/{fromPublicKey}/RequestedTransactions/{transactionId}/from(to)ProfilePicUrl
            // Update in Users/{toPublicKey}/RequestedTransactions/{transactionId}/from(to)ProfilePicUrl
        
        // For each transaction in pendingTransactions
            // Update in Users/{fromPublicKey}/PendingTransactions/{transactionId}/fromProfilePicUrl
            // Update in Users/{toPublicKey}/PendingTransactions/{transactionId}/fromProfilePicUrl
            // Update in PendingTransactions/transactionId}/from(to)ProfilePicUrl
        
        // For each transaction in confirmedTransaction
            // Update in Users/{fromPublicKey}/ConfirmedTransactions/{transactionId}/from(to)ProfilePicUrl
            // Update in Users/{toPublicKey}/ConfirmedTransactions/{transactionId}/from(to)ProfilePicUrl
        
            // guard transactionCount < 500 else { continue }
        
            // Update in FeedTransactions/{fromPublicKey}/FeedTransactions/{transactionId}/from(to)ProfilePicUrl
            // Update in FeedTransactions/{toPublicKey}/FeedTransactions/{transactionId}/from(to)ProfilePicUrl
        
            // For friend in myFriends
                // Update in FeedTransactions/friend/FeedTransactions/{transactionId}/from(to)ProfilePicUrl
        
            // For friend in yourFriends
                // Update in FeedTransactions/friend/FeedTransactions/{transactionId}/from(to)ProfilePicUrl
            
        
//        var numberOfChanges = 2 + 2(numRequestedTransactions) + 3(numPendingTransaction) + (numConfirmedTransactions * 1004)
        

    }
    
    // MARK: Transactions Page
    
    func fetchFeedTransactions(forPublicKey publicKey: String) async throws -> [ConfirmedTransaction] {
        return []
//        guard publicKey != "" else {
//            return []
//        }
//        let transactionsSnapshot = try await rootRef
//            .collection(Keys.FeedTransactions)
//            .document(publicKey.slashToDash())
//            .collection(Keys.UserFeedTransactions)
//            .getDocuments()
//
//        let transactions = transactionsSnapshot.documents.map { queryDocumentSnapshot -> ConfirmedTransaction in
//            return try! FirebaseDecoder().decode(ConfirmedTransaction.self, from: queryDocumentSnapshot.data())
//        }
//        return transactions
    }
    
    func fetchFeedTransactions(forPublicKey publicKey: String, completion: @escaping([ConfirmedTransaction]) -> Void) {
        completion([])
//        guard publicKey != "" else {
//            completion([])
//            return
//        }
//        rootRef
//            .collection(Keys.FeedTransactions)
//            .document(publicKey.slashToDash())
//            .collection(Keys.UserFeedTransactions)
//            .addSnapshotListener { querySnapshot, error in
//            if let error = error {
//                print("Error in fetch feed transactions: \(error.localizedDescription)")
//                completion([])
//                return
//            }
//            guard let querySnapshot = querySnapshot else {
//                print("Unable to unwrap querySnapshot in fetchFeedTransactions")
//                completion([])
//                return
//            }
//
//            if querySnapshot.isEmpty {
//                completion([])
//                return
//            }
//
//            if querySnapshot.documents.isEmpty {
//                completion([])
//                return
//            }
//
//            if querySnapshot.documents.count == 0 {
//                completion([])
//                return
//            }
//
//            let transactions = querySnapshot.documents.map { queryDocumentSnapshot -> ConfirmedTransaction in
//                return try! FirebaseDecoder().decode(ConfirmedTransaction.self, from: queryDocumentSnapshot.data())
//            }
//            completion(transactions)
//        }
    }
    
    func searchFriends(searchPrompt: String, publicKey: String, completion: @escaping ([OtherUser]) -> Void) {
        completion([])
//        rootRef
//            .collection(Keys.Users)
//            .document(publicKey.slashToDash())
//            .collection(Keys.UserFriends)
//            .whereField("name", isGreaterThanOrEqualTo: searchPrompt)
//            .order(by: "name")
//            .limit(to: 10)
//            .getDocuments { querySnapshot, error in
//            completion([])
//        }
    }
    
    func fetchRecepientsForTransaction(completion: @escaping ([OtherUser]) -> Void) {
        completion([])
//        rootRef
//            .collection(Keys.Users)
//            .getDocuments { querySnapshot, error in
//            guard let documents = querySnapshot?.documents else {
//                print("No documents")
//                completion([])
//                return
//            }
//
//            let users = documents.map { queryDocumentSnapshot -> OtherUser in
//                return try! FirebaseDecoder().decode(OtherUser.self, from: queryDocumentSnapshot.data())
//            }
//
//            completion(users)
//        }
    }
    
    func postPendingTransaction(_ transaction: ConfirmedTransaction) {
//        // Encode Data
//        let docData = try! FirestoreEncoder().encode(transaction)
//
//        // Post to root/PendingTransactions/{transactionId}
//        rootRef
//            .collection(Keys.PendingTransactions)
//            .document(transaction.id)
//            .setData(docData) { error in
//            if let error = error {
//                print("Error writing transaction to PendingTransactions: \(error.localizedDescription)")
//            } else {
//                print("Pending transaction successfully written to PendingTransactions")
//            }
//        }
//
//        // Post to root/Users/{userPublicKey}/UserPendingTransactions/{transactionId}
//        rootRef
//            .collection(Keys.Users)
//            .document(transaction.fromPublicKey.slashToDash())
//            .collection(Keys.UserPendingTransactions)
//            .document(transaction.id)
//            .setData(docData) { error in
//            if let error = error {
//                print("Error writing transaction to UsersPendingTransactions: \(error.localizedDescription)")
//            } else {
//                print("Pending transaction successfully written to UsersPendingTransactions")
//            }
//        }
    }
    
    // MARK: Mining Page
    
    func getPendingTransactions(completion: @escaping ([ConfirmedTransaction]) -> Void) {
        completion([])
//        rootRef.collection(Keys.PendingTransactions)
//            .order(by: "timeStamp", descending: true)
//            .addSnapshotListener { snapshot, error in
//                guard let documents = snapshot?.documents else {
//                    completion([])
//                    return
//                }
//                let transactions = documents.map { qSnapshot in
//                    return try! FirebaseDecoder().decode(ConfirmedTransaction.self, from: qSnapshot.data())
//                }
//                completion(transactions)
//            }
    }
    
    
    func removePendingTransaction(_ transaction: ConfirmedTransaction) {
//        // Remove from root/PendingTransactions/{transactionId}
//        rootRef
//            .collection(Keys.PendingTransactions)
//            .document(transaction.id)
//            .delete()
//
//        if transaction.fromPublicKey != "" {
//            // Remove from root/Users/{userPublicKey}/UserPendingTransactions/{transactionId}
//            rootRef
//                .collection(Keys.Users)
//                .document(transaction.fromPublicKey.slashToDash())
//                .collection(Keys.UserPendingTransactions)
//                .document(transaction.id)
//                .delete()
//        }
    }
    
    func savePublishedTransaction(_ transaction: ConfirmedTransaction) async {
//        // Encode Data
//        let docData = try! FirestoreEncoder().encode(transaction)
//
//        // Store in root/ConfirmedTransactions/{transactionId}
//        do {
//            try await rootRef
//                .collection(Keys.ConfirmedTransactions)
//                .document(transaction.id)
//                .setData(docData)
//        } catch (let error) {
//            print("Error writing document: \(error)")
//        }
//
//        // Add to root/Users/{}/UserConfirmedTransactions
//        if transaction.fromPublicKey != "" {
//            do {
//                try await rootRef
//                    .collection(Keys.Users)
//                    .document(transaction.fromPublicKey.slashToDash())
//                    .collection(Keys.UserConfirmedTransactions)
//                    .document(transaction.id)
//                    .setData(docData)
//            } catch (let error) {
//                print("Error writing document: \(error)")
//            }
//        }
//        do {
//            try await rootRef
//                .collection(Keys.Users)
//                .document(transaction.toPublicKey.slashToDash())
//                .collection(Keys.UserConfirmedTransactions)
//                .document(transaction.id)
//                .setData(docData)
//        } catch (let error) {
//            print("Error writing document: \(error)")
//        }
//
//
//
//        var publicKeys: Set<String> = []
//        if transaction.fromPublicKey != "" {
//            publicKeys.insert(transaction.fromPublicKey)
//        }
//        publicKeys.insert(transaction.toPublicKey)
//
//        if transaction.fromPublicKey != "" {
//            let fromUserDoc = try? await rootRef.collection(Keys.Users).document(transaction.fromPublicKey.slashToDash()).getDocument()
//            if let fromUserDoc = fromUserDoc, fromUserDoc.exists, let data = fromUserDoc.data(), let fromFriends = data["friendPublicKeys"] as? [String] {
//                for friend in fromFriends {
//                    publicKeys.insert(friend)
//                }
//            }
//        }
//        let toUserDoc = try? await rootRef.collection(Keys.Users).document(transaction.toPublicKey.slashToDash()).getDocument()
//
//
//        if let toUserDoc = toUserDoc, toUserDoc.exists, let data = toUserDoc.data(), let toFriends = data["friendPublicKeys"] as? [String] {
//            for friend in toFriends {
//                publicKeys.insert(friend)
//            }
//        }
//        for publicKey in publicKeys {
//            try? await rootRef.collection(Keys.FeedTransactions).document(publicKey.slashToDash()).collection(Keys.UserFeedTransactions).document(transaction.id).setData(docData)
//        }
    }
    
    func getBlockchain(completion: @escaping ([Block]) -> Void) {
//        rootRef.collection(Keys.Blockchain)
//            .addSnapshotListener { snapshot, error in
//                guard let documents = snapshot?.documents else {
//                    completion([])
//                    return
//                }
//                let blockchain = documents.map { qSnapshot in
//                    return try! FirebaseDecoder().decode(Block.self, from: qSnapshot.data())
//                }
//                completion(blockchain)
//            }
    }
    
    
    func saveBlock(_ block: Block) {
//        let docData = try! FirestoreEncoder().encode(block)
//        rootRef.collection(Keys.Blockchain).document(String(block.id)).setData(docData) { error in
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//            print("Successfully saved block")
//        }
    }
    
    
    
}


