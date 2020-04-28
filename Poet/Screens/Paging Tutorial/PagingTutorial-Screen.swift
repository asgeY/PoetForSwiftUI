//
//  PagingTutorial-Screen.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/24/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct PagingTutorial {}

extension PagingTutorial {
    struct Screen: View {
        let _evaluator: PagingTutorial.Evaluator
        weak var evaluator: PagingTutorial.Evaluator?
        let translator: PagingTutorial.Translator
        
        init() {
            debugPrint("init PagingTutorial Screen")
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
                        Spacer().frame(height:10)
                        
                        // MARK: Tappable Screen Title
                        ButtonActionView(
                            action: evaluator?.titleAction,
                            content:
                                AnyView(
                                Text("The Poet Pattern\nfor SwiftUI")
                                    .font(Font.caption.monospacedDigit().bold())
                                    .layoutPriority(10)
                                    .multilineTextAlignment(.center)
                                )
                        )
                        .layoutPriority(10)
                        
                        Spacer().frame(height:20)
                        
//                        // MARK: Tappable Page Title
//                        ButtonActionView(
//                            action: evaluator?.titleAction,
//                            content:
//                                AnyView(
//                                    ObservingTextView(
//                                        text: translator.pageTitle,
//                                        font: Font.headline.monospacedDigit(),
//                                        alignment: .center)
//                                        .layoutPriority(10)
//                                )
//                        )
//                        Spacer().frame(height:16)
                        
                        // MARK: Page Body
                        PageBodyView(pageBody: self.translator.pageBody)
                            .layoutPriority(10)
                        
                        Spacer()
                            .layoutPriority(1)
                    }
                }
                
                // MARK: Left and Right Buttons
                LeftAndRightButtonView(
                    leftAction: self.evaluator?.leftAction,
                    rightAction: self.evaluator?.rightAction,
                    leftButtonIsEnabled: self.translator.isLeftButtonEnabled,
                    rightButtonIsEnabled: self.translator.isRightButtonEnabled)
                
                // MARK: Character Bezel
                CharacterBezel(
                    configuration: .init(character: self.translator.bezelTranslator.character))
                    .allowsHitTesting(false)
                
                // MARK: Page Number
                VStack {
                    Spacer()
                        .allowsHitTesting(false)
                    TappableTextCapsuleView(
                        action: evaluator?.pageNumberAction,
                        text: translator.pageXofX)
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
                UITableView.appearance().separatorStyle = .none
            }
            .onDisappear {
                UITableView.appearance().separatorStyle = .singleLine
            }
            
            // MARK: Hide Navigation Bar
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                self.navBarHidden = true
            }.onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                self.navBarHidden = false
            }
            .navigationBarTitle("PagingTutorial", displayMode: .inline)
                .navigationBarHidden(self.navBarHidden)
        }
    }
}

struct PagingTutorial_Screen_Previews: PreviewProvider {
    static var previews: some View {
        PagingTutorial.Screen()
    }
}
