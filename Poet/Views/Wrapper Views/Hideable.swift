//
//  Hideable.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/21/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct Hideable<Content>: View where Content : View {
    @ObservedObject var isShowing: ObservableBool
    let removesContent: Bool
    var transition: AnyTransition?
    var content: () -> Content
    
    /**
     Set removesContent to false to allow a view to maintain its full size as it fades away.
     In most cases, you'll want removesContent to be true.
     */
    init(isShowing: ObservableBool, removesContent: Bool = true, transition: AnyTransition? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.isShowing = isShowing
        self.removesContent = removesContent
        self.transition = transition
        self.content = content
    }
    
    var body: some View {
        Group {
            if removesContent {
                if isShowing.bool {
                    Group {
                        if transition != nil {
                            content()
                                .transition(transition!)
                        } else {
                            content()
                        }
                    }
                }
            } else {
                if transition != nil {
                    content()
                        .opacity(isShowing.bool ? 1 : 0)
                        .transition(transition!)
                } else {
                    content()
                    .opacity(isShowing.bool ? 1 : 0)
                }
            }
        }
    }
}
