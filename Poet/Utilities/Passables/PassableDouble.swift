//
//  PassableDouble.swift
//  Poet
//
//  Created by Steve Cotner on 5/22/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine

class PassableDouble {
    var subject = PassthroughSubject<Double?, Never>()
    var double: Double? {
        willSet {
            subject.send(newValue)
        }
    }
}
