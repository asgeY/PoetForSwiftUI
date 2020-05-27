//
//  Chapter_ProtocolOrientedTranslating.swift
//  Poet
//
//  Created by Steve Cotner on 5/26/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

extension Tutorial.PageStore {
    var chapter_ProtocolOrientedTranslating: Chapter {
        return Chapter(
            "Protocol-Oriented Translating",
            pages:
            Page([.text("A lot of user interface elements are very predictable but still require a good amount of code to implement: alerts, action sheets, bezels, toasts.")]),
            Page([.text("iOS programmers are used to asking for these things imperatively, but in SwiftUI, we bring them about my modifying our display state.")]),
            Page([.text("That's a little painful to do, and in simple implementations developers often end up coupling specific alerts to the view layer. We can do it better by following a technique we'll call protocol-oriented translating.")]),
            Page([.text("Take this alert, for example. If you tap the button below that says “Show Alert,” you'll see it.")], action: .showAlert),
            Page([.text("Or here's another, with two styled actions. Tap “Show Another Alert” to see it.")], action: .showAnotherAlert),
            Page([.text("The challenge for us is to decouple the content of these alerts from the view layer, so the evaluator can imperatively trigger alerts with whatever content it likes.")]),
            Page([.text("We'll do that by first dividing our responsibilities correctly, then streamlining the process with protocol-oriented default implementations.")]),
            Page([.text("The view layer needs to be smart enough to show any sort of alert, and to observe the values that will inform the alert's contents. We accomplish that with AlertView:"),
                  .code(
                    """
                    struct AlertView: View { ... }
                    """
                )
                ],
                 supplement: Supplement(shortTitle: "AlertView", fullTitle: "", body: [
                .code(
                    """
                    import Combine
                    import SwiftUI

                    struct AlertView: View {
                        @ObservedObject private var title: ObservableString
                        @ObservedObject private var message: ObservableString
                        @ObservedObject private var primaryAlertAction: ObservableAlertAction
                        @ObservedObject private var secondaryAlertAction: ObservableAlertAction
                        @ObservedObject private var isPresented: ObservableBool
                        
                        init(translator: AlertTranslating) {
                            title = translator.alertTranslator.alertTitle
                            message = translator.alertTranslator.alertMessage
                            primaryAlertAction = translator.alertTranslator.primaryAlertAction
                            secondaryAlertAction = translator.alertTranslator.secondaryAlertAction
                            isPresented = translator.alertTranslator.isAlertPresented
                        }
                        
                        var body: some View {
                            VStack {
                                EmptyView()
                            }
                            .alert(isPresented: $isPresented.bool) {
                                if let primaryAlertAction = primaryAlertAction.alertAction, let secondaryAlertAction = secondaryAlertAction.alertAction {
                                    let primaryButton: Alert.Button = button(for: primaryAlertAction)
                                    let secondaryButton: Alert.Button = button(for: secondaryAlertAction)
                                    return Alert(title: Text(title.string), message: Text(message.string), primaryButton: primaryButton, secondaryButton: secondaryButton)
                                } else if let primaryAlertAction = primaryAlertAction.alertAction {
                                    let primaryButton: Alert.Button = button(for: primaryAlertAction)
                                    return Alert(title: Text(title.string), message: Text(message.string), dismissButton: primaryButton)
                                } else {
                                    let primaryButton = Alert.Button.default(Text("OK"))
                                    return Alert(title: Text(title.string), message: Text(message.string), dismissButton: primaryButton)
                                }
                            }
                        }
                        
                        func button(for alertAction: AlertAction) -> Alert.Button {
                            switch alertAction.style {
                            case .regular:
                                return Alert.Button.default(Text(alertAction.title), action: {
                                    DispatchQueue.main.async {
                                        alertAction.action?()
                                    }
                                })
                            case .cancel:
                                return Alert.Button.cancel(Text(alertAction.title), action: {
                                    DispatchQueue.main.async {
                                        alertAction.action?()
                                    }
                                })
                            case .destructive:
                                return Alert.Button.destructive(Text(alertAction.title), action: {
                                    DispatchQueue.main.async {
                                        alertAction.action?()
                                    }
                                })
                            }
                        }
                    }
                    """
                    )
                ])
                 ),
            Page([.text("Next, the translator needs to provide observable values for title, message, and so on.")]),
            Page([.text("We'll bundle those up in a separate AlertTranslator:"),
                  .smallCode(
                    """
                    struct AlertTranslator {
                      var title = ObservableString()
                      var message = ObservableString()
                      var primaryAlertAction =
                        ObservableAlertAction()
                      var secondaryAlertAction =
                        ObservableAlertAction()
                      var isAlertPresented =
                        ObservableBool(false)
                    }
                    """
                )
            ], supplement: Supplement(shortTitle: "AlertTranslator", fullTitle: "", body: [
                .code(
                """
                struct AlertTranslator {
                    var title = ObservableString()
                    var message = ObservableString()
                    var primaryAlertAction = ObservableAlertAction()
                    var secondaryAlertAction = ObservableAlertAction()
                    var isAlertPresented = ObservableBool(false)
                }

                struct AlertAction {
                    let title: String
                    let style: AlertStyle
                    let action: (() -> Void)?
                    
                    enum AlertStyle {
                        case regular
                        case cancel
                        case destructive
                    }
                }
                """
                )
            ])),
            Page([.text("Our translator will hold onto that AlertTranslator. But that's as much thinking as we want to do on each screen we implement.")]),
            Page([.text("So we'll make our translator conform to AlertTranslating to give it default implementations of some “showAlert” methods."),
                  .extraSmallCode(
                    """
                    protocol AlertTranslating {
                      var alertTranslator: AlertTranslator { get }
                      func showAlert(title: String, message: String)
                      // ...
                    }
                    """
                )
            ], supplement: Supplement(shortTitle: "AlertTranslating", fullTitle: "", body: [
                .code(
                    """
                    protocol AlertTranslating {
                        var alertTranslator: AlertTranslator { get }
                        func showAlert(title: String, message: String)
                        func showAlert(title: String, message: String, alertAction: AlertAction)
                        func showAlert(title: String, message: String, primaryAlertAction: AlertAction, secondaryAlertAction: AlertAction)
                    }

                    extension AlertTranslating {
                        func showAlert(title: String, message: String) {
                            alertTranslator.alertTitle.string = title
                            alertTranslator.alertMessage.string = message
                            alertTranslator.isAlertPresented.bool = true
                            alertTranslator.primaryAlertAction.alertAction = nil
                            alertTranslator.secondaryAlertAction.alertAction = nil
                        }
                        
                        func showAlert(title: String, message: String, alertAction: AlertAction) {
                            alertTranslator.alertTitle.string = title
                            alertTranslator.alertMessage.string = message
                            alertTranslator.primaryAlertAction.alertAction = alertAction
                            alertTranslator.secondaryAlertAction.alertAction = nil
                            alertTranslator.isAlertPresented.bool = true
                        }
                        
                        func showAlert(title: String, message: String, primaryAlertAction: AlertAction, secondaryAlertAction: AlertAction) {
                            alertTranslator.alertTitle.string = title
                            alertTranslator.alertMessage.string = message
                            alertTranslator.primaryAlertAction.alertAction = primaryAlertAction
                            alertTranslator.secondaryAlertAction.alertAction = secondaryAlertAction
                            alertTranslator.isAlertPresented.bool = true
                        }
                    }
                    """
                )
            ])),
            Page([.text("That's a lot, but it's written once and we never have to think about it. To use it, the evaluator just asks the translator to show an alert:"),
                  .code(
                    """
                    translator.showAlert(
                        title: "Alert!",
                        message: "You did it."
                    )
                    """
                )]),
            Page([.text("The only code we added to our Translator was a declaration of conformance:"),
                  .smallCode("class Translator: AlertTranslating {"),
                  .text("And a property to hold the AlertTranslator:"),
                  .smallCode("var alertTranslator = AlertTranslator()")
            ]),
            Page([.text("And we added a single line to our view layer, inside a Group nested in a top-level ZStack:"),
                  .code("AlertView(translator: translator)"),
            ]),
            Page([.text("It's never been so easy to write alerts that are responsibly decoupled from the view layer. Remember, when the evaluator asks for an alert, it can set any method it likes inside an alert action. The round trip back to the evaluator is all in one place.")]),
            Page([.text("We can also make light work of bezels, action sheets, or anything else we'd like to trigger imperatively. Tap “Show Bezel” to see a bezel with a random emoji.")],
                 action: .showBezel,
                 supplement: Supplement(shortTitle: "CharacterBezerTranslating", fullTitle: "", body: [
                .code(
                    """
                    import Combine
                    import SwiftUI

                    protocol BezelTranslating {
                        var bezelTranslator: BezelTranslator { get }
                        func showBezel(text: String)
                    }

                    extension BezelTranslating {
                        func showBezel(text: String) {
                            BezelTranslator.character.string = character
                        }
                    }

                    struct BezelTranslator {
                        var character = PassableString()
                    }

                    struct BezelView: View {
                        
                        @State private var character: String = ""
                        @State private var opacity: Double = 0
                        
                        private var passableCharacter: PassableString
                        
                        init(translator: BezelTranslating) {
                            self.passableCharacter = translator.bezelTranslator.character
                        }
                        
                        enum Layout {
                            static var fullOpacity = 1.0
                            static var zeroOpacity = 0.0
                            static var fadeInDuration = 0.125
                            static var fadeOutWaitInMilliseconds = Int(fadeInDuration * 1000.0) + 500
                            static var fadeOutDuration = 0.7
                            
                            static var verticalPadding: CGFloat = 30
                            static var horizontalPadding: CGFloat = 38
                            static var characterFontSize: CGFloat = 128
                            static var bezelCornerRadius: CGFloat = 10
                            static var bezelBlurRadius: CGFloat = 12
                        }
                        
                        var body: some View {
                            VStack {
                                VStack {
                                    Text(character)
                                        .font(Font.system(size: Layout.characterFontSize))
                                        .padding(EdgeInsets(
                                            top: Layout.verticalPadding,
                                            leading: Layout.horizontalPadding,
                                            bottom: Layout.verticalPadding,
                                            trailing: Layout.horizontalPadding))
                                }
                                .background(
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(Color(UIColor.systemBackground).opacity(0.95))
                                            .padding(10)
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(Color.primary.opacity(0.12))
                                            .padding(10)
                                        .mask(
                                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                .padding(10)
                                                .opacity(0.95)
                                        )
                                    }
                                    
                                )
                            }
                            .opacity(opacity)
                                .onReceive(passableCharacter.subject) { (newValue) in
                                    if let newValue = newValue {
                                        self.character = newValue
                                        withAnimation(.linear(duration: Layout.fadeInDuration)) {
                                            self.opacity = Layout.fullOpacity
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now().advanced(by: .milliseconds(Layout.fadeOutWaitInMilliseconds))) {
                                            withAnimation(.linear(duration: Layout.fadeOutDuration)) {
                                                self.opacity = Layout.zeroOpacity
                                            }
                                        }
                                    }
                            }
                            .allowsHitTesting(false)
                        }
                    }
                    """
                    )
            ])),
            Page([.text("That's enough of that. As promised, we can move on now to some example screens, each a little more complex than the last, to illustrate the Poet pattern in full. How about a simple template to start?")])
        )
    }
}
