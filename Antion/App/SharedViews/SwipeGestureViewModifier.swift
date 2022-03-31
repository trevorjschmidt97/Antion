//
//  SwipeGestureViewModifier.swift
//  Antion
//
//  Created by Trevor Schmidt on 3/29/22.
//

import SwiftUI

struct SwipeGestureViewModifier: ViewModifier {

    var leftToRight: () -> Void
    var rightToLeft: () -> Void
    
    func body(content: Content) -> some View {
        content
            .highPriorityGesture(DragGesture(minimumDistance: 25, coordinateSpace: .local)
                .onEnded { value in
                    if abs(value.translation.height) < abs(value.translation.width) {
                        if abs(value.translation.width) > 50.0 {
                            if value.translation.width < 0 {
                                rightToLeft()
                            } else if value.translation.width > 0 {
                                leftToRight()
                            }
                        }
                    }
                })
    }
    
}

extension View {
    func addSwipeGesture(leftToRight: @escaping () -> Void, rightToLeft: @escaping () -> Void) -> some View {
        modifier(SwipeGestureViewModifier(leftToRight: leftToRight, rightToLeft: rightToLeft))
    }
}
