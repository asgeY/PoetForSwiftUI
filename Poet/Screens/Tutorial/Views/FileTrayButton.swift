//
//  FileTrayButton.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/23/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct FileTrayButton<E: ActionEvaluating>: View {
    @ObservedObject var isShowing: ObservableBool
    let transition: AnyTransition
    let evaluator: E
    let action: E.Action?
    
    var body: some View {
        Hideable(isShowing: isShowing, transition: transition) {
            Button(action: {
                self.evaluator.evaluate(self.action)
            }) {
                HStack {
                    Image(systemName: "rectangle.and.paperclip")
                        .font(Font.system(size: 18, weight: .regular))
                        .zIndex(4)
                        .transition(.scale)
                        .frame(width: 40, height: 40)
                }
            }.zIndex(4)
        }
        .frame(height: 40)
        .padding(.trailing, Device.current == .small ? 24 : 28)
        .foregroundColor(.primary)
    }
}
