//
//  AppViewModel.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/18/21.
//

import Foundation
import SwiftUI
import AlertToast

class AppViewModel: ObservableObject {
    private init() { }
    static let shared = AppViewModel()
        
    // MARK: Auth
    @Published var privateKey: String?
    var publicKey: String {
        CryptoService.getPublicKeyString(forPrivateKeyString: privateKey ?? "") ?? ""
    }
    
    func signOut() {
        name = ""
        profilePicUrl = ""
        privateKey = nil
        loadingUserInfo = true
    }
    
    // MARK: UserInfo
    @Published var loadingUserInfo = true
    @Published var userInfo: User = exampleUser
    @AppStorage("userName") var name = "Anonymous"
    @AppStorage("userProfilePicUrl") var profilePicUrl = ""
    
    func pullUserInfo() {
        guard publicKey != "" else { return }
        FirebaseFirestoreService.shared.fetchUserInfo(publicKey: publicKey.slashToDash()) { [weak self] result in
            DispatchQueue.main.async {
                if let result = result {
                    self?.userInfo = result            
                }
                self?.loadingUserInfo = false
            }
        }
    }
    
    // MARK: Color
    @AppStorage("accentColorString") var accentColorString = "red" {
        didSet {
            UINavigationBar.appearance().tintColor = UIColor(AppViewModel.shared.accentColor)
        }
    }
    
    var accentColor: Color {
        switch accentColorString {
        case "blue": return Color.blue
        case "brown": return Color.brown
        case "cyan": return Color.cyan
        case "green": return Color.green
        case "orange": return Color.orange
        case "purple": return Color.purple
        case "red": return Color.red
        case "yellow": return Color.yellow
        default: return Color.green
        }
    }
    var accentColorHex: String {
        switch accentColorString {
        case "blue": return "#007aff"
        case "brown": return "#a2845e"
        case "cyan": return "#32ade6"
        case "green": return "#34c759"
        case "orange": return "#ff9500"
        case "purple": return "#af52de"
        case "red": return "#ff3b30"
        case "yellow": return "#ffcc00"
        default: return "#34c759"
        }
    }
    
    // MARK: Alerts
    @Published var successShown = false
    @Published var successTitle: String?
    @Published var successMessage: String?
    @Published var successDisplayMode: AlertToast.DisplayMode = .alert
    
    @Published var failureShown = false
    @Published var failureTitle: String?
    @Published var failureMessage: String?
    @Published var failureDisplayMode: AlertToast.DisplayMode = .alert
    
    func showSuccess(title: String, message: String?, displayMode: AlertToast.DisplayMode) {
        successTitle = title
        successMessage = message
        successShown = true
        successDisplayMode = displayMode
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.successShown = false
        }
    }
    
    func showFailure(title: String, message: String?, displayMode: AlertToast.DisplayMode) {
        failureTitle = title
        failureMessage = message
        failureDisplayMode = displayMode
        failureShown = true
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.failureShown = false
        }
    }
    
}
