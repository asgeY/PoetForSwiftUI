//
//  BiggerTutorial-Screen.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/24/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct BiggerTutorial {}

extension BiggerTutorial {
    struct Screen: View {
        let _evaluator: BiggerTutorial.Evaluator
        weak var evaluator: BiggerTutorial.Evaluator?
        let translator: BiggerTutorial.Translator
        
        init() {
            debugPrint("init BiggerTutorial Screen")
            _evaluator = Evaluator()
            evaluator = _evaluator
            translator = _evaluator.translator
        }
        
        @State var navBarHidden: Bool = true
        
        var body: some View {
            
            ZStack {
                ZStack {
                    VStack {
                        BackButton()
                        Spacer()
                    }
                    
                    VStack {
                        Spacer().frame(height:12)
                        
                        // MARK: Tappable Screen Title
                        ButtonActionView(
                            action: evaluator?.titleAction,
                            content:
                                AnyView(
                                Text("A Paging Tutorial")
                                    .font(Font.subheadline.monospacedDigit().bold())
                                    .multilineTextAlignment(.center)
                                    .layoutPriority(10)
                                    .foregroundColor(Color.primary)
                                )
                        )
                        .layoutPriority(10)
                        
                        Spacer().frame(height:18)
                        
                        // MARK: Page Body
                        withAnimation(.none) {
                            PageBodyView(pageBody: self.translator.pageBody)
                                .layoutPriority(10)
                        }
                        
                        Spacer()
                            .layoutPriority(1)
                    }
                }.gesture(DragGesture()
                    .onChanged { value in
                    }
                    .onEnded { value in
                        if value.translation.width < -50 {
                            self.evaluator?.rightAction()
                        } else if value.translation.width > 50 {
                            self.evaluator?.leftAction()
                        }
                    }
                )
                
                // MARK: Left and Right Buttons
                LeftAndRightButtonView(
                    leftAction: self.evaluator?.leftAction,
                    rightAction: self.evaluator?.rightAction,
                    leftButtonIsEnabled: self.translator.isLeftButtonEnabled,
                    rightButtonIsEnabled: self.translator.isRightButtonEnabled)
                
                // MARK: Character Bezel
                CharacterBezel(
                    passableCharacter: translator.bezelTranslator.character)
                    .allowsHitTesting(false)
                
                // MARK: Page Number
                VStack {
                    Spacer()
                        .allowsHitTesting(false)
                    TappableTextCapsuleView(
                        action: evaluator?.pageNumberAction,
                        text: translator.pageXofX)
                        .foregroundColor(Color.primary)
                    Spacer().frame(height: 10)
                        .allowsHitTesting(false)
                }
                
                // MARK: Alert View
                AlertView(
                    title: translator.alertTranslator.alertTitle,
                    message: translator.alertTranslator.alertMessage,
                    primaryAlertAction: translator.alertTranslator.primaryAlertAction,
                    secondaryAlertAction: translator.alertTranslator.secondaryAlertAction,
                    isPresented: translator.alertTranslator.isAlertPresented)
            }
                
            // MARK: ViewCycle
            .onAppear {
                self.navBarHidden = true
                self.evaluator?.viewDidAppear()
                UITableView.appearance().separatorColor = .clear
            }
            
            // MARK: Hide Navigation Bar
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                self.navBarHidden = true
            }.onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                self.navBarHidden = false
            }
            .navigationBarTitle("BiggerTutorial", displayMode: .inline)
                .navigationBarHidden(self.navBarHidden)
        }
    }
}

struct BiggerTutorial_Screen_Previews: PreviewProvider {
    static var previews: some View {
        BiggerTutorial.Screen()
    }
}
