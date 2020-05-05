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
        
        // Step       
        var current = PassableStep(Step.loading)
        
    }
}

// Steps and Step Configurations
extension Template.Evaluator {
    
    enum Step: EvaluatorStep {
        case loading
        case stepA(StepAConfiguration)
    }
    
    // Configurations
    
    struct StepAConfiguration {
        //
    }
}

// View Cycle
extension Template.Evaluator: ViewCycleEvaluator {
    
    func viewDidAppear() {
        showStepA()
    }
}

// Advancing Between Steps
extension Template.Evaluator {
    func showStepA() {
        let configuration = StepAConfiguration(
            //
        )
        current.step = Step.stepA(configuration)
    }
}
