//
//  BackButton.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/21/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct BackButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        HStack {
            Button(
                action: {
                    self.presentationMode.wrappedValue.dismiss()
            })
            {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color.primary)
                    .padding(EdgeInsets.init(top: 16, leading: 24, bottom: 16, trailing: 24))
            }
            
            Spacer()
        }
    }
}
