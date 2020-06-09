//
//  ObservableEvaluatorAction.swift
//  Poet
//
//  Created by Steve Cotner on 5/26/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine

typealias ObservableEvaluatorAction = Observable<EvaluatorAction?>

extension ObservableEvaluatorAction {
    var action: EvaluatorAction? {
        get {
            return self.value
        }
        set {
            self.value = newValue
        }
    }
}
