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
        
        static let friends = "friends"
        static let selfRequestedFriends = "selfRequestedFriends"
        static let otherRequestedFriends = "otherRequestedFriends"
        
        static let toProfilePicUrl = "toProfilePicUrl"
        static let fromProfilePicUrl = "fromProfilePicUrl"
        static let toPublicKey = "toPublicKey"
    }
    
    enum FirestoreError: String, LocalizedError {
        case UnwrappingSnapshotFailed = "UnwrappingSnapshotFailed"
        case CodingModelFailed
        case NoDocuments
    }
    
    // MARK: Authentication
    
    func phoneHasBeenUsed(phoneNumber: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        rootRef.collection(Keys.PhoneNumbers).document(phoneNumber).getDocument { snapshot, error in
            // if there's an error
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // if you can't get the snapshot back, error
            guard let snapshot = snapshot else {
                completion(.failure(FirestoreError.UnwrappingSnapshotFailed))
                return
            }
            
            // if it exists, then true
            if snapshot.exists {
                completion(.success(true))
                return
            }
            
            // else, false
            completion(.success(false))
        }
    }
    
    func storePhoneNumber(phoneNumber: String, completion: @escaping (Result<Int, Error>) -> Void) {
        rootRef.collection(Keys.PhoneNumbers).document(phoneNumber).setData(["used": true])
        let value: Double = 1
        rootRef.collection(Keys.CountPhoneNumbers).document(Keys.countPhoneNumbers).updateData([Keys.count: FieldValue.increment(value)]) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            rootRef.collection(Keys.CountPhoneNumbers).document(Keys.countPhoneNumbers).getDocument { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let snapshot = snapshot, snapshot.exists, let count = snapshot.data()?["count"] as? Int else {
                    completion(.failure(FirestoreError.UnwrappingSnapshotFailed))
                    return
                }
                completion(.success(count))
                return
            }
        }
    }
    
    func storeNewUser(user: User, completion: @escaping (Result<Void,Error>) -> Void) {
        guard let userData = try? FirestoreEncoder().encode(user) else {
            printError()
            completion(.failure(FirestoreError.CodingModelFailed))
            return
        }
        
        rootRef.collection(Keys.Users).document(user.publicKey.slashToDash()).setData(userData) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
        }
        
        completion(.success(()))
    }

    func storeNewSearchUser(searchUser: SearchUser, completion: @escaping (Result<Void,Error>) -> Void) {
        guard let searchData = try? FirestoreEncoder().encode(searchUser) else {
            printError()
            completion(.failure(FirestoreError.CodingModelFailed))
            return
        }
        
        rootRef.collection(Keys.SearchUsers).document(searchUser.publicKey.slashToDash()).setData(searchData) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }
        
    }
    
    // MARK: UserLoggedIn

    func fetchUserInfo(publicKey: String, completion: @escaping (User?) -> Void) {
        rootRef.collection(Keys.Users).document(publicKey.slashToDash()).addSnapshotListener { document, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "error")
                completion(nil)
                return
            }
            if let document = document, document.exists, let data = document.data() {
                let user = try! FirebaseDecoder().decode(User.self, from: data)
                completion(user)
            } else {
                printError()
                print("Document does not exist")
                completion(nil)
            }
        }
    }
    
    // MARK: ProfilePage
    
    func fetchWalletInfo(publicKey: String, completion: @escaping (Result<User,Error>) -> Void) {
        rootRef.collection(Keys.Users).document(publicKey.slashToDash()).addSnapshotListener { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let document = document, document.exists, let data = document.data() {
                let user = try! FirebaseDecoder().decode(User.self, from: data)
                completion(.success(user))
            } else {
                printError()
                print("Document does not exist")
                completion(.failure(FirestoreError.UnwrappingSnapshotFailed))
            }
        }
    }
    
    func sendFriendRequest(selfFriend: Friend, otherFriend: Friend) {
        guard let selfData = try? FirestoreEncoder().encode(selfFriend) else {
            printError()
            return
        }
        guard let otherData = try? FirestoreEncoder().encode(otherFriend) else {
            printError()
            return
        }
        // put self in other
        rootRef.collection(Keys.Users).document(otherFriend.publicKey.slashToDash()).updateData([
            Keys.otherRequestedFriends: FieldValue.arrayUnion([selfData])
        ])
        
        // put other in self
        rootRef.collection(Keys.Users).document(selfFriend.publicKey.slashToDash()).updateData([
            Keys.selfRequestedFriends: FieldValue.arrayUnion([otherData])
        ])
    }
    
    func getSentRequestedTransactions(forPublicKey publicKey: String, completion: @escaping ([Transaction]) -> Void) {
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
    
    func getReceivedRequestedTransactions(forPublicKey publicKey: String, completion: @escaping ([Transaction]) -> Void) {
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
    
    
    func searchFriends(searchPrompt: String, publicKey: String, completion: @escaping ([Friend]) -> Void) {
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
    
    func fetchRecepientsForTransaction(completion: @escaping ([Friend]) -> Void) {
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

    
    //MARK: Search
    
    func searchUsers(keyword: String, lastDoc: DocumentSnapshot?, completion: @escaping (Result<([SearchUser], DocumentSnapshot?),Error>) -> Void) {
        var query = rootRef.collection(Keys.SearchUsers)
            .order(by: Keys.publicKeyLowercased)
            .limit(to: 10)
        
        if !keyword.isEmpty {
            query = query.whereField(Keys.publicKeyKeywords, arrayContains: keyword)
        }
        
        if let lastDoc = lastDoc {
            query = query.start(afterDocument: lastDoc)
        }
        
        query.getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let querySnapshot = querySnapshot else {
                completion(.failure(FirestoreError.UnwrappingSnapshotFailed))
                return
            }
            
            let documents = querySnapshot.documents
            
            if documents.isEmpty {
                completion(.failure(FirestoreError.NoDocuments))
                return
            }
            
            let searchUsers = documents.map { qSnapshot in
                return try! FirebaseDecoder().decode(SearchUser.self, from: qSnapshot.data())
            }
            
            completion(.success((searchUsers, documents.last)))
        }
    }
    
    
}


