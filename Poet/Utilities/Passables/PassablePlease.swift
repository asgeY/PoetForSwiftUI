//
//  PassablePlease.swift
//  Poet
//
//  Created by Steve Cotner on 5/22/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine

class PassablePlease {
    var subject = PassthroughSubject<Any?, Never>()
    func please() {
        subject.send(nil)
    }
}
