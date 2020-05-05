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
        // ...
        
        // Passthrough Behavior
        var behavior: Behavior?
        
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
            
        case .stepA(let configuration):
            showStepA(configuration)
        }
    }
    
    func showLoadingStep() {
        // Set observable display state
        // ...
    }
    
    func showStepA(_ configuration: Evaluator.StepAConfiguration) {
        // Set observable display state
        // ...
    }
}
