//
//  ObservableString.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/19/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine

typealias ObservableString = Observable<String>

extension ObservableString {
    var string: String {
        get {
            return self.value
        }
        set {
            self.value = newValue
        }
    }
    
    convenience init() {
        self.init("")
    }
}
