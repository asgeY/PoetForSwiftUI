//
//  ObservableArray.swift
//  Poet
//
//  Created by Steve Cotner on 5/22/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine

class ObservableArray<T>: ObservableObject {
    @Published var array: [T]
    
    init(_ array: [T]) {
        self.array = array
    }
}
