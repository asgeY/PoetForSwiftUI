//
//  Template-Translator.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/2/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine
import Foundation

extension Template {

    class Translator {
        
        typealias Evaluator = Template.Evaluator
        
        // Observable Display State
        var title = ObservableString()
        var body = ObservableString()
        
        // State Sink
        private var stateSink: AnyCancellable?
        
        init(_ state: PassableState<Evaluator.State>) {
            stateSink = state.subject.sink { [weak self] value in
                self?.translate(state: value)
            }
        }
    }
}

extension Template.Translator {
    func translate(state: Evaluator.State) {
        switch state {
        
        case .initial:
            // no initial setup needed
            break
            
        case .text(let state):
            translateTextState(state)
        }
    }
    
    func translateTextState(_ state: Evaluator.TextState) {
        
        // Set observable display state
        
        title.string = state.title
        body.string = state.body
    }
}
