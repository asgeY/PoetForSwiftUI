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
        var isEnteredUsernameValid: Bool
        var usernameValidationMessage: String
        var enteredPassword: String
        var isEnteredPasswordValid: Bool
        var passwordValidationMessage: String
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
            isEnteredUsernameValid: false,
            usernameValidationMessage: "Must be at least 3 characters long",
            enteredPassword: "",
            isEnteredPasswordValid: false,
            passwordValidationMessage: "Must be at least 5 characters long"
        )
        current.step = .login(configuration)
    }
}

// MARK: Text Entry
extension Login.Evaluator: TextFieldEvaluating {
    func textFieldDidChange(text: String, elementName: EvaluatorElement) {
        guard case var .login(configuration) = current.step else { return }
        
        if let elementName = elementName as? Element {
            switch elementName {
            case .usernameTextField:
                configuration.enteredUsername = text
                configuration.isEnteredUsernameValid = validateUsername(text)
            case .passwordTextField:
                configuration.enteredPassword = text
                configuration.isEnteredPasswordValid = validatePassword(text)
            }
            
            current.step = .login(configuration)
        }
    }
    
    func validateUsername(_ string: String) -> Bool {
        return string.count >= 3
    }
    
    func validatePassword(_ string: String) -> Bool {
        return string.count >= 5
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
            debugPrint("login")
        }
    }
}
