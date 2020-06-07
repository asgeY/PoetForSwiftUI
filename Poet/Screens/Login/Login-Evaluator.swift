//
//  Login-Evaluator.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/28/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

extension Login {
    class Evaluator {
        
        // Translator
        lazy var translator: Translator = Translator(current)
        var performer: LoginPerforming = Performer()
        
        // Current Step
        var current = PassableStep(Step.initial)
        
        // Sink
        var loginSink: Behavior?
        
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
    
    // MARK: Login Step
    
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
        case useCorrectCredentials
    }
    
    func evaluate(_ action: EvaluatorAction?) {
        guard let action = action as? Action else { return }
        
        switch action {
            
        case .signIn:
            signIn()
            
        case .useCorrectCredentials:
            useCorrectCredentials()
        }
    }
    
    private func signIn() {
        guard case let .login(configuration) = current.step else { return }
        
        UIApplication.shared.endEditing()
        
        self.translator.busy.isTrue()
        
        loginSink = performer.login(
            username: configuration.enteredUsername,
            password: configuration.enteredPassword
            )?.sink(receiveCompletion: { (completion) in
                
            switch completion {
                
            case .failure(let error):
                self.showLoginFailureAlert(with: error)
                
            case .finished:
                break
            }
            
            self.translator.busy.isFalse()
            self.loginSink?.cancel()
            
        }, receiveValue: { (authenticationResult) in
            self.showLoginSucceededAlert(with: authenticationResult)
        })
    }
    
    private func useCorrectCredentials() {
        let username = "postman"
        let password = "password"
        
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
        return TextValidation([
            lengthCondition(5),
            specialCharacterCondition(["=", ",", "\"", "'", "\\", "?", "!", "%"])
        ])
    }
    
    func passwordValidation() -> TextValidation {
        return TextValidation([
            lengthCondition(6),
            specialCharacterCondition(["=", ",", ".", "\"", "'", "\\", "@"])
        ])
    }
    
    func lengthCondition(_ length: Int) -> TextValidation.Condition {
        return TextValidation.Condition(message: "Must be at least \(length) characters long") {
            return $0.count >= length
        }
    }
    
    func specialCharacterCondition(_ badCharacters: [String]) -> TextValidation.Condition {
        return TextValidation.Condition(message: "No special characters: \(badCharacters.joined(separator: " "))") {
            let splitString = Array($0).map { String($0) }
            return splitString.contains(where: badCharacters.contains) == false
        }
    }
}

// MARK: Handling Login Success and Failure

extension Login.Evaluator {
    
    private func showLoginSucceededAlert(with authenticationResult: AuthenticationResult) {
        translator.alert.withConfiguration(
            title: "Login Succeeded!",
            message:
            """
            Authenticated: \(authenticationResult.authenticated)
            """
        )
    }
    
    private func showLoginFailureAlert(with networkingError: NetworkingError) {
        var message = networkingError.shortName
        
        switch networkingError {
        case .unauthorized:
            message.append("\n\nCheck that you've entered your username and password correctly.")
        default:
            break
        }
        
        translator.alert.withConfiguration(
            title: "Login Failed",
            message: message
        )
    }
}
