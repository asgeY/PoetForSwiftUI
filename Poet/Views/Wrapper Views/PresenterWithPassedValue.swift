//
//  PresenterWithPassedValue.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/23/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct PresenterWithPassedValue<PassedType, Content>: View where Content : View {
    let passable: Passable<PassedType>
    var content: (PassedType) -> Content
    
    @State var passedValue: PassedType?
    @State var isShowing: Bool = false
    
    init(_ passable: Passable<PassedType>, @ViewBuilder content: @escaping (PassedType) -> Content) {
        self.passable = passable
        self.content = content
    }
    
    var body: some View {
        Spacer()
            .sheet(isPresented: self.$isShowing) {
                if self.passedValue != nil {
                    self.content(self.passedValue!)
                } else {
                    EmptyView()
                }
            }
            .onReceive(passable.subject) { value in
                self.passedValue = value
                self.isShowing = true
            }
    }
}
