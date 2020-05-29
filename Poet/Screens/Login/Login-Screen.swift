//
//  Login-Screen.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/28/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct Login {}

extension Login {
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
                    ObservingTextView(translator.title)
                        .font(Font.headline)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 22)

                    Spacer().frame(height: 36)
                    
                    VStack {
                        // Username Text Field
                        ObservingTextField(
                            placeholder: "Username",
                            text: self.translator.usernameText,
                            elementName: Evaluator.Element.usernameTextField,
                            isSecure: false,
                            evaluator: evaluator,
                            validation: translator.usernameValidation
                        )
                        
                        // Password Text Field
                        ObservingTextField(
                            placeholder: "Password",
                            text: self.translator.passwordText,
                            elementName: Evaluator.Element.passwordTextField,
                            isSecure: true,
                            evaluator: evaluator,
                            validation: translator.passwordValidation
                        )
                    }.animation(.linear)
                    
                    Spacer()
                    
                    ObservingBottomButton(observableNamedEnabledAction: self.translator.bottomButtonAction, evaluator: evaluator)
                }
                
                VStack {
                    DismissButton(orientation: .right)
                    Spacer()
                }
                
                AlertPresenter(translator.alert)
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

class KeyboardResponder: ObservableObject {
    private var notificationCenter: NotificationCenter
    @Published private(set) var currentHeight: CGFloat = 0
    
    init(center: NotificationCenter = .default) {
       notificationCenter = center
       notificationCenter.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
       notificationCenter.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyBoardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            currentHeight = keyboardSize.height
        }
    }
    
    @objc func keyBoardWillHide(notification: Notification) {
        currentHeight = 0
    }
    
    deinit {
       notificationCenter.removeObserver(self)
    }
}
