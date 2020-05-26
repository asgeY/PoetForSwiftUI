//
//  HelloWorld-Evaluator.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/25/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

extension HelloWorld {
    class Evaluator {
        
        // Translator
        lazy var translator: Translator = Translator(current)
        
        // Current Step
        var current = PassableStep(Step.initial)
    }
}

// MARK: Steps

extension HelloWorld.Evaluator {
    enum Step: EvaluatorStep {
        case initial
        case sayStuff(SayStuffStepConfiguration)
    }
    
    struct SayStuffStepConfiguration {
        var helloCount: Int
        var bubbleText: String?
        var buttonAction: ButtonAction
    }
}

// MARK: Button Actions
extension HelloWorld.Evaluator: ButtonEvaluating {
    enum ButtonAction: EvaluatorAction {
        case sayHello
        case sayNothing
        
        var name: String {
            switch self {
            case .sayHello:     return "Say Hello"
            case .sayNothing:   return "Say Nothing"
            }
        }
    }
    
    func buttonTapped(action: EvaluatorAction?) {
        guard let action = action as? ButtonAction else { return }
        
        switch action {
            
        case .sayHello:
            sayHello()
            
        case .sayNothing:
            sayNothing()
        }
    }
}

// MARK: View Cycle
extension HelloWorld.Evaluator: ViewCycleEvaluating {
    func viewDidAppear() {
        showSayStuffStep()
    }
}

// MARK: Advancing Between Steps
extension HelloWorld.Evaluator {
    
    // MARK: “Say Stuff” Step
    
    private func showSayStuffStep() {
        let configuration = SayStuffStepConfiguration(
            helloCount: 0,
            bubbleText: nil,
            buttonAction: ButtonAction.sayHello
        )
        current.step = .sayStuff(configuration)
    }
    
    private func sayHello() {
        guard case var .sayStuff(configuration) = current.step else { return }
        
        configuration.bubbleText = "Hello World!"
        configuration.buttonAction = .sayNothing
        configuration.helloCount += 1
        
        current.step = .sayStuff(configuration)
    }
    
    private func sayNothing() {
        guard case var .sayStuff(configuration) = current.step else { return }
        
        configuration.bubbleText = nil
        configuration.buttonAction = .sayHello
        
        current.step = .sayStuff(configuration)
    }
}
