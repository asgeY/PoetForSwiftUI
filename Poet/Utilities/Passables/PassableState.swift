//
//  PassableState.swift
//  Poet
//
//  Created by Steve Cotner on 5/22/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine

class PassableState<S: EvaluatorState> {
    var subject = PassthroughSubject<S, Never>()
    
    var state: S {
        willSet {
            subject.send(newValue)
        }
    }
        
    init(_ state: S) {
        self.state = state
    }
}
