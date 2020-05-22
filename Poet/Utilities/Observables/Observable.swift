//
//  Observable.swift
//  Poet
//
//  Created by Steve Cotner on 5/22/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine

class Observable<T>: ObservableObject {
    @Published var value: T
    
    init(_ value: T) {
        self.value = value
    }
}
