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

// MARK: View Demoing

extension ObservingTextView: ViewDemoing {
    static var demoProvider: DemoProvider { return ObservingTextView_DemoProvider() }
}

struct ObservingTextView_DemoProvider: DemoProvider, TextFieldEvaluating {
    typealias TextAlignmentNamedValue = NamedIdentifiedValue<TextAlignment>
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
            Observer2(observableA: self.alignment, observableB: self.kerning) { alignment, kerning in
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
                type: .text(
                    observable: self.text,
                    evaluator: self,
                    elementName: Element.textField,
                    input: .text
                )
            ),
            
            DemoControl(
                title: "Kerning",
                instruction: "Type any number, positive or negative.",
                type: .text(
                    observable: self.kerning,
                    evaluator: self,
                    elementName: Element.kerningField,
                    input: .text
                )
            ),
            
            DemoControl(
                title: "Alignment",
                type: .buttons(
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
}

struct ObservingTextView_Previews: PreviewProvider {
    static var previews: some View {
        ObservingTextView(ObservableString("Hello"), alignment: .leading)
    }
}
