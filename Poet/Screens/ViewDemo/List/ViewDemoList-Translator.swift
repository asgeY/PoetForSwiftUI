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
        var showDemo = Passable<NamedDemoProvider>()
        var showDemoBuilder = PassablePlease()
        
        // State Sink
        private var stateSink: AnyCancellable?
        
        init(_ state: PassableState<Evaluator.State>) {
            stateSink = state.subject.sink { [weak self] value in
                self?.translate(state: value)
            }
        }
    }
}

extension ViewDemoList.Translator {
    func translate(state: Evaluator.State) {
        switch state {
            
        case .initial:
            break // no initial setup needed
            
        case .list(let state):
            translateList(state)
        }
    }
    
    func translateList(_ state: Evaluator.ListState) {
        // Set observable display state
        demoProviders.array = state.demoProviders
    }
}
