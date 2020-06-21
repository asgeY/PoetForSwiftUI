//
//  Login-Evaluator.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/28/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine
import SwiftUI

extension Login {
    class Evaluator {
        
        // Translator
        lazy var translator: Translator = Translator(current)
        var performer: LoginPerforming = Performer()
        
        // Current State
        var current = PassableState(State.initial)
        
        // Sink
        var loginSink: Sink?
        
        enum Element: EvaluatorElement {
            case usernameTextField
            case passwordTextField
        }
    }
}

// MARK: State

extension Login.Evaluator {
    enum State: EvaluatorState {
        case initial
        case login(LoginState)
    }
    
    struct LoginState {
        var enteredUsername: String
        var usernameValidation: TextValidation
        var enteredPassword: String
        var passwordValidation: TextValidation
    }
}

// MARK: View Cycle
extension Login.Evaluator: ViewCycleEvaluating {
    func viewDidAppear() {
        showLogin()
    }
    
    func showLogin() {
        let state = LoginState(
            enteredUsername: "",
            usernameValidation: usernameValidation(),
            enteredPassword: "",
            passwordValidation: passwordValidation()
        )
        current.state = .login(state)
    }
}

// MARK: Actions

extension Login.Evaluator: ActionEvaluating {
    enum Action: EvaluatorAction {
        case signIn
        case useCorrectCredentials
    }
    
    func _evaluate(_ action: Action) {
        switch action {
            
        case .signIn:
            signIn()
            
        case .useCorrectCredentials:
            useCorrectCredentials()
        }
    }
    
    private func signIn() {
        guard case let .login(currentState) = current.state else { return }
        
        UIApplication.shared.endEditing()
        
        self.translator.busy.isTrue()
        
        loginSink = performer.login(
            username: currentState.enteredUsername,
            password: currentState.enteredPassword
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
        guard case var .login(state) = current.state else { return }
        
        if let elementName = elementName as? Element {
            switch elementName {
                
            case .usernameTextField:
                state.enteredUsername = text
                state.usernameValidation.validate(text: text)
                
            case .passwordTextField:
                state.enteredPassword = text
                state.passwordValidation.validate(text: text)
            }
            
            current.state = .login(state)
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
