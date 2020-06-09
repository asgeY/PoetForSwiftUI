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
    let viewMaker: () -> AnyView
    let id: UUID
    
    init<T>(title: String, instruction: String? = nil, type: DemoControlType<T>) where T: Equatable {
        self.title = title
        self.instruction = instruction
        self.id = UUID()
        self.viewMaker = type.viewMaker()
    }
    
    /**
         T must be equatable so button choices to be compared.
         Unfortunately, this makes T equatable for other uses too.
     */
    enum DemoControlType<T> where T: Equatable {
        case text(observable: Observable<T>, evaluator: TextFieldEvaluating, elementName: EvaluatorElement, input: EvaluatingTextField.Input)
        case buttons(observable: Observable<T>, choices: [NamedIdentifiedValue<T>])
        
        func viewMaker() -> () -> AnyView {
            let view: AnyView = {
                switch self {
                    
                case .text(let observable, let evaluator, let elementName, let input):
                    return AnyView(
                        DemoControl_ObservableControlledByTextInput(
                            observable: observable,
                            evaluator: evaluator,
                            elementName: elementName,
                            input: input)
                    )
                    
                case .buttons(let observable, let choices):
                    return AnyView(
                        DemoControl_ButtonChoices(
                            buttons: choices, preference: observable
                        )
                    )
                }
            }()
            
            return { view }
        }
    }
}
