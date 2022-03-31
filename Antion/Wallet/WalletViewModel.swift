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
    }
    
    // Signed in user is self, shown friend is other
    func cancelFriendRequest(selfFriend: Friend, otherFriend: Friend) {
        FirebaseFirestoreService.shared.cancelFriendRequest(selfFriend: selfFriend, otherFriend: otherFriend)
    }
    
    // Signed in user is self, shown friend is other
    func acceptFriendRequest(selfFriend: Friend, otherFriend: Friend) {
        FirebaseFirestoreService.shared.acceptFriendRequest(selfFriend: selfFriend, otherFriend: otherFriend)
    }
    
    // Signed in user is self, shown friend is other
    func rejectFriendRequest(selfFriend: Friend, otherFriend: Friend) {
        FirebaseFirestoreService.shared.rejectFriendRequest(selfFriend: selfFriend, otherFriend: otherFriend)
    }
    
    // Signed in user is self, shown friend is other
    func unfriend(selfFriend: Friend, otherFriend: Friend) {
        AppViewModel.shared.user.removeFriend(friendPublicKey: otherFriend.publicKey)
        FirebaseFirestoreService.shared.unfriend(selfFriend: selfFriend, otherFriend: otherFriend)
    }
    
    func updateName(newName: String) {
        FirebaseFirestoreService.shared.updateName(publicKey: user.publicKey,
                                                   previousName: user.name,
                                                   name: newName,
                                                   profilePicUrl: user.profilePicUrl,
                                                   friendsPublicKeys: AppViewModel.shared.user.friends.map{$0.publicKey},
                                                   selfRequested: AppViewModel.shared.user.selfRequestedFriends.map{$0.publicKey},
                                                   otherRequested: AppViewModel.shared.user.otherRequestedFriends.map{$0.publicKey})
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
            guard let self = self else { return }
            switch storageResult {
            case .success(let url):
                FirebaseFirestoreService.shared.updateProfilePicUrl(publicKey: self.user.publicKey,
                                                                    name: self.user.name,
                                                                    previousProfilePicUrl: self.user.profilePicUrl,
                                                                    profilePicUrl: url,
                                                                    friendsPublicKeys: AppViewModel.shared.user.friends.map{$0.publicKey},
                                                                    selfRequested: AppViewModel.shared.user.selfRequestedFriends.map{$0.publicKey},
                                                                    otherRequested: AppViewModel.shared.user.otherRequestedFriends.map{$0.publicKey})
                print(url)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
