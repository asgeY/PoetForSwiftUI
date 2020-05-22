//
//  ObservableDouble.swift
//  Poet
//
//  Created by Steve Cotner on 5/22/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine

class ObservableDouble: ObservableObject {
    @Published var double: Double
    
    init(_ double: Double = 0.0) {
        self.double = double
    }
}
