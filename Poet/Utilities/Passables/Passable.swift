//
//  Passable.swift
//  Poet
//
//  Created by Steve Cotner on 5/22/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine

class Passable<S> {
    var subject = PassthroughSubject<S, Never>()
    
    var value: S {
        willSet {
            subject.send(newValue)
        }
    }
        
    init(_ value: S) {
        self.value = value
    }
}

