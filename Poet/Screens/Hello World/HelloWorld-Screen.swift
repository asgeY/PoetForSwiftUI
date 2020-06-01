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
        
        let evaluator: Evaluator
        let translator: Translator
        
        init() {
            evaluator = Evaluator()
            translator = evaluator.translator
        }
        
        @State var navBarHidden: Bool = true
        
        var body: some View {
            ZStack {
                
                // Bubble and person
                GeometryReader() { geometry in
                    ZStack {
                        
                        // Sky
                        Rectangle()
                            .fill(Color(UIColor.systemTeal).opacity(0.9))
                            .frame(width: geometry.size.width, height: geometry.size.height / 2.0)
                            .offset(x: 0, y: -geometry.size.height / 4.0)
                        
                        // Person
                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .offset(x: 80, y: -19)
                        
                        // Grass
                        Rectangle()
                            .fill(Color.white)
//                            .fill(Color(UIColor(red: 96/255.0, green: 225/255.0, blue: 96/255.0, alpha: 1)))
                            .frame(width: geometry.size.width, height: geometry.size.height / 2.0)
                            .offset(x: 0, y: geometry.size.height / 4.0)
                        
                        
                        // Bubble
                        ZStack {
                            Hideable(isShowing: self.translator.shouldShowBubble, transition: AnyTransition.scale(scale: 0, anchor: .init(x: 0.85, y: 1.2)).combined(with: AnyTransition.opacity)) {
                                ZStack {
                                    Rectangle()
                                        .fill(Color.white)
                                        .mask(
                                            Image(systemName: "bubble.right.fill")
                                            .resizable()
                                            .font(Font.system(size: 12, weight: .light))
                                            .frame(width: 168, height: 168)
                                    ).frame(width: 168, height: 168)
                                    
                                    Image(systemName: "bubble.right")
                                        .resizable()
                                        .font(Font.system(size: 12, weight: .light))
                                        .frame(width: 170, height: 170)
                                    
                                    ObservingTextView(self.translator.bubbleText, kerning: -0.5)
                                        .font(Font.system(size: 22, weight: .semibold))
                                        .offset(y: -12)
                                }
                            }
                        }.offset(x: 0, y: -144)
                    }
                }.edgesIgnoringSafeArea([.bottom, .top])
                
                // Count
                VStack(alignment: .leading, spacing: 0) {
                    Spacer().frame(height: 23)
                    
                    ObservingTextView(translator.helloCount)
                        .font(Font.body.bold().monospacedDigit())
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                }
                
                // Bottom Button
                ObservingBottomButton(observableNamedEnabledAction: translator.buttonAction, evaluator: evaluator)
                
                // Dismiss Button
                VStack {
                    DismissButton(orientation: .right)
                    Spacer()
                }
            }.onAppear {
                self.evaluator.viewDidAppear()
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
