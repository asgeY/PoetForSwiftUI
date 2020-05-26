//
//  ObservableEvaluatorAction.swift
//  Poet
//
//  Created by Steve Cotner on 5/26/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine

class ObservableEvaluatorAction: ObservableObject {
    @Published var action: EvaluatorAction?
    
    init(_ action: EvaluatorAction? = nil) {
        self.action = action
    }
}
