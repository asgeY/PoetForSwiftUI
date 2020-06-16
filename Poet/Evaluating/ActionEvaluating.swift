//
//  ActionEvaluating.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/16/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

protocol ActionEvaluating {
    func evaluate(_ action: EvaluatorAction?)
    func _evaluate(_ action: EvaluatorAction?)
}

extension ActionEvaluating {
    func evaluate(_ action: EvaluatorAction?) {
        breadcrumb(action)
        _evaluate(action)
    }
    
    func breadcrumb(_ action: EvaluatorAction?) {
        if let action = action {
            debugPrint("breadcrumb. evaluator: \(self) action: \(action.breadcrumbDescription)")
        }
    }
}
