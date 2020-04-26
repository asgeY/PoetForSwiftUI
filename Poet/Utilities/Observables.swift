//
//  Observables.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/19/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine
import Foundation

class ObservableString: ObservableObject {
    @Published var string: String = ""
    
    init() {}
    
    init(_ string: String) {
        self.string = string
    }
}

class ObservableBool: ObservableObject {
    @Published var bool: Bool = false
    
    init() {}
    
    init(_ bool: Bool) {
        self.bool = bool
    }
}

class ObservableDouble: ObservableObject {
    @Published var double: Double
    
    init() {
        double = 0.0
    }
    
    init(_ double: Double) {
        self.double = double
    }
}

class ObservableURL: ObservableObject {
    @Published var url: URL?
    
    init() {}
    
    init(_ url: URL) {
        self.url = url
    }
}

class ObservableArray<T>: ObservableObject {
    @Published var array: [T]
    
    init(_ array: [T]) {
        self.array = array
    }
}
