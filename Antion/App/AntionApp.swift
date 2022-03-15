//
//  AntionApp.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/18/21.
//

import SwiftUI
import AlertToast

public func printError(file: String = #file, function: String = #function, line: Int = #line ) {
    print("Error in\nfile: \(file)\nfunction: \(function)\nline: \(line)")
}

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
                .navigationViewStyle(StackNavigationViewStyle())
                .tint(AppViewModel.shared.accentColor)
                .accentColor(AppViewModel.shared.accentColor)
                // Alerts
                    // Success
                .toast(isPresenting: $appViewModel.successShown,
                       duration: 1.5,
                       tapToDismiss: true,
                       offsetY: 0.0,
                       alert: {
                            AlertToast(displayMode: appViewModel.successDisplayMode,
                                       type: .complete(.green),
                                       title: appViewModel.successTitle,
                                       subTitle: appViewModel.successMessage,
                                       style: nil)
                        },
                       onTap: nil,
                       completion: nil)
                    // Failure
                .toast(isPresenting: $appViewModel.failureShown,
                       duration: 1.5,
                       tapToDismiss: true,
                       offsetY: 0.0,
                       alert: {
                            AlertToast(displayMode: appViewModel.failureDisplayMode,
                                       type: .error(.red),
                                       title: appViewModel.failureTitle,
                                       subTitle: appViewModel.failureMessage,
                                       style: nil)
                        },
                       onTap: nil,
                       completion: nil)
                
        }
    }
}
