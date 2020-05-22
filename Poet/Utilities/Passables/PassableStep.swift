//
//  PassableStep.swift
//  Poet
//
//  Created by Steve Cotner on 5/22/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine

class PassableStep<S: EvaluatorStep> {
    var subject = PassthroughSubject<S, Never>()
    
    var step: S {
        willSet {
            subject.send(newValue)
        }
    }
        
    init(_ step: S) {
        self.step = step
    }
}
