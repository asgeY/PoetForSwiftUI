//
//  DemoControlView_ObservableControlledByTextInput.swift
//  Poet
//
//  Created by Steve Cotner on 6/6/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct DemoControlView_ObservableControlledByTextInput<T>: View {
    @ObservedObject var observable: Observable<T>
    let evaluator: TextFieldEvaluating
    let elementName: EvaluatorElement
    let input: EvaluatingTextField.Input
    
    var body: some View {
        EvaluatingTextField(placeholder: "", elementName: elementName, isSecure: false, input: input, evaluator: evaluator)
            .padding(.bottom, -10)
    }
}

