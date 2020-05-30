//
//  PassableBool.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/29/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine

class PassableBool {
    var subject = PassthroughSubject<Bool?, Never>()
    var bool: Bool? {
        willSet {
            subject.send(newValue)
        }
    }
    
    func isTrue() {
        self.bool = true
    }
    
    func isFalse() {
        self.bool = false
    }
}

