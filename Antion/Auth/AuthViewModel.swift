//
//  AuthViewModel.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/18/21.
//

import Foundation
import LocalAuthentication
import SwiftUI

class AuthViewModel: ObservableObject {
    
    @Published var phoneNumberInput = "+1"
    @Published var signInPrivateKeyInput = ""
    @Published var otcInput = ""
    
    @Published var showPhoneVerificationScreen = false
    @Published var isShowingWalletScreen = false
    
    @Published var publicKey = ""
    @Published var privateKey = ""
 
    // try to log in with faceId/touchId if possible
    func onAppear() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.requestBiometricUnlock { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let privateKey):
                        AppViewModel.shared.privateKey = privateKey
                    case .failure(let error):
                        if error == .deniedAccess {
                            AppViewModel.shared.showFailure(title: "Biometrics Denied", message: "Go to settings to allow \(self.biometricType() == .face ? "face-id" : "touch-id")", displayMode: .hud)
                        }
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    // In Sign In
    @Published var showInvalidPrivateKey = false
    func signInButtonPressed() {
        if let privateKey = CryptoService.generatePrivateKeyString(fromString: signInPrivateKeyInput) {
            savePrivateKeyWithNoFree(privateKey: privateKey)
        } else {
            showInvalidPrivateKey = true
        }
    }
    
    @Published var errorSendingPhoneAuthCode = false
    func initiatePhoneAuth() {
        // Send auth code
        FirebaseAuthService.shared.startAuth(phoneNumber: phoneNumberInput) { [weak self] success in
            if success {
                self?.showPhoneVerificationScreen.toggle()
            } else {
                self?.errorSendingPhoneAuthCode = true
            }
        }
    }
    
    @Published var phoneNumberHasBeenUsed: Bool? = nil
    func checkPhoneNumber() {
        FirebaseFirestoreService.shared.phoneHasBeenUsed(phoneNumber: phoneNumberInput) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let used):
                self.phoneNumberHasBeenUsed = used
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @Published var showReturningPhoneView = false
    @Published var errorInOtcSubmission = false
    @Published var count: Int? = nil
    func otcSubmitButtonPressed() {
        // Make sure we know if they've used the phone number yet
        // the button is deactivated until we know, so this shouldn't be a problem
        guard let phoneNumberHasBeenUsed = phoneNumberHasBeenUsed else {
            return
        }
        
        FirebaseAuthService.shared.verifyCode(smsCode: otcInput) { [weak self] success in
            guard let self = self else { return }
            if success { // Correct phone code
                if phoneNumberHasBeenUsed { // If it's been used
                    self.showReturningPhoneView = true
                } else { // If it hasn't been used, create a new account for them
                    FirebaseFirestoreService.shared.storePhoneNumber(phoneNumber: self.phoneNumberInput) { result in
                        switch result {
                        case .success(let success):
                            self.count = success
                        case .failure(let failure):
                            print(failure.localizedDescription)
                        }
                    }
                    let (sk, pk) = CryptoService.generateKeyPair()
                    self.publicKey = pk
                    self.privateKey = sk
                    self.isShowingWalletScreen.toggle()
                }
            } else { // Incorrect phone code
                self.errorInOtcSubmission = true
            }
        }
    }
    
    @Published var loadingNewUser = true
    @Published var loadingNewSearchUser = true
    func createNewUser(privateKey: String) {
        guard let publicKey = CryptoService.getPublicKeyString(forPrivateKeyString: privateKey) else { return }
        let user = User(publicKey: publicKey)
        let searchUser = SearchUser(publicKey: publicKey)
        
        FirebaseFirestoreService.shared.storeNewUser(user: user) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success():
                    self.loadingNewUser = false
                case .failure(_):
                    printError()
                }
            }
        }
        FirebaseFirestoreService.shared.storeNewSearchUser(searchUser: searchUser) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success():
                    self.loadingNewSearchUser = false
                case .failure(_):
                    printError()
                }
            }
        }
    }
    
    @Published var finalLoading = false
    func savePrivateKey(privateKey: String) {
        guard let phoneNumberHasBeenUsed = phoneNumberHasBeenUsed else {
            return
        }
        guard let count = count else {
            return
        }
        var rewardAmount = 5000
        rewardAmount = Int(Double(rewardAmount) * pow(0.5, floor(Double(count)/100000)))
        let rewardTransaction = Transaction(id: UUID().uuidString,
                                            fromPublicKey: "",
                                            toPublicKey: self.publicKey,
                                            timeStamp: Date().toLongString(),
                                            amount: rewardAmount,
                                            note: "Welcome to Antion",
                                            signature: "")
        AppViewModel.shared.postPendingTransaction(transaction: rewardTransaction)
        
        finalLoading = true
        // Saving private key
        let _ = KeychainStorage.savePrivateKey(privateKey)
        AppViewModel.shared.privateKey = privateKey
        
        if phoneNumberHasBeenUsed {
            savePrivateKeyWithNoFree(privateKey: privateKey)
        } else {
            // Save user
            guard let publicKey = CryptoService.getPublicKeyString(forPrivateKeyString: privateKey) else {
                return
            }
            let user = User(publicKey: publicKey)
            print(user)
        }
        
    }
    
    func savePrivateKeyWithNoFree(privateKey: String) {
        let _ = KeychainStorage.savePrivateKey(privateKey)
        AppViewModel.shared.privateKey = privateKey
    }
    
}


extension AuthViewModel {
    // Biometric stuff
    
    enum BiometricType {
        case none
        case face
        case touch
    }
    
    func biometricType() -> BiometricType {
        let authContext = LAContext()
        let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch authContext.biometryType {
        case .none:
            return .none
        case .touchID:
            return .touch
        case .faceID:
            return .face
        @unknown default:
            return .none
        }
    }
    
    enum AuthenticationError: Error, LocalizedError, Identifiable {
        case invalidCredentials
        case deniedAccess
        case noFaceIdEnrolled
        case noFingerprintEnrolled
        case biometricError
        case privateKeyNotSaved
        
        var id: String {
            self.localizedDescription
        }
        
        var errorDescription: String? {
            switch self {
            case .invalidCredentials:
                return NSLocalizedString("Your privateKey is incorrect. Please try again", comment: "")
            case .deniedAccess:
                return NSLocalizedString("You have denied access. Please go to the settings app and locate this application and turn Face ID on.", comment: "")
            case .noFaceIdEnrolled:
                return NSLocalizedString("You have not registered any Face IDs yet", comment: "")
            case .noFingerprintEnrolled:
                return NSLocalizedString("You have not registered any fingerprints yet.", comment: "")
            case .biometricError:
                return NSLocalizedString("Your face or fingerprint were not recognized.", comment: "")
            case .privateKeyNotSaved:
                return NSLocalizedString("Your credentials have not been saved. Do you want to save them after the next successful login?", comment: "")
            }
        }
    }
    
    func requestBiometricUnlock(completion: @escaping (Result<String, AuthenticationError>) -> Void) {
        let privateKey: String? = KeychainStorage.getPrivateKey()
        
        guard let privateKey = privateKey else {
            completion(.failure(.privateKeyNotSaved))
            return
        }
        let context = LAContext()
        var error: NSError?
        let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        if let error = error {
            switch error.code {
            case -6:
                completion(.failure(.deniedAccess))
                return
            case -7:
                if context.biometryType == .faceID {
                    completion(.failure(.noFaceIdEnrolled))
                    return
                } else {
                    completion(.failure(.noFingerprintEnrolled))
                    return
                }
            default:
                completion(.failure(.biometricError))
                return
            }
        }
        if canEvaluate {
            if context.biometryType != .none {
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Need to access credentials.") { success, error in
                    DispatchQueue.main.async {
                        if error != nil {
                            completion(.failure(.biometricError))
                            return
                        } else {
                            completion(.success(privateKey))
                            return
                        }
                    }
                }
            }
        }
    }
}
