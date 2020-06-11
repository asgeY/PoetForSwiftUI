//
//  OptionsView.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/21/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct OptionsView: View {
    @ObservedObject var options: ObservableArray<String>
    @ObservedObject var preference: ObservableString
    let evaluator: OptionsEvaluating
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(options.array, id: \.self) { option in
                VStack(alignment: .leading, spacing: 0) {
                    OptionView(option: option, preference: self.preference.string, evaluator: self.evaluator)
                    Spacer().frame(height: 16)
                }
            }
        }
    }
}

struct OptionView: View {
    let option: String
    let preference: String
    let evaluator: OptionsEvaluating
    
    var body: some View {
        let isSelected = self.option == self.preference
        return Button(action: {
            self.evaluator.toggleOption(self.option)
        }) {
            HStack(spacing: 0) {
                ZStack(alignment: .topLeading) {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.primary)
                        .frame(width: isSelected ? 25.5 : 23, height: isSelected ? 25.5 : 23)
                        .animation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0), value: isSelected)
                        .padding(EdgeInsets(top: isSelected ? 0 : 1.25, leading: isSelected ? 38.75 : 40, bottom: isSelected ? 0 : 1.25, trailing: 0))
                    Text(self.option)
                        .font(Font.headline)
                        .layoutPriority(20)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(EdgeInsets(top: 1.25, leading: 76, bottom: 0, trailing: 76))
                }
                Spacer()
            }
        }
        .padding(0)
        .foregroundColor(.primary)
    }
}

// MARK: View Demoing

extension OptionsView: ViewDemoing {
    static var demoProvider: DemoProvider { return OptionsView_DemoProvider() }
}

struct OptionsView_DemoProvider: DemoProvider, OptionsEvaluating, TextFieldEvaluating {
    var text = ObservableString()
    var options = ObservableArray<String>(["OptionA", "OptionB"])
    var preference = ObservableString()
    
    enum Element: EvaluatorElement {
        case optionsTextField
    }
    
    func deepCopy() -> Self {
        let provider = OptionsView_DemoProvider(
            text: self.text.deepCopy(),
            options: self.options.deepCopy(),
            preference: self.preference.deepCopy()
        )
        return provider
    }
    
    var contentView: AnyView {
        return AnyView(
            OptionsView(
                options: self.options,
                preference: self.preference,
                evaluator: self)
        )
    }
    
    var controls: [DemoControl] {
        [
            DemoControl(
                title: "Options",
                instruction: "Type words separated by semicolons to add options.",
                type: DemoControl.Text(evaluator: self, elementName: Element.optionsTextField, input: .text))
        ]
    }
    
    func toggleOption(_ option: String) {
        if preference.string == option {
            preference.string = ""
        } else {
            preference.string = option
        }
    }
    
    func textFieldDidChange(text: String, elementName: EvaluatorElement) {
        self.text.string = text
        let splitText = text.split(separator: ";").map { String($0) }
        if splitText.isEmpty {
            self.options.array = [" "]
        } else {
            self.options.array = splitText
        }
    }
}
