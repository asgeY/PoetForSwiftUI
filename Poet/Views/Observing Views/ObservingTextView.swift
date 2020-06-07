//
//  ObservingTextView.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/24/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct ObservingTextView: View, ViewDemoing {
    
    @ObservedObject var text: ObservableString
    var alignment: TextAlignment?
    var kerning: CGFloat
    static var demoProvider: DemoProvider { return ObservingTextView_DemoProvider() }
    
    init(_ text: ObservableString, alignment: TextAlignment? = nil, kerning: CGFloat = 0) {
        self.text = text
        self.alignment = alignment
        self.kerning = kerning
    }
    
    var body: some View {
        HStack {
            if alignment == .trailing || alignment == .center {
                Spacer()
            }
            
            Text(text.string)
                .kerning(kerning)
                .multilineTextAlignment(alignment ?? .leading)
            
            if alignment == .leading || alignment == .center {
                Spacer()
            }
        }
    }
}

struct ObservingTextView_DemoProvider: DemoProvider, TextFieldEvaluating {
    var text: ObservableString
    var alignment: Observable<TextAlignment>
    var kerning: Observable<CGFloat>
    
    enum Element: EvaluatorElement {
        case textField
        case kerningField
    }
    
    func textFieldDidChange(text: String, elementName: EvaluatorElement) {
        guard let elementName = elementName as? Element else {
            return
        }
        switch elementName {
        case .textField:
            self.text.string = text
        case .kerningField:
            self.kerning.value = CGFloat(Double(text) ?? 0.0)
        }
    }
    
    init() {
        self.text = ObservableString("Hello")
        self.alignment = Observable<TextAlignment>(.leading)
        self.kerning = Observable<CGFloat>(CGFloat(0.0))
    }
    
    var contentView: AnyView {
        AnyView(
            Observer(observable: self.alignment) { observedAlignment in
            Observer(observable: self.kerning) { observedKerning in
                ObservingTextView(
                    self.text,
                    alignment: observedAlignment,
                    kerning: observedKerning
                )
            }}
        )
    }
    
    var controls: [DemoControl] {
        [
            DemoControl(
                title: "Text",
                viewMaker: { AnyView(DemoControl_ObservableString(
                    observable: self.text,
                    evaluator: self,
                    elementName: Element.textField))}),
         
             DemoControl(
                title: "Kerning",
                instructions: "Type any number, positive or negative.",
                viewMaker: { AnyView(DemoControl_ObservableControlledByTextInput(
                    observable: self.kerning,
                    evaluator: self,
                    elementName: Element.kerningField,
                    input: .text))}),
             
             DemoControl(
                title: "Alignment",
                viewMaker: { AnyView(DemoControl_TextAlignment(
                    observable: self.alignment))})
        ]
    }
}

struct ObservingTextView_Previews: PreviewProvider {
    static var previews: some View {
        ObservingTextView(ObservableString("Hello"), alignment: .leading)
    }
}
