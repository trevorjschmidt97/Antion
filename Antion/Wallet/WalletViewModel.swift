//
//  ProfileViewModel.swift
//  Antion
//
//  Created by Trevor Schmidt on 1/20/22.
//

import Foundation
import SwiftUI

class WalletViewModel: ObservableObject {
    
    @Published var user: User
    @Published var confirmedTransactions: [ConfirmedTransaction] = []
    @Published var pendingTransactions: [PendingTransaction] = []
    @Published var receivedRequestedTransactions: [RequestedTransaction] = []
    @Published var sendRequestedTransactions: [RequestedTransaction] = []
    
    @Published var acquaintances: [Friend] = []
    
    var inputImage: UIImage?
    
    init(user: User) {
        self.user = user
    }
    
    func onAppear() {
        FirebaseFirestoreService.shared.fetchUserInfo(publicKey: user.publicKey) { [weak self] retUser in
            DispatchQueue.main.async {
                if let retUser = retUser {
                    if retUser.publicKey == AppViewModel.shared.publicKey {
                        AppViewModel.shared.name = retUser.name
                        AppViewModel.shared.profilePicUrl = retUser.profilePicUrl
                    }
                    self?.user = retUser
                }
            }
        }
//        FirebaseFirestoreService.shared.getFriends(forPublicKey: user.publicKey) { [weak self] retAcquaintances in
//            DispatchQueue.main.async {
//                self?.acquaintances = retAcquaintances
//            }
////        }
//        FirebaseFirestoreService.shared.getPendingTransactions(forPublicKey: user.publicKey) { [weak self] retPendingTransactions in
//            DispatchQueue.main.async {
//                self?.pendingTransactions = retPendingTransactions
//            }
//        }
//        FirebaseFirestoreService.shared.getConfirmedTransactions(forPublicKey: user.publicKey) { [weak self] retConfirmedTransactions in
//            DispatchQueue.main.async {
//                self?.confirmedTransactions = retConfirmedTransactions
//            }
//        }
//        FirebaseFirestoreService.shared.getReceivedRequestedTransactions(forPublicKey: user.publicKey) { [weak self] retReceivedRequestedTransactions in
//            DispatchQueue.main.async {
//                self?.receivedRequestedTransactions = retReceivedRequestedTransactions
//            }
//        }
//        FirebaseFirestoreService.shared.getSentRequestedTransactions(forPublicKey: user.publicKey) { [weak self] retSentRequestedTransactions in
//            DispatchQueue.main.async {
//                self?.sendRequestedTransactions = retSentRequestedTransactions
//            }
//        }
    }
    
    func addFriendButtonPressed() {
        
    }
    
    func updateProfilePicture() {
        guard let image = inputImage else {
            print("no image selected")
            return
        }
        guard let imageData = image.jpegData(compressionQuality: 0.2) else {
            print("error getting image data")
            return
        }
        
        FirebaseStorageService.shared.updateProfilePic(publicKey: user.publicKey, imageData: imageData) { [weak self] storageResult in
            switch storageResult {
            case .success(let url):
                DispatchQueue.main.async {
                    self?.user.profilePicUrl = url
                }
                print(url)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
