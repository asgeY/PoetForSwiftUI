//
//  TextEntry-Translator.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/2/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

extension TextEntry {

    class Translator {
        
        typealias Evaluator = TextEntry.Evaluator
        
        // Observable Display State
        var title = ObservableString()
        var body = ObservableString()
        
        var textFieldPlaceholder = ObservableString()
        var textFieldText = ObservableString()
        
        // Passthrough Behavior
        private var behavior: Behavior?
        
        init(_ step: PassableStep<Evaluator.Step>) {
            behavior = step.subject.sink { value in
                self.translate(step: value)
            }
        }
    }
}

extension TextEntry.Translator {
    func translate(step: Evaluator.Step) {
        switch step {
            
        case .initial:
            break // no initial setup needed
            
        case .typing(let configuration):
            translateTypingStep(configuration)
        }
    }
    
    func translateTypingStep(_ configuration: Evaluator.TypingStepConfiguration) {
        // Set observable display state
        title.string = configuration.title
        body.string = configuration.typedText
        textFieldPlaceholder.string = "Type here!"
        textFieldText.string = configuration.typedText
    }
}
