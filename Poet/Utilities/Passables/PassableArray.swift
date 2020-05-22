//
//  PassableArray.swift
//  Poet
//
//  Created by Steve Cotner on 5/22/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine

class PassableArray<T>: ObservableObject {
    var subject = PassthroughSubject<[T]?, Never>()
    var array: [T]? {
        willSet {
            subject.send(newValue)
        }
    }
}
