//
//  ObservableNamedEvaluatorAction.swift
//  Poet
//
//  Created by Steve Cotner on 5/22/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine

class ObservableNamedEvaluatorAction: ObservableObject {
    @Published var action: NamedEvaluatorAction?
    
    init(_ action: NamedEvaluatorAction? = nil) {
        self.action = action
    }
}
