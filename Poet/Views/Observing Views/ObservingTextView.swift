//
//  ObservingTextView.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/24/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct ObservingTextView: View {
    
    @ObservedObject var text: ObservableString
    var alignment: TextAlignment?
    var kerning: CGFloat
    
    
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

// MARK: Demo

extension ObservingTextView: ViewDemoing {
    static var demoProvider: DemoProvider { return ObservingTextView_DemoProvider() }
}

struct ObservingTextView_DemoProvider: DemoProvider, TextFieldEvaluating {
    typealias TextAlignmentNamedValue = NamedIdentifiedValue<TextAlignment>
    var text = ObservableString("Hello")
    var alignment = Observable<TextAlignment>(.leading)
    var kerning = Observable<CGFloat>(0.0)
    
    func deepCopy() -> Self {
        let provider = ObservingTextView_DemoProvider(
            text: self.text.deepCopy(),
            alignment: self.alignment.deepCopy(),
            kerning: self.kerning.deepCopy()
        )
        return provider
    }
    
    enum Element: EvaluatorElement {
        case textField
        case kerningField
    }
    
    var contentView: AnyView {
        AnyView(
            Observer2(alignment, kerning) { alignment, kerning in
                ObservingTextView(
                    self.text,
                    alignment: alignment,
                    kerning: kerning
                )
            }
        )
    }
    
    var controls: [DemoControl] {
        [
            DemoControl(
                title: "Text",
                type: DemoControl.Text(
                    evaluator: self, elementName: Element.textField, input: .text
                )
            ),
            
            DemoControl(
                title: "Kerning",
                instruction: "Type any number, positive or negative.",
                type: DemoControl.Text(evaluator: self, elementName: Element.kerningField, input: .text
                )
            ),
            
            DemoControl(
                title: "Alignment",
                type: DemoControl.Buttons(
                    observable: self.alignment,
                    choices:
                    [
                        TextAlignmentNamedValue(
                            title: "Leading",
                            value: TextAlignment.leading
                        ),
                        
                        TextAlignmentNamedValue(
                            title: "Center",
                            value: TextAlignment.center
                        ),
                        
                        TextAlignmentNamedValue(
                            title: "Trailing",
                            value: TextAlignment.trailing
                        )
                    ]
                )
            ),
        ]
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
}

// MARK: Preview

struct ObservingTextView_Previews: PreviewProvider {
    static var previews: some View {
        ObservingTextView(ObservableString("Hello"), alignment: .leading)
    }
}
