//
//  DismissReceiver.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/21/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct DismissReceiver: View {
    var translator: DismissTranslator
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        Spacer().frame(width: 0.5, height: 0.5)
            .onReceive(translator.dismiss.subject) { _ in
                self.presentationMode.wrappedValue.dismiss()
        }
    }
}
