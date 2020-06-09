//
//  ObservableInt.swift
//  Poet
//
//  Created by Steve Cotner on 5/22/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine

typealias ObservableInt = Observable<Int>

extension ObservableInt {
    var int: Int {
        get {
            return self.value
        }
        set {
            self.value = newValue
        }
    }
    
    convenience init() {
        self.init(0)
    }
}
