//
//  PassableInt.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/19/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine

class PassableInt {
    var subject = PassthroughSubject<Int?, Never>()
    var int: Int? {
        willSet {
            subject.send(newValue)
        }
    }
}
