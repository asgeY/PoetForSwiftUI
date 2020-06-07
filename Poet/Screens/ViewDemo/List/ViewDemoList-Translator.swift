//
//  ViewDemoList-Translator.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/2/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine
import Foundation

extension ViewDemoList {

    class Translator {
        
        typealias Evaluator = ViewDemoList.Evaluator
        
        // Observable Display State
        var demoProviders = ObservableArray<NamedDemoProvider>([])
        
        // Passable
        var showPreview = Passable<NamedDemoProvider>()
        
        // Step Sink
        private var stepSink: AnyCancellable?
        
        init(_ step: PassableStep<Evaluator.Step>) {
            stepSink = step.subject.sink { [weak self] value in
                self?.translate(step: value)
            }
        }
    }
}

extension ViewDemoList.Translator {
    func translate(step: Evaluator.Step) {
        switch step {
            
        case .initial:
            break // no initial setup needed
            
        case .list(let configuration):
            translateListStep(configuration)
        }
    }
    
    func translateListStep(_ configuration: Evaluator.ListStepConfiguration) {
        // Set observable display state
        demoProviders.array = configuration.demoProviders
    }
}
