//
//  HelloWorld-Translator.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/25/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

extension HelloWorld {

    class Translator {
        
        typealias Evaluator = HelloWorld.Evaluator
        
        // Observable Display State
        var helloCount = ObservableString()
        var buttonAction = ObservableNamedEnabledEvaluatorAction()
        var bubbleText = ObservableString()
        var shouldShowBubble = ObservableBool()
        
        // Passthrough Behavior
        private var behavior: Behavior?
        
        init(_ step: PassableStep<Evaluator.Step>) {
            behavior = step.subject.sink { value in
                self.translate(step: value)
            }
        }
    }
}

extension HelloWorld.Translator {
    func translate(step: Evaluator.Step) {
        switch step {
            
        case .initial:
            break
            
        case .sayStuff(let configuration):
            translateSayStuffStep(configuration)
        }
    }
    
    func translateSayStuffStep(_ configuration: Evaluator.SayStuffStepConfiguration) {
        helloCount.string = "Hello count: \(configuration.helloCount)"
        
        buttonAction.namedEnabledAction = nil
        afterWait(800) {
            self.buttonAction.namedEnabledAction = NamedEnabledEvaluatorAction(
                name: configuration.buttonAction.name,
                enabled: true,
                action: configuration.buttonAction
            )
        }
        
        if let bubbleText = configuration.bubbleText {
            self.bubbleText.string = bubbleText
        }
        withAnimation(.spring(response: 0.55, dampingFraction: 0.65, blendDuration: 0)) {
            shouldShowBubble.bool = configuration.bubbleText != nil
        }
    }
}
