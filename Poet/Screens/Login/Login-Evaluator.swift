//
//  Login-Evaluator.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/28/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

extension Login {
    class Evaluator {
        
        // Translator
        lazy var translator: Translator = Translator(current)
        
        // Current Step
        var current = PassableStep(Step.initial)
        
        enum Element: EvaluatorElement {
            case usernameTextField
            case passwordTextField
        }
    }
}

// Steps and Step Configurations
extension Login.Evaluator {
    enum Step: EvaluatorStep {
        case initial
        case login(LoginStepConfiguration)
    }
    
    struct LoginStepConfiguration {
        var enteredUsername: String
        var usernameValidation: TextValidation
        var enteredPassword: String
        var passwordValidation: TextValidation
    }
}

// View Cycle
extension Login.Evaluator: ViewCycleEvaluating {
    func viewDidAppear() {
        showLoginStep()
    }
}

// Advancing Between Steps
extension Login.Evaluator {
    func showLoginStep() {
        let configuration = LoginStepConfiguration(
            enteredUsername: "",
            usernameValidation: usernameValidation(),
            enteredPassword: "",
            passwordValidation: passwordValidation()
        )
        current.step = .login(configuration)
    }
}

// MARK: Actions
extension Login.Evaluator: ActionEvaluating {
    enum Action: EvaluatorAction {
        case login
    }
    
    func evaluate(_ action: EvaluatorAction?) {
        guard let action = action as? Action else { return }
        
        switch action {
        case .login:
            translator.alert.withConfiguration(title: "Login", message: "We won't actually log in now. This was just a demonstration of text fields!")
        }
    }
}

// MARK: Text Field Evaluating
extension Login.Evaluator: TextFieldEvaluating {
    func textFieldDidChange(text: String, elementName: EvaluatorElement) {
        guard case var .login(configuration) = current.step else { return }
        
        if let elementName = elementName as? Element {
            switch elementName {
            case .usernameTextField:
                configuration.enteredUsername = text
                configuration.usernameValidation.validate(text: text)
            case .passwordTextField:
                configuration.enteredPassword = text
                configuration.passwordValidation.validate(text: text)
            }
            
            current.step = .login(configuration)
        }
    }
    
    func usernameValidation() -> TextValidation {
        return TextValidation(
        message: "Must be at least 5 characters long") {
            return $0.count >= 5
        }
    }
    
    func passwordValidation() -> TextValidation {
        return TextValidation(
        message: "Must be at least 6 characters long") {
            return $0.count >= 6
        }
    }
}

