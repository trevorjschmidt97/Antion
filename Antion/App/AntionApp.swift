//
//  AntionApp.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/18/21.
//

import SwiftUI

@main
struct AntionApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var appViewModel = AppViewModel.shared
    
    init() {
        UINavigationBar.appearance().tintColor = UIColor(AppViewModel.shared.accentColor)
        UITabBar.appearance().backgroundColor = .systemBackground
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appViewModel)
                .onAppear {
                    appViewModel.onAppear()
                }
                .onChange(of: appViewModel.privateKey, perform: { newValue in
                    appViewModel.privateKey = newValue
                    if appViewModel.privateKey != nil {
                        appViewModel.pullUserInfo()
                    }
                })
                .navigationViewStyle(StackNavigationViewStyle())
                .tint(AppViewModel.shared.accentColor)
                .accentColor(AppViewModel.shared.accentColor)
                // Alerts
                .addAlert(alertShown: $appViewModel.successShown, success: true, title: appViewModel.successTitle, subTitle: appViewModel.successMessage, tapToDismiss: true, displayMode: .bannerSlide)
                .addAlert(alertShown: $appViewModel.failureShown, success: false, title: appViewModel.failureTitle, subTitle: appViewModel.failureMessage, tapToDismiss: true, displayMode: .alert)
            
        }
    }
}
