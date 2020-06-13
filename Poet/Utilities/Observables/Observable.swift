//
//  Observable.swift
//  Poet
//
//  Created by Steve Cotner on 5/22/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine
import Foundation

class Observable<T>: ObservableObject {
    let objectDidChange = ObservableObjectPublisher()
    
    @Published var value: T {
        didSet {
            objectDidChange.send()
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
}

extension Observable: DeepCopying {
    func deepCopy() -> Self {
        if let value = value as? DeepCopying, let copiedValue = value.deepCopy() as? T {
            return Observable(copiedValue) as! Self
        }
        return Observable(value) as! Self
    }
}

extension Observable: Equatable where T: Equatable {
    static func == (lhs: Observable<T>, rhs: Observable<T>) -> Bool {
        return lhs.value == rhs.value
    }
}

extension Observable where T: ExpressibleByNilLiteral {
    convenience init() {
        self.init(nil)
    }
}
