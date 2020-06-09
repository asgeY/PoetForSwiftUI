//
//  ObservableNamedEnabledEvaluatorAction.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/28/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

typealias ObservableNamedEnabledEvaluatorAction = Observable<NamedEnabledEvaluatorAction?>

extension ObservableNamedEnabledEvaluatorAction {
    var namedEnabledAction: NamedEnabledEvaluatorAction? {
        get {
            return self.value
        }
        set {
            self.value = newValue
        }
    }
}
