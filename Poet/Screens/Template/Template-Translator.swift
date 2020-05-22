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
        var title = ObservableString()
        var body = ObservableString()
        
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
            
        case .initial:
            break // no initial setup needed
            
        case .text(let configuration):
            translateTextStep(configuration)
        }
    }
    
    func translateTextStep(_ configuration: Evaluator.TextStepConfiguration) {
        // Set observable display state
        title.string = configuration.title
        body.string = configuration.body
    }
}
