//
//  ObservableInt.swift
//  Poet
//
//  Created by Steve Cotner on 5/22/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine

class ObservableInt: ObservableObject {
    @Published var int: Int
    
    init(_ int: Int = 0) {
        self.int = int
    }
}
