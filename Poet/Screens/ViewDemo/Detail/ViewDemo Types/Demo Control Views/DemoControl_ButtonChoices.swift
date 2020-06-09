//
//  DemoControl_ButtonChoices.swift
//  Poet
//
//  Created by Stephen E. Cotner on 6/8/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct DemoControl_ButtonChoices<T>: View where T: Equatable {
    let buttons: [NamedIdentifiedValue<T>]
    @ObservedObject var preference: Observable<T>
    
    var body: some View {
        return ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                Spacer().frame(width: 50)
                ForEach(buttons, id: \.id) { button in
                    Button(action: {
                        self.preference.value = button.value
                    }) {
                        Text(button.title)
                            .padding(EdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14))
                            .overlay(
                                Capsule()
                                    .fill(
                                        self.capsuleFill(matching: button)
                                    )
                            )
                    }
                }
                Spacer()
            }
        }
        .font(Font.caption.bold())
        .foregroundColor(.primary)
    }
    
    func capsuleFill(matching namedIdentifiedValue: NamedIdentifiedValue<T>) -> Color {
        if namedIdentifiedValue.value == preference.value {
            return Color.primary.opacity(0.2)
        } else {
            return Color.primary.opacity(0.06)
        }
    }
}
