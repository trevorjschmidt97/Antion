//
//  AuthViewModel.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/18/21.
//

import Foundation
import LocalAuthentication

class AuthViewModel: ObservableObject {
    
    @Published var phoneNumberInput = "+1"
    @Published var privateKeyInput = ""
    @Published var otcInput = ""
    
    @Published var isShowingVerificationScreen = false
    @Published var isShowingWalletScreen = false
    
    enum BiometricType {
        case none
        case face
        case touch
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
    
    
    func continueButtonPressed() {
        FirebaseAuthService.shared.startAuth(phoneNumber: phoneNumberInput) { [weak self] success in
            if success {
                self?.isShowingVerificationScreen.toggle()
            } else {
                print("Unable to send verification")
//                AppViewModel.shared.showFailure(title: "Error", message: "Unable to send verification", displayMode: .alert)
            }
        }
    }
    
    func otcSubmitButtonPressed() {
        FirebaseAuthService.shared.verifyCode(smsCode: otcInput) { [weak self] success in
            if success {
                self?.isShowingWalletScreen.toggle()
            } else {
                print("otc verify code error")
//                AppViewModel.shared.showFailure(title: "Oops", message: nil, displayMode: .alert)
            }
        }
    }
    
    func savePrivateKey(privateKey: String) {
        let _ = KeychainStorage.savePrivateKey(privateKey)
        AppViewModel.shared.privateKey = privateKey
    }
    
    func pullPrivateKeyButtonPressed() {
        requestBiometricUnlock { [weak self] result in
            switch result {
            case .success(let privateKey):
                self?.privateKeyInput = privateKey
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func signInButtonPressed() {
        if let privateKey = CryptoService.generatePrivateKeyString(fromString: privateKeyInput) {
            let _ = KeychainStorage.savePrivateKey(privateKey)
            AppViewModel.shared.privateKey = privateKey
        } else {
            print("Invalid private key")
//            AppViewModel.shared.showFailure(title: "Whoops", message: "Invalid Private Key", displayMode: .hud)
        }
    }
    
}
