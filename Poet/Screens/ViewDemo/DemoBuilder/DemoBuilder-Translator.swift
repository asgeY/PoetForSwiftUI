//
//  DemoBuilder-Translator.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/2/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine
import Foundation

extension DemoBuilder {

    class Translator {
        
        typealias Evaluator = DemoBuilder.Evaluator
        
        // Observable Display State
        
        
        // Passable
        
        
        // Step Sink
        private var stepSink: AnyCancellable?
        
        init(_ step: PassableStep<Evaluator.Step>) {
            stepSink = step.subject.sink { [weak self] value in
                self?.translate(step: value)
            }
        }
    }
}

extension DemoBuilder.Translator {
    func translate(step: Evaluator.Step) {
        switch step {
            
        case .initial:
            break // no initial setup needed
            
        case .build(let configuration):
            translateBuildStep(configuration)
        }
    }
    
    func translateBuildStep(_ configuration: Evaluator.BuildStepConfiguration) {
        // Set observable display state
        
    }
}
