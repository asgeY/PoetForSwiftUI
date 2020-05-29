//
//  ObservableNamedEnabledEvaluatorAction.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/28/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

class ObservableNamedEnabledEvaluatorAction: ObservableObject {
    @Published var namedEnabledAction: NamedEnabledEvaluatorAction?
    
    init(_ action: NamedEnabledEvaluatorAction? = nil) {
        self.namedEnabledAction = action
    }
}
