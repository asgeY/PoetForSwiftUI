//
//  Template-Translator.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/2/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

extension Template {

    class Translator {
        
        typealias Evaluator = Template.Evaluator
        
        // Observable Display State
        var greeting = ObservableString()
        
        // Passthrough Behavior
        private var behavior: Behavior?
        
        init(_ step: PassableStep<Evaluator.Step>) {
            behavior = step.subject.sink { value in
                self.translate(step: value)
            }
        }
    }
}

extension Template.Translator {
    func translate(step: Evaluator.Step) {
        switch step {
            
        case .loading:
            showLoadingStep()
            
        case .greeting(let configuration):
            showGreeting(configuration)
        }
    }
    
    func showLoadingStep() {
        // nothing to see here
    }
    
    func showGreeting(_ configuration: Evaluator.GreetingStepConfiguration) {
        // Set observable display state
        greeting.string = configuration.text
    }
}
