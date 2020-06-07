//
//  DemoControl_TextAlignment.swift
//  Poet
//
//  Created by Steve Cotner on 6/6/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct DemoControl_TextAlignment: View {
    @ObservedObject var observable: Observable<TextAlignment>
    
    var body: some View {
        HStack {
            Spacer().frame(width: 50)
            Button(action: {
                self.observable.value = TextAlignment.leading
            }) {
                Text("Leading")
                    .padding(EdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14))
                    .overlay(
                        Capsule()
                            .fill(
                                CapsuleFill(matching: .leading)
                            )
                    )
            }
            
            Button(action: {
                self.observable.value = TextAlignment.center
            }) {
                Text("Center")
                    .padding(EdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14))
                    .overlay(
                        Capsule()
                            .fill(
                                CapsuleFill(matching: .center)
                            )
                    )
            }
            
            Button(action: {
                self.observable.value = TextAlignment.trailing
            }) {
                Text("Trailing")
                    .padding(EdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14))
                    .overlay(
                        Capsule()
                            .fill(
                                CapsuleFill(matching: .trailing)
                            )
                    )
            }
            
            Spacer()
        }
        .font(Font.caption.bold())
        .foregroundColor(.primary)
    }
    
    func CapsuleFill(matching alignment: TextAlignment) -> Color {
        if case self.observable.value = alignment {
            return Color.primary.opacity(0.2)
        } else {
            return Color.primary.opacity(0.06)
        }
    }
}
