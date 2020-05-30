//
//  ObservableValidation.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/29/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

struct ObservableValidation {
    var isValid = ObservableBool()
    var message = ObservableString()
}
