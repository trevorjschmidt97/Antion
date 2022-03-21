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
    @Published var confirmedTransactions: [Transaction] = []
    @Published var pendingTransactions: [Transaction] = []
    
    var inputImage: UIImage?
    
    var walletState: WalletState {
        if user.publicKey == AppViewModel.shared.publicKey {
            return .own
        } else if AppViewModel.shared.user.friendsSet.contains(user.publicKey) {
            return .friends
        } else if AppViewModel.shared.user.selfRequestedFriendsSet.contains(user.publicKey) {
            return .selfRequested
        } else if AppViewModel.shared.user.otherRequestedFriendsSet.contains(user.publicKey) {
            return .otherRequested
        }
        return .stranger
    }
    
    init(user: User) {
        self.user = user
        
        FirebaseFirestoreService.shared.fetchWalletInfo(publicKey: user.publicKey) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let retUser):
                    withAnimation {
                        self.user = retUser
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    // Signed in user is self, shown friend is other
    func sendFriendRequest() {
        let selfFriend = Friend(publicKey: AppViewModel.shared.user.publicKey, name: AppViewModel.shared.user.name, profilePicUrl: AppViewModel.shared.user.profilePicUrl)
        let otherFriend = Friend(publicKey: user.publicKey, name: user.name, profilePicUrl: user.profilePicUrl)
        FirebaseFirestoreService.shared.sendFriendRequest(selfFriend: selfFriend, otherFriend: otherFriend)
//        walletState = .selfRequested
    }
    
    // Signed in user is self, shown friend is other
    func cancelFriendRequest() {
        let selfPublicKey = AppViewModel.shared.publicKey
        let otherPublicKey = user.publicKey
        
        
    }
    
    func acceptFriendRequest() {
        
    }
    
    func rejectFriendRequest() {
        
    }
    
    func unfriend() {
        
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
