//
//  ObservableString.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/19/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine

class ObservableString: ObservableObject {
    @Published var string: String
    
    init(_ string: String = "") {
        self.string = string
    }
}
