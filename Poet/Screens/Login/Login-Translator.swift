//
//  Login-Translator.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/28/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine
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
        var bottomButtonAction = Observable<NamedEnabledEvaluatorAction<Action>?>()
        
        var alert = PassableAlert()
        var passableUsername = PassableString()
        var passablePassword = PassableString()
        
        var busy = PassableBool()
        
        // Passthrough Behavior
        private var stateSink: AnyCancellable?
        
        init(_ state: PassableState<Evaluator.State>) {
            stateSink = state.subject.sink { [weak self] value in
                self?.translate(state: value)
            }
        }
    }
}

extension Login.Translator {
    func translate(state: Evaluator.State) {
        switch state {
            
        case .initial:
            break
            
        case .login(let state):
            translateLogin(state)
        }
    }
    
    func translateLogin(_ state: Evaluator.LoginState) {
        // Set observable display state
        title.string = "Sign In"
        
        usernameValidation.isValid.bool = state.usernameValidation.isValid
        usernameValidation.message.string = state.usernameValidation.message
        
        passwordValidation.isValid.bool = state.passwordValidation.isValid
        passwordValidation.message.string = state.passwordValidation.message
        
        let enabled = state.usernameValidation.isValid && state.passwordValidation.isValid
        
        withAnimation(Animation.linear.delay(0.25)) {
            bottomButtonAction.value = NamedEnabledEvaluatorAction(name: "Sign in", enabled: enabled, action: Action.signIn)
        }
    }
}
