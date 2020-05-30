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

// MARK: Steps and Step Configurations
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

// MARK: View Cycle
extension Login.Evaluator: ViewCycleEvaluating {
    func viewDidAppear() {
        showLoginStep()
    }
}

// MARK: Advancing Between Steps
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
        case signIn
        case useDefaultCredentials
    }
    
    func evaluate(_ action: EvaluatorAction?) {
        guard let action = action as? Action else { return }
        
        switch action {
        case .signIn:
            signIn()
        case .useDefaultCredentials:
            useDefaultCredentials()
        }
    }
    
    // MARK: Actions on Login Step
    func signIn() {
        guard case let .login(configuration) = current.step else { return }
        
        translator.alert.withConfiguration(
            title: "Sign In",
            message:
            """
            username: “\(configuration.enteredUsername)”
            password: “\(configuration.enteredPassword)”
                    
            There's nothing to sign in to. This was just a demonstration of text fields!
            """
        )
    }
    
    func useDefaultCredentials() {
        let username = "admin"
        let password = "123456789"
        
        translator.passableUsername.string = username
        translator.passablePassword.string = password
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
        typealias Condition = TextValidation.Condition
        return TextValidation([
            Condition(message: "Must be at least 5 characters long") {
                return $0.count >= 5
            },
            
            Condition(message: "No special characters: = , \" ' \\") {
                let splitString = Array($0).map { String($0) }
                let badCharacters = ["=", ",", "\"", "'", "\\"]
                return splitString.contains(where: badCharacters.contains) == false
            }
        ])
    }
    
    func passwordValidation() -> TextValidation {
        typealias Condition = TextValidation.Condition
        return TextValidation([
            Condition(message: "Must be at least 6 characters long") {
                return $0.count >= 6
            },
            
            Condition(message: "No special characters: = , . \" ' \\ @") {
                let splitString = Array($0).map { String($0) }
                let badCharacters = ["=", ",", ".", "\"", "'", "\\", "@"]
                return splitString.contains(where: badCharacters.contains) == false
            },
        ])
    }
}

