//
//  PresenterWithString.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/23/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct PresenterWithString<Content>: View where Content : View {
    let passableString: PassableString
    var content: (String) -> Content
    
    @State var string: String = ""
    @State var isShowing: Bool = false
    
    init(_ passableString: PassableString, @ViewBuilder content: @escaping (String) -> Content) {
        self.passableString = passableString
        self.content = content
    }
    
    var body: some View {
        Spacer()
            .sheet(isPresented: self.$isShowing) {
                self.content(self.string)
            }
            .onReceive(passableString.subject) { string in
                if let string = string {
                    self.string = string
                }
                self.isShowing = true
            }
    }
}
