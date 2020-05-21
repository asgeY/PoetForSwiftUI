//
//  Presenter.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/21/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct Presenter<Content>: View where Content : View {
    let passablePlease: PassablePlease
    var content: () -> Content
    @State var isShowing: Bool = false
       
    init(_ passablePlease: PassablePlease, @ViewBuilder content: @escaping () -> Content) {
        self.passablePlease = passablePlease
        self.content = content
    }
    
    var body: some View {
        Spacer()
            .sheet(isPresented: self.$isShowing) {
                self.content()
            }
            .onReceive(passablePlease.subject) { _ in
                self.isShowing = true
            }
    }
}
