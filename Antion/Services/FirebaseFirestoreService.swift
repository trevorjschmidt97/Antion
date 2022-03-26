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
        static let requestedTransactions = "requestedTransactions"
        
        static let toProfilePicUrl = "toProfilePicUrl"
        static let fromProfilePicUrl = "fromProfilePicUrl"
        static let toPublicKey = "toPublicKey"
    }
    
    enum FirestoreError: String, LocalizedError {
        case UnwrappingSnapshotFailed
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
            return
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
        return
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
            return
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
               
                if let user = try? FirebaseDecoder().decode(User.self, from: data) {
                    completion(user)
                    return
                }
                print("Error converting to User")
                completion(nil)
                return
            } else {
                printError()
                print("Document does not exist")
                completion(nil)
                return
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
                if let user = try? FirebaseDecoder().decode(User.self, from: data) {
                    completion(.success(user))
                    return
                }
                
                completion(.failure(FirestoreError.UnwrappingSnapshotFailed))
                return
            } else {
                printError()
                print("Document does not exist")
                completion(.failure(FirestoreError.UnwrappingSnapshotFailed))
                return
            }
        }
    }
    
    func sendRequestedTransaction(transaction: Transaction) {
        guard let transactionData = try? FirestoreEncoder().encode(transaction) else {
            printError()
            return
        }
        
        // put it in other's otherRequestedTransactions
        rootRef.collection(Keys.Users).document(transaction.fromPublicKey.slashToDash()).updateData([
            Keys.requestedTransactions: FieldValue.arrayUnion([transactionData])
        ])
        
        rootRef.collection(Keys.Users).document(transaction.toPublicKey.slashToDash()).updateData([
            Keys.requestedTransactions: FieldValue.arrayUnion([transactionData])
        ])
    }
    
    func deleteRequestedTransaction(transaction: Transaction) {
        guard let transactionData = try? FirestoreEncoder().encode(transaction) else {
            printError()
            return
        }
        
        rootRef.collection(Keys.Users).document(transaction.fromPublicKey.slashToDash()).updateData([
            Keys.requestedTransactions: FieldValue.arrayRemove([transactionData])
        ])
        
        rootRef.collection(Keys.Users).document(transaction.toPublicKey.slashToDash()).updateData([
            Keys.requestedTransactions: FieldValue.arrayRemove([transactionData])
        ])
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
    
    func cancelFriendRequest(selfFriend: Friend, otherFriend: Friend) {
        guard let selfData = try? FirestoreEncoder().encode(selfFriend) else {
            printError()
            return
        }
        guard let otherData = try? FirestoreEncoder().encode(otherFriend) else {
            printError()
            return
        }
        // remove self in other
        rootRef.collection(Keys.Users).document(otherFriend.publicKey.slashToDash()).updateData([
            Keys.otherRequestedFriends: FieldValue.arrayRemove([selfData])
        ])
        
        // remove other in self
        rootRef.collection(Keys.Users).document(selfFriend.publicKey.slashToDash()).updateData([
            Keys.selfRequestedFriends: FieldValue.arrayRemove([otherData])
        ])
    }
    
    func acceptFriendRequest(selfFriend: Friend, otherFriend: Friend) {
        cancelFriendRequest(selfFriend: otherFriend, otherFriend: selfFriend)
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
            Keys.friends: FieldValue.arrayUnion([selfData])
        ])
        
        // put other in self
        rootRef.collection(Keys.Users).document(selfFriend.publicKey.slashToDash()).updateData([
            Keys.friends: FieldValue.arrayUnion([otherData])
        ])
    }
    
    func unfriend(selfFriend: Friend, otherFriend: Friend) {
        guard let selfData = try? FirestoreEncoder().encode(selfFriend) else {
            printError()
            return
        }
        guard let otherData = try? FirestoreEncoder().encode(otherFriend) else {
            printError()
            return
        }
        // remove self in other
        rootRef.collection(Keys.Users).document(otherFriend.publicKey.slashToDash()).updateData([
            Keys.friends: FieldValue.arrayRemove([selfData])
        ])
        
        // remove other in self
        rootRef.collection(Keys.Users).document(selfFriend.publicKey.slashToDash()).updateData([
            Keys.friends: FieldValue.arrayRemove([otherData])
        ])
    }
    
    func updateName(publicKey: String, previousName: String, name: String, profilePicUrl: String, friendsPublicKeys: [String], selfRequested: [String], otherRequested: [String]) {
        guard let previousData = try? FirestoreEncoder().encode(Friend(publicKey: publicKey, name: previousName, profilePicUrl: profilePicUrl)) else {
            printError()
            return
        }
        guard let currentData = try? FirestoreEncoder().encode(Friend(publicKey: publicKey, name: name, profilePicUrl: profilePicUrl)) else {
            printError()
            return
        }
        
        // Update Users/{publicKey}/profilePicUrl
        rootRef.collection(Keys.Users).document(publicKey.slashToDash()).updateData([Keys.name: name])
        
        // For friend in acquaintances
        for friendPublicKey in friendsPublicKeys {
            rootRef.collection(Keys.Users).document(friendPublicKey.slashToDash()).updateData([
                Keys.friends: FieldValue.arrayRemove([previousData])
            ])
            rootRef.collection(Keys.Users).document(friendPublicKey.slashToDash()).updateData([
                Keys.friends: FieldValue.arrayUnion([currentData])
            ])
        }
        
        for otherPublicKey in selfRequested {
            rootRef.collection(Keys.Users).document(otherPublicKey.slashToDash()).updateData([
                Keys.otherRequestedFriends: FieldValue.arrayRemove([previousData])
            ])
            rootRef.collection(Keys.Users).document(otherPublicKey.slashToDash()).updateData([
                Keys.otherRequestedFriends: FieldValue.arrayUnion([currentData])
            ])
        }

        for selfPublicKey in otherRequested {
            rootRef.collection(Keys.Users).document(selfPublicKey.slashToDash()).updateData([
                Keys.selfRequestedFriends: FieldValue.arrayRemove([previousData])
            ])
            rootRef.collection(Keys.Users).document(selfPublicKey.slashToDash()).updateData([
                Keys.selfRequestedFriends: FieldValue.arrayUnion([currentData])
            ])
        }
    }
    
    func updateProfilePicUrl(publicKey: String, name: String, previousProfilePicUrl: String, profilePicUrl: String, friendsPublicKeys: [String], selfRequested: [String], otherRequested: [String]) {
        
        guard let previousData = try? FirestoreEncoder().encode(Friend(publicKey: publicKey, name: name, profilePicUrl: previousProfilePicUrl)) else {
            printError()
            return
        }
        guard let currentData = try? FirestoreEncoder().encode(Friend(publicKey: publicKey, name: name, profilePicUrl: profilePicUrl)) else {
            printError()
            return
        }
        
        // Update Users/{publicKey}/profilePicUrl
        rootRef.collection(Keys.Users).document(publicKey.slashToDash()).updateData([Keys.profilePicUrl: profilePicUrl])
        
        // For friend in acquaintances
        for friendPublicKey in friendsPublicKeys {
            rootRef.collection(Keys.Users).document(friendPublicKey.slashToDash()).updateData([
                Keys.friends: FieldValue.arrayRemove([previousData])
            ])
            rootRef.collection(Keys.Users).document(friendPublicKey.slashToDash()).updateData([
                Keys.friends: FieldValue.arrayUnion([currentData])
            ])
        }
        
        for otherPublicKey in selfRequested {
            rootRef.collection(Keys.Users).document(otherPublicKey.slashToDash()).updateData([
                Keys.otherRequestedFriends: FieldValue.arrayRemove([previousData])
            ])
            rootRef.collection(Keys.Users).document(otherPublicKey.slashToDash()).updateData([
                Keys.otherRequestedFriends: FieldValue.arrayUnion([currentData])
            ])
        }

        for selfPublicKey in otherRequested {
            rootRef.collection(Keys.Users).document(selfPublicKey.slashToDash()).updateData([
                Keys.selfRequestedFriends: FieldValue.arrayRemove([previousData])
            ])
            rootRef.collection(Keys.Users).document(selfPublicKey.slashToDash()).updateData([
                Keys.selfRequestedFriends: FieldValue.arrayUnion([currentData])
            ])
        }

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
            return
        }
    }
    
}
