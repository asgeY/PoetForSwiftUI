//
//  ButtomButton.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/21/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct ObservingBottomButton: View {
    @ObservedObject var obsevableNamedAction: ObservableNamedEvaluatorAction
    weak var evaluator: ActionEvaluating?
    
    var body: some View {
        GeometryReader() { geometry in
            VStack {
                Spacer()
                Button(action: {
                    self.evaluator?.evaluate(self.obsevableNamedAction.namedAction?.action)
                }) {
                        
                    Text(
                        self.obsevableNamedAction.namedAction?.name ?? "")
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
            }
            
            .opacity(
                self.obsevableNamedAction.namedAction?.action == nil ? 0 : 1
            )
            .offset(x: 0, y: self.obsevableNamedAction.namedAction?.action == nil ? 150 : 0)
                .animation(.spring(response: 0.35, dampingFraction: 0.7, blendDuration: 0), value: self.obsevableNamedAction.namedAction?.action == nil)
        }
    }
}
