//
//  SuccessAlertViewModifier.swift
//  Antion
//
//  Created by Trevor Schmidt on 4/5/22.
//

import Foundation
import SwiftUI
import AlertToast

struct AlertViewModifier: ViewModifier {

    @Binding var alertShown: Bool
    var success: Bool
    var title: String?
    var subTitle: String?
    var duration: Double = 1.5
    var tapToDismiss: Bool = true
    var displayMode: DisplayMode
    var onTap: (() -> ())?
    
    var alertToastDisplayMode: AlertToast.DisplayMode {
        switch displayMode {
        case .alert:
            return .alert
        case .hud:
            return .hud
        case .bannerPop:
            return .banner(.pop)
        case .bannerSlide:
            return .banner(.slide)
        }
    }
    
    enum DisplayMode {
        case alert
        case bannerPop
        case bannerSlide
        case hud
    }
    
    func body(content: Content) -> some View {
        content
            .toast(isPresenting: $alertShown,
                   duration: duration,
                   tapToDismiss: tapToDismiss,
                   offsetY: 0.0,
                   alert: {
                        AlertToast(displayMode: alertToastDisplayMode,
                                   type: success ? .complete(.green) : .error(.red),
                                   title: title,
                                   subTitle: subTitle,
                                   style: nil)
                    },
                   onTap: onTap,
                   completion: nil)
        
    }
    
}

extension View {
    func addAlert(alertShown: Binding<Bool>, success: Bool, title: String?, subTitle: String?, duration: Double=1.5, tapToDismiss: Bool, displayMode: AlertViewModifier.DisplayMode, onTap: (() -> ())?=nil) -> some View {
        modifier(AlertViewModifier(alertShown: alertShown,
                                   success: success,
                                   title: title,
                                   subTitle: subTitle,
                                   duration: duration,
                                   tapToDismiss: tapToDismiss,
                                   displayMode: displayMode,
                                   onTap: onTap))
    }
}
