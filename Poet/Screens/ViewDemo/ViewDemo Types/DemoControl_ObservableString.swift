//
//  DemoControl_ObservableString.swift
//  Poet
//
//  Created by Steve Cotner on 6/6/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct DemoControl_ObservableString: View {
    @ObservedObject var observable: ObservableString
    let evaluator: TextFieldEvaluating
    let elementName: EvaluatorElement
    
    var body: some View {
        EvaluatingTextField(placeholder: "", elementName: elementName, isSecure: false, evaluator: evaluator)
            .padding(.bottom, -10)
    }
}
