//
//  HelloWorld-Screen.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/25/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct HelloWorld {}

extension HelloWorld {
    struct Screen: View {
        
        let _evaluator: Evaluator
        weak var evaluator: Evaluator?
        let translator: Translator
        
        init() {
            _evaluator = Evaluator()
            evaluator = _evaluator
            translator = _evaluator.translator
        }
        
        @State var navBarHidden: Bool = true
        
        var body: some View {
            ZStack {
                VStack(spacing: 0) {
                    
                    // Count
                    ObservingTextView(translator.helloCount)
                        .font(Font.body.bold().monospacedDigit())
                       .fixedSize(horizontal: false, vertical: true)
                       .padding(EdgeInsets(top: 23, leading: 30, bottom: 50, trailing: 30))
                    
                    // Bubble
                    Hideable(isShowing: translator.shouldShowBubble, transition: AnyTransition.scale(scale: 0.5, anchor: .center).combined(with: AnyTransition.opacity)) {
                        ZStack {
                            Image(systemName: "bubble.right")
                                .resizable()
                                .font(Font.system(size: 12, weight: .light))
                                .frame(width: 170, height: 170)
                            
                            ObservingTextView(self.translator.bubbleText, kerning: -0.5)
                                .font(Font.system(size: 22, weight: .semibold))
                                .offset(y: -12)
                        }
                    }
                    
                    Spacer()
                }
                
                // Bottom Button
                ObservingBottomButton(obsevableNamedAction: translator.buttonAction, evaluator: evaluator)
                
                // Dismiss Button
                VStack {
                    DismissButton(orientation: .right)
                    Spacer()
                }
            }.onAppear {
                self.evaluator?.viewDidAppear()
                self.navBarHidden = true
            }
                
            // MARK: Hide Navigation Bar
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                self.navBarHidden = true
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(self.navBarHidden)
        }
    }
}
