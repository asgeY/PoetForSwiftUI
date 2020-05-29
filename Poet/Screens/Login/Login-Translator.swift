//
//  Login-Translator.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/28/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

extension Login {

    class Translator {
        
        typealias Evaluator = Login.Evaluator
        typealias Action = Evaluator.Action
        
        // Observable Display State
        var title = ObservableString()
        
        // Text Field values
        var usernameText = ObservableString()
        var isUsernameValid = ObservableBool()
        var usernameValidationMessage = ObservableString()
        
        var passwordText = ObservableString()
        var isPasswordValid = ObservableBool()
        var passwordValidationMessage = ObservableString()
        
        // Bottom button value
        var bottomButtonAction = ObservableNamedEnabledEvaluatorAction()
        
        var alert = PassableAlert()
        
        // Passthrough Behavior
        private var behavior: Behavior?
        
        init(_ step: PassableStep<Evaluator.Step>) {
            behavior = step.subject.sink { value in
                self.translate(step: value)
            }
        }
    }
}

extension Login.Translator {
    func translate(step: Evaluator.Step) {
        switch step {
            
        case .initial:
            break // no initial setup needed
            
        case .login(let configuration):
            translateLoginStep(configuration)
        }
    }
    
    func translateLoginStep(_ configuration: Evaluator.LoginStepConfiguration) {
        // Set observable display state
        title.string = "Sign In"
        
        usernameText.string = configuration.enteredUsername
        isUsernameValid.bool = configuration.isEnteredUsernameValid
        usernameValidationMessage.string = configuration.usernameValidationMessage
        
        passwordText.string = configuration.enteredPassword
        isPasswordValid.bool = configuration.isEnteredPasswordValid
        passwordValidationMessage.string = configuration.passwordValidationMessage
        
        let enabled = configuration.isEnteredUsernameValid && configuration.isEnteredPasswordValid
        withAnimation(Animation.linear.delay(0.25)) {
            bottomButtonAction.namedEnabledAction = NamedEnabledEvaluatorAction(name: "Sign in", enabled: enabled, action: Action.login)
        }
    }
}
