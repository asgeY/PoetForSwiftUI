//
//  ObservableArray.swift
//  Poet
//
//  Created by Steve Cotner on 5/22/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine

typealias ObservableArray<A> = Observable<Array<A>>

extension ObservableArray {
    var array: T {
        get {
            return self.value
        }
        set {
            self.value = newValue
        }
    }
}


