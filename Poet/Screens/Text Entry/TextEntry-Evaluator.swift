//
//  Template-Evaluator.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/2/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

extension TextEntry {
    class Evaluator {
        
        // Translator
        lazy var translator: Translator = Translator(current)
        
        // Current Step
        var current = PassableStep(Step.initial)
        
        enum Element: EvaluatorElement {
            case textField
        }
    }
}

// Steps and Step Configurations
extension TextEntry.Evaluator {
    enum Step: EvaluatorStep {
        case initial
        case typing(TypingStepConfiguration)
    }
    
    struct TypingStepConfiguration {
        var title: String
        var typedText: String
    }
}

// View Cycle
extension TextEntry.Evaluator: ViewCycleEvaluating {
    func viewDidAppear() {
        showTypingStep()
    }
}

// Advancing Between Steps
extension TextEntry.Evaluator {
    func showTypingStep() {
        let configuration = TypingStepConfiguration(
            title: "TextEntry",
            typedText: ""
        )
        current.step = .typing(configuration)
    }
}

// MARK: Text Entry
extension TextEntry.Evaluator: TextFieldEvaluating {
    func textFieldDidChange(text: String, elementName: EvaluatorElement) {
        guard case var .typing(configuration) = current.step else { return }
        
        configuration.typedText = text
        
        current.step = .typing(configuration)
    }
}
