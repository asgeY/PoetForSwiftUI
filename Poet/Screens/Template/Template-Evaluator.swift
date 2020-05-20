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
        case text(TextStepConfiguration)
    }
    
    // Configurations
    struct TextStepConfiguration {
        var title: String
        var body: String
    }
}

// View Cycle
extension Template.Evaluator: ViewCycleEvaluator {
    
    func viewDidAppear() {
        showTextStep()
    }
}

// Advancing Between Steps
extension Template.Evaluator {
    func showTextStep() {
        let configuration = TextStepConfiguration(
            title: "Template",
            body:
            """
            You're looking at a screen made with a simple template, located in Template-Screen.swift.

            Use this template as the basis for new screens, or read through its code to get a better sense of the Poet pattern.
            """
        )
        current.step = .text(configuration)
    }
}
