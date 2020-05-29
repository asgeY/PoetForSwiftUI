//
//  ObservingTextField.swift
//  Poet
//
//  Created by Steve Cotner on 5/28/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

protocol TextFieldEvaluating: class {
    func textFieldDidChange(text: String, elementName: EvaluatorElement)
}

struct ObservingTextField: View {
    @ObservedObject var title: ObservableString
    @ObservedObject var text: ObservableString
    let elementName: EvaluatorElement
    @State var fieldText = ObservableString()
    weak var evaluator: TextFieldEvaluating?
    
    init(title: ObservableString, text: ObservableString, elementName: EvaluatorElement, evaluator: TextFieldEvaluating?) {
        self.title = title
        self.text = text
        self.elementName = elementName
        self.evaluator = evaluator
    }
    
    var body: some View {
        TextField(title.string, text: self.$fieldText.string)
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.primary.opacity(0.05))
            )
            .padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
            .onReceive(text.objectDidChange) {
                if self.text.string != self.fieldText.string {
                    self.fieldText.string = self.text.string
                }
            }
            .onReceive(fieldText.objectDidChange) {
                if self.fieldText.string != self.text.string {
                    self.evaluator?.textFieldDidChange(text: self.fieldText.string, elementName: self.elementName)
                }
            }
    }
}
