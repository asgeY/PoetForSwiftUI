//
//  Pager-Screen.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/24/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct Pager {}

extension Pager {
    struct Screen: View {
        let _evaluator: Pager.Evaluator
        weak var evaluator: Pager.Evaluator?
        let translator: Pager.Translator
        
        init() {
            debugPrint("init Pager Screen")
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
                        
                        // MARK: Screen Title
                        Text("The Poet Pattern\nfor SwiftUI")
                            .font(Font.subheadline.monospacedDigit().bold())
                            .layoutPriority(4)
                            .multilineTextAlignment(.center)
                        Spacer().frame(height:32)
                        
                        // MARK: Tappable Page Title
                        ButtonActionView(
                            action: evaluator?.titleAction,
                            content:
                                AnyView(
                                    ObservingTextView(
                                        text: translator.observable.pageTitle,
                                        font: Font.headline.monospacedDigit(),
                                        alignment: .center)
                                )
                        )
                        Spacer().frame(height:16)
                        
                        // MARK: Page Body
                        PageBodyView(pageBody: self.translator.observable.pageBody)
                            .layoutPriority(10)
                        
                        Spacer()
                            .layoutPriority(1)
                    }
                }
                
                // MARK: Left and Right Buttons
                LeftAndRightButtonView(
                    leftAction: self.evaluator?.leftAction,
                    rightAction: self.evaluator?.rightAction,
                    leftButtonIsEnabled: self.translator.observable.isLeftButtonEnabled,
                    rightButtonIsEnabled: self.translator.observable.isRightButtonEnabled)
                
                // MARK: Character Bezel
                CharacterBezel(
                    configuration: .init(character: self.translator.passable.emoji))
                
                // MARK: Page Number
                VStack {
                    Spacer()
                    TappableTextCapsuleView(
                        action: evaluator?.pageNumberAction,
                        text: translator.observable.pageXofX)
                    Spacer().frame(height: 10)
                }
                
                // MARK: Alert View
                AlertView(
                    title: translator.alertTitle,
                    message: translator.alertMessage,
                    isPresented: translator.isAlertPresented)
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
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                self.navBarHidden = true
            }.onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                self.navBarHidden = false
            }
            .navigationBarTitle("Pager", displayMode: .inline)
                .navigationBarHidden(self.navBarHidden)
        }
    }
}

struct Pager_Screen_Previews: PreviewProvider {
    static var previews: some View {
        Pager.Screen()
    }
}
