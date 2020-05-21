//
//  Fadeable.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/21/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct Fadeable<Content>: View where Content : View {
    @State var isShowing: Bool = false
    var content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        content()
            .opacity(isShowing ? 1 : 0)
            .onDisappear() {
                withAnimation(Animation.linear(duration: 0.3)) {
                    self.isShowing = false
                }
        }
            .onAppear() {
                withAnimation(Animation.linear(duration: 0.3).delay(0.45)) {
                    self.isShowing = true
                }
        }
    }
}
