//
//  FirebaseStorageService.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/18/21.
//

import Foundation
import FirebaseStorage

struct FirebaseStorageService {
    private init() { }
    static let shared = FirebaseStorageService()
    
    private let storageRef = Storage.storage().reference()
    
    private struct Key {
        static let UserProfilePics = "UserProfilePics"
    }
    
    enum StorageError: String, LocalizedError {
        case noUrl
    }
    
    func updateProfilePic(publicKey: String, imageData: Data, completion: @escaping(Result<String,Error>) -> Void) {
        let publicKey = publicKey.slashToDash()
        
        storageRef.child(Key.UserProfilePics).child(publicKey + ".jpg").putData(imageData, metadata: nil) { metaData, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            storageRef.child(Key.UserProfilePics).child(publicKey + ".jpg").downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let url = url else {
                    completion(.failure(StorageError.noUrl))
                    return
                }
                
                completion(.success(url.absoluteString))

            }
        }
    }
}
