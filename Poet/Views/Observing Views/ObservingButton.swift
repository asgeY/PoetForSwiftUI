//
//  ObservingButton.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/21/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct ObservingButton<Label>: View where Label : View {
    @ObservedObject var action: ObservableEvaluatorAction
    let evaluator: ActionEvaluating
    var label: () -> Label
    
    init(action: ObservableEvaluatorAction,
         evaluator: ActionEvaluating,
         @ViewBuilder label: @escaping () -> Label) {
        self.action = action
        self.evaluator = evaluator
        self.label = label
    }

    var body: some View {
        return Button(
            action: { self.evaluator.evaluate(self.action.action) },
            label: label
        )
    }
}
