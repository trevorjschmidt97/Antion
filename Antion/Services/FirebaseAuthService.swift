//
//  FirebaseAuthService.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/18/21.
//

import Foundation
import FirebaseAuth

class FirebaseAuthService {
    private init() { }
    static let shared = FirebaseAuthService()
    
    private let auth = FirebaseAuth.Auth.auth()
    
    private enum FirebaseAuthError: Error {
        case noVerificationId
    }
    
    func startAuth(phoneNumber: String, completion: @escaping (Result<String,Error>) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let verificationID = verificationID else {
                completion(.failure(FirebaseAuthError.noVerificationId))
                return
            }
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            completion(.success(verificationID))
            return
        }
    }
    
    func verifyCode(smsCode: String, completion: @escaping (Bool) -> Void) {
        guard let verificationId = UserDefaults.standard.string(forKey: "authVerificationID") else {
            completion(false)
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: smsCode)
        
        auth.signIn(with: credential) { result, error in
            guard result != nil, error == nil else {
                completion(false)
                return
            }
            completion(true)
            return
        }
    }
}
