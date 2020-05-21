//
//  DismissButton.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/21/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct DismissButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let foregroundColor: Color?
    
    init(foregroundColor: Color? = nil) {
        self.foregroundColor = foregroundColor
    }
    
    var body: some View {
        HStack {
            Spacer()
            Button(
                action: {
                    self.presentationMode.wrappedValue.dismiss()
            })
            {
                Image(systemName: "xmark")
                    .foregroundColor(foregroundColor ?? Color.primary)
                    .padding(EdgeInsets(top: 26, leading: 24, bottom: 24, trailing: 24))
                    .font(Font.system(size: 18, weight: .medium))
            }
        }
    }
}
