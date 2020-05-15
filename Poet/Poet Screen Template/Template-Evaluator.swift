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
        case title(TitleStepConfiguration)
    }
    
    // Configurations
    struct TitleStepConfiguration {
        var title: String
    }
}

// View Cycle
extension Template.Evaluator: ViewCycleEvaluator {
    
    func viewDidAppear() {
        showTitleStep()
    }
}

// Advancing Between Steps
extension Template.Evaluator {
    func showTitleStep() {
        let configuration = TitleStepConfiguration(
            title: "You're looking at the Poet Template, located in Template-Screen.swift.\n\nLook at the code to see an example of a very minimal screen that still follows the Poet pattern."
        )
        current.step = .title(configuration)
    }
}
