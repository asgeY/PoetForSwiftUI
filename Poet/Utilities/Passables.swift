//
//  Passables.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/19/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine
import Foundation

class PassableString {
    var subject = PassthroughSubject<String?, Never>()
    var string: String? {
        willSet {
            subject.send(newValue)
        }
    }
}

class PassableDouble {
    var subject = PassthroughSubject<Double?, Never>()
    var double: Double? {
        willSet {
            subject.send(newValue)
        }
    }
}

class PassableInt {
    var subject = PassthroughSubject<Int?, Never>()
    var int: Int? {
        willSet {
            subject.send(newValue)
        }
    }
}

class PassableArray<T>: ObservableObject {
    var subject = PassthroughSubject<[T]?, Never>()
    var array: [T]? {
        willSet {
            subject.send(newValue)
        }
    }
}

class PassablePlease {
    var subject = PassthroughSubject<Any?, Never>()
    func please() {
        subject.send(nil)
    }
}

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
