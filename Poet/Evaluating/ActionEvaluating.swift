//
//  ActionEvaluating.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/16/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

protocol ActionEvaluating {
    associatedtype Action: EvaluatorAction
    func evaluate(_ action: Action?)
    func _evaluate(_ action: Action)
}

extension ActionEvaluating {
    func evaluate(_ action: Action?) {
        if let action = action {
            breadcrumb(action)
            _evaluate(action)
        }
    }
    
    func breadcrumb(_ action: Action) {
        debugPrint("breadcrumb. evaluator: \(self) action: \(action.breadcrumbDescription)")
    }
}
