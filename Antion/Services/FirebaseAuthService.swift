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
    
    private var verificationId: String?
    
    func startAuth(phoneNumber: String, completion: @escaping (Bool) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationId, error in
            guard let verificationId = verificationId, error == nil else {
                completion(false)
                print("error", error?.localizedDescription ?? "")
                return
            }
            self?.verificationId = verificationId
            completion(true)
            return
        }
    }
    
    func verifyCode(smsCode: String, completion: @escaping (Bool) -> Void) {
        guard let verificationId = verificationId else {
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
