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
        var usernameValidation = ObservableValidation()
        var passwordValidation = ObservableValidation()
        
        // Bottom button value
        var bottomButtonAction = ObservableNamedEnabledEvaluatorAction()
        
        var alert = PassableAlert()
        var passableUsername = PassableString()
        var passablePassword = PassableString()
        
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
            break
            
        case .login(let configuration):
            translateLoginStep(configuration)
        }
    }
    
    func translateLoginStep(_ configuration: Evaluator.LoginStepConfiguration) {
        // Set observable display state
        title.string = "Sign In"
        
        usernameValidation.isValid.bool = configuration.usernameValidation.isValid
        usernameValidation.message.string = configuration.usernameValidation.message
        
        passwordValidation.isValid.bool = configuration.passwordValidation.isValid
        passwordValidation.message.string = configuration.passwordValidation.message
        
        let enabled = configuration.usernameValidation.isValid && configuration.passwordValidation.isValid
        
        withAnimation(Animation.linear.delay(0.25)) {
            bottomButtonAction.namedEnabledAction = NamedEnabledEvaluatorAction(name: "Sign in", enabled: enabled, action: Action.signIn)
        }
    }
}
