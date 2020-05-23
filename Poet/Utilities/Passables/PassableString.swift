//
//  PassableString.swift
//  Poet
//
//  Created by Steve Cotner on 5/22/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine

class PassableString {
    var subject = PassthroughSubject<String?, Never>()
    var string: String? {
        willSet {
            subject.send(newValue)
        }
    }
    
    func withString(_ string: String) {
        self.string = string
    }
}
