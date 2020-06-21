//
//  DismissReceiver.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/21/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct DismissReceiver: View {
    var passablePlease: PassablePlease
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    init(_ passablePlease: PassablePlease) {
        self.passablePlease = passablePlease
    }
    
    var body: some View {
        Spacer().frame(width: .leastNonzeroMagnitude, height: .leastNonzeroMagnitude)
            .onReceive(passablePlease.subject) { _ in
                self.presentationMode.wrappedValue.dismiss()
            }
    }
}
