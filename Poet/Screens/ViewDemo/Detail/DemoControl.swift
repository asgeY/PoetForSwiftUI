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
    struct Text: DemoControlType {
        let evaluator: TextFieldEvaluating
        let elementName: EvaluatorElement
        let input: EvaluatingTextField.Input
        let initialText: String
        
        func view() -> AnyView {
            return AnyView(
                DemoControlView_ObservableControlledByTextInput(
                    evaluator: evaluator,
                    elementName: elementName,
                    input: input,
                    initialText: initialText)
            )
        }
    }
    
    struct Buttons<T>: DemoControlType where T: Equatable {
        let observable: Observable<T>
        let choices: [NamedIdentifiedValue<T>]
        
        func view() -> AnyView {
            return AnyView(
                DemoControlView_ButtonChoices(
                    buttons: choices,
                    preference: observable
                )
            )
        }
    }
    
    struct Toggle: DemoControlType {
        let evaluator: ToggleEvaluating
        let elementName: EvaluatorElement
        var title = ObservableString()
        let initialValue: Bool
        
        init(evaluator: ToggleEvaluating, elementName: EvaluatorElement, title: String, initialValue: Bool) {
            self.evaluator = evaluator
            self.elementName = elementName
            self.title.string = title
            self.initialValue = initialValue
        }
        
        func view() -> AnyView {
            return AnyView(
                DemoControlView_Toggle(
                    title: title,
                    elementName: elementName,
                    initialValue: initialValue,
                    evaluator: evaluator)
            )
        }
    }
}
