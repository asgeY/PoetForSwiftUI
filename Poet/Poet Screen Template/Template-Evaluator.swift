//
//  Template-Evaluator.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/2/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

extension Template {
    class Evaluator {
        
        // Translator
        lazy var translator: Translator = Translator(current)
        
        // Current Step
        var current = PassableStep(Step.loading)
        
    }
}

// Steps and Step Configurations
extension Template.Evaluator {
    
    // Steps
    enum Step: EvaluatorStep {
        case loading
        case greeting(GreetingStepConfiguration)
    }
    
    // Configurations
    struct GreetingStepConfiguration {
        var text: String
    }
}

// View Cycle
extension Template.Evaluator: ViewCycleEvaluator {
    
    func viewDidAppear() {
        showGreetingStep()
    }
}

// Advancing Between Steps
extension Template.Evaluator {
    func showGreetingStep() {
        let configuration = GreetingStepConfiguration(
            text: "Hello"
        )
        current.step = Step.greeting(configuration)
    }
}
