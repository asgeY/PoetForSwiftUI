//
//  TextValidation.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/29/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

struct TextValidation {
    var isValid = false
    var message: String = ""
    var conditions: [Condition]
    
    init(_ conditions: [Condition]) {
        self.conditions = conditions
    }
    
    struct Condition {
        var message: String
        var validationClosure: (String) -> Bool
        
        init(message: String, validationClosure: @escaping (String) -> Bool) {
            self.message = message
            self.validationClosure = validationClosure
        }
    }
    
    mutating func validate(text: String) {
        for condition in conditions {
            if condition.validationClosure(text) == false {
                isValid = false
                message = condition.message
                return
            }
        }
        isValid = true
    }
}
