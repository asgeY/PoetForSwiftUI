//
//  DemoControlView_Toggle.swift
//  Poet
//
//  Created by Stephen E. Cotner on 6/15/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct EvaluatingToggle: View {
    @ObservedObject var title: ObservableString
    let elementName: EvaluatorElement
    @ObservedObject private var isOn = ObservableBool()
    private var passableBool: PassableBool // <-- Not yet used. This will allow setting the bool imperatively.
    let evaluator: ToggleEvaluating
    
    init(title: ObservableString, elementName: EvaluatorElement, initialValue: Bool, passableBool: PassableBool? = nil, evaluator: ToggleEvaluating) {
        self.title = title
        self.elementName = elementName
        self.passableBool = passableBool ?? PassableBool()
        self.evaluator = evaluator
        self.isOn.bool = initialValue
    }
    
    var body: some View {
        Toggle(isOn: $isOn.bool) {
            Text(title.string)
        }
            .onReceive(isOn.objectDidChange) {
                self.evaluator.toggleDidChange(bool: self.isOn.bool, elementName: self.elementName)
        }
    }
}

protocol ToggleEvaluating {
    func toggleDidChange(bool: Bool, elementName: EvaluatorElement)
}

struct DemoControlView_Toggle: View {
    @ObservedObject var title: ObservableString
    let elementName: EvaluatorElement
    let initialValue: Bool
    let evaluator: ToggleEvaluating
    
    
    var body: some View {
        return ScrollView(.horizontal, showsIndicators: false) {
            EvaluatingToggle(title: title, elementName: elementName, initialValue: initialValue, evaluator: evaluator)
                .padding(.leading, 50)
                .padding(.trailing, 50)
                
        }
        .font(Font.caption.bold())
        .foregroundColor(.primary)
    }
}
