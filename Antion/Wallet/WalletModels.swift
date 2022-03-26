//
//  WalletFirestoreService.swift
//  Antion
//
//  Created by Trevor Schmidt on 3/10/22.
//

import Foundation

enum WalletState {
    case own
    case friends
    case selfRequested
    case otherRequested
    case stranger
    
    var buttonText: String {
        switch self {
        case .own:
            return ""
        case .friends:
            return "Friends"
        case .selfRequested:
            return "Friend Request Sent"
        case .otherRequested:
            return "Friend Request Received"
        case .stranger:
            return "Send Friend Request?"
        }
    }
    
    var imageName: String {
        switch self {
        case .own:
            return ""
        case .friends:
            return "person.crop.circle.badge.checkmark"
        case .selfRequested:
            return "person.crop.circle.badge.clock"
        case .otherRequested:
            return "person.crop.circle.badge.clock"
        case .stranger:
            return "person.crop.circle.badge.plus"
        }
    }
}
