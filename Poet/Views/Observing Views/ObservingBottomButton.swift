//
//  ButtomButton.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/21/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct ObservingBottomButton: View {
    @ObservedObject var observableNamedEnabledAction: ObservableNamedEnabledEvaluatorAction
    let evaluator: ActionEvaluating
    
    @ObservedObject private var keyboard = KeyboardResponder()
    
    var body: some View {
        GeometryReader() { geometry in
            VStack {
                Spacer()
                Button(action: {
                    self.evaluator.evaluate(self.observableNamedEnabledAction.namedEnabledAction?.action)
                }) {
                        
                    Text(
                        self.observableNamedEnabledAction.namedEnabledAction?.name ?? "")
                        .animation(.none)
                        .font(Font.headline)
                        .foregroundColor(Color(UIColor.systemBackground))
                        .frame(width: geometry.size.width - 100)
                        .padding(EdgeInsets(top: 16, leading: 18, bottom: 16, trailing: 18))
                        .background(
                            ZStack {
                                BlurView()
                                Rectangle()
                                    .fill(Color.primary.opacity(0.95))
                            }
                            .mask(
                                Capsule()
                            )
                    )
                }
                .disabled(self.observableNamedEnabledAction.namedEnabledAction?.enabled == false)
            }
            
            .opacity(
                self.observableNamedEnabledAction.namedEnabledAction?.action == nil ? 0 : 1
            )
            .offset(x: 0, y: self.observableNamedEnabledAction.namedEnabledAction?.action == nil ? 150 : 0)
                .offset(x: 0, y: -self.keyboard.currentHeight)
                .animation(.spring(response: 0.35, dampingFraction: 0.7, blendDuration: 0), value: self.observableNamedEnabledAction.namedEnabledAction?.action == nil)
                .animation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0), value: self.keyboard.currentHeight == 0)
        }
    }
}
