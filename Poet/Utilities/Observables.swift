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
    @Published var string: String
    
    init(_ string: String = "") {
        self.string = string
    }
}

class ObservableBool: ObservableObject, Equatable {
    @Published var bool: Bool
    
    static func == (lhs: ObservableBool, rhs: ObservableBool) -> Bool {
        return lhs.bool == rhs.bool
    }
    
    init(_ bool: Bool = false) {
        self.bool = bool
    }
    
}

class ObservableDouble: ObservableObject {
    @Published var double: Double
    
    init(_ double: Double = 0.0) {
        self.double = double
    }
}

class ObservableInt: ObservableObject {
    @Published var int: Int
    
    init(_ int: Int = 0) {
        self.int = int
    }
}

class ObservableURL: ObservableObject {
    @Published var url: URL?
    
    init(_ url: URL? = nil) {
        self.url = url
    }
}

class ObservableArray<T>: ObservableObject {
    @Published var array: [T]
    
    init(_ array: [T]) {
        self.array = array
    }
}

class ObservableAlertAction: ObservableObject {
    @Published var alertAction: AlertAction?
    
    init(_ alertAction: AlertAction? = nil) {
        self.alertAction = alertAction
    }
}

class ObservableNamedAction: ObservableObject {
    @Published var action: NamedAction?
    
    init(_ action: NamedAction? = nil) {
        self.action = action
    }
}

class ObservableNamedEvaluatorAction: ObservableObject {
    @Published var action: NamedEvaluatorAction?
    
    init(_ action: NamedEvaluatorAction? = nil) {
        self.action = action
    }
}

class Observable<T>: ObservableObject {
    @Published var object: T
    
    init(_ object: T) {
        self.object = object
    }
}
