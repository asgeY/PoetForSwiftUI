//
//  DemoControlView_ObservableControlledByTextInput.swift
//  Poet
//
//  Created by Steve Cotner on 6/6/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct DemoControlView_ObservableControlledByTextInput: View {
    let evaluator: TextFieldEvaluating
    let elementName: EvaluatorElement
    let input: EvaluatingTextField.Input
    let initialText: String
    
    var body: some View {
        EvaluatingTextField(placeholder: "", elementName: elementName, isSecure: false, input: input, evaluator: evaluator, initialText: initialText)
            .padding(.bottom, -10)
    }
}

