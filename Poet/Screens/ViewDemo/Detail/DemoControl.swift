//
//  DemoControl.swift
//  Poet
//
//  Created by Steve Cotner on 6/6/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct DemoControl {
    let title: String
    var instruction: String?
    let view: AnyView
    let id: UUID
    
    init(title: String, instruction: String? = nil, type: DemoControlType) {
        self.title = title
        self.instruction = instruction
        self.id = UUID()
        self.view = type.view()
    }
}

protocol DemoControlType {
    func view() -> AnyView
}

extension DemoControl {
    struct Text<T>: DemoControlType {
        let observable: Observable<T>
        let evaluator: TextFieldEvaluating
        let elementName: EvaluatorElement
        let input: EvaluatingTextField.Input
        
        func view() -> AnyView {
            return AnyView(
                DemoControl_ObservableControlledByTextInput(
                    observable: observable,
                    evaluator: evaluator,
                    elementName: elementName,
                    input: input)
            )
        }
    }
    
    struct Buttons<T>: DemoControlType where T: Equatable {
        let observable: Observable<T>
        let choices: [NamedIdentifiedValue<T>]
        
        func view() -> AnyView {
            return AnyView(
                DemoControl_ButtonChoices(
                    buttons: choices,
                    preference: observable
                )
            )
        }
    }
}
