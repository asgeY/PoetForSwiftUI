//
//  ObservableBool.swift
//  Poet
//
//  Created by Steve Cotner on 5/22/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine

class ObservableBool: ObservableObject, Equatable {
    @Published var bool: Bool
    
    static func == (lhs: ObservableBool, rhs: ObservableBool) -> Bool {
        return lhs.bool == rhs.bool
    }
    
    init(_ bool: Bool = false) {
        self.bool = bool
    }
}
