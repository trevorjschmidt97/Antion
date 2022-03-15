//
//  AuthFirestoreService.swift
//  Antion
//
//  Created by Trevor Schmidt on 3/10/22.
//

import Foundation
import CodableFirebase
import UIKit
import FirebaseFirestore

extension FirebaseFirestoreService {
    
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
        
        rootRef.collection(Keys.Users).document(user.publicKey.dashToSlash()).setData(userData) { error in
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
    
}
