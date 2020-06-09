//
//  ObservingTextField.swift
//  Poet
//
//  Created by Steve Cotner on 5/28/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine
import SwiftUI

protocol TextFieldEvaluating {
    func textFieldDidChange(text: String, elementName: EvaluatorElement)
}

struct EvaluatingTextField: View {
    let placeholder: String
    @ObservedObject var isValid = ObservableBool()
    @ObservedObject var validationMessage = ObservableString()
    var shouldShowValidation: Bool = false
    let elementName: EvaluatorElement
    let isSecure: Bool
    let input: Input
    @State var fieldText = ObservableString()
    let evaluator: TextFieldEvaluating
    
    @State var validationSink: AnyCancellable?
    private var passableText: PassableString = PassableString()
    
    @State private var storedText: String = ""
    @State private var validationImageName: String = "checkmark.circle"
    @State private var validationImageColor: Color = Color.clear
    @State private var shouldShowValidationMessage = false
    @State private var shouldShowValidationMark = false
    
    enum Input {
        case text
        case number
    }
    
    init(placeholder: String, elementName: EvaluatorElement, isSecure: Bool, input: Input = .text, evaluator: TextFieldEvaluating, validation: ObservableValidation? = nil, passableText: PassableString? = nil) {
        self.placeholder = placeholder
        self.elementName = elementName
        self.isSecure = isSecure
        self.input = input
        self.evaluator = evaluator
        if let passableText = passableText {
            self.passableText = passableText
        }
        
        if let validation = validation {
            self.isValid = validation.isValid
            self.validationMessage = validation.message
            self.shouldShowValidation = true
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                HStack(spacing: 10) {
                    textField(isSecure: isSecure, input: input)
                    TextFieldClearButton(text: self.fieldText, passableText: self.passableText)
                }
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.primary.opacity(0.05))
                )
                    .padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 50))
                .onReceive(fieldText.objectDidChange) {
                    self.evaluator.textFieldDidChange(text: self.fieldText.string, elementName: self.elementName)
                }
                
                HStack {
                    Spacer()
                    Group {
                        if shouldShowValidation {
                            Image(systemName: validationImageName)
                                .resizable()
                                .frame(width: self.shouldShowValidationMark ? 21 : 18, height: self.shouldShowValidationMark ? 21 : 18)
                                .opacity(self.shouldShowValidationMark ? 1 : 0)
                                .animation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0), value: self.shouldShowValidationMark)
                                .foregroundColor(validationImageColor)
                            
                        } else {
                            EmptyView()
                        }
                    }
                    .frame(width: 21, height: 21)
                    Spacer().frame(width:20)
                }
            }
            
            HStack {
                Spacer().frame(width: 50)
                if shouldShowValidation {
                    VStack {
                        Text(validationMessage.string)
                            .font(Font.caption.bold())
                            .foregroundColor(Color(UIColor.systemRed))
                            .fixedSize(horizontal: true, vertical: true)
                            .padding(.top, 10)
                            .animation(.none)
                    }
                    
                    .opacity(self.shouldShowValidationMessage ? 1 : 0)
                    .frame(width: nil, height: self.shouldShowValidationMessage ? nil : 0)
                    .animation(.linear, value: self.isValid.bool)
                }
                Spacer()
            }
        }
        .padding(.bottom, 14)
        .onReceive(fieldText.objectDidChange) {
            if self.fieldText.string == self.storedText { return }
            self.storedText = self.fieldText.string

            self.validationSink = self.isValid.$value.debounce(for: 0.35, scheduler: DispatchQueue.main).sink { (value) in
                if self.fieldText.string.isEmpty {
                    self.shouldShowValidationMessage = false
                    self.shouldShowValidationMark = false
                    return
                }
                self.validationImageName = (value == true ? "checkmark.circle" : "exclamationmark.circle")
                self.validationImageColor = (value == true ? Color(UIColor.systemGreen) : Color(UIColor.systemRed))
                self.shouldShowValidationMark = true
                self.shouldShowValidationMessage = (value == false)
                self.validationSink?.cancel()
            }
        }
        .onReceive(self.passableText.subject) { (string) in
            if let string = string {
                self.fieldText.string = string
            }
        }
    }
    
    func textField(isSecure: Bool, input: Input) -> AnyView {
        switch isSecure {
        case true:
            return AnyView(
                SecureField(placeholder, text: self.$fieldText.string)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .keyboardType(
                        {
                            switch input {
                            case .number:
                                return .decimalPad
                            case .text:
                                return .default
                            }
                        }()
                )
            )
        case false:
            return AnyView(
                TextField(placeholder, text: self.$fieldText.string)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .keyboardType(
                        {
                            switch input {
                            case .number:
                                return .asciiCapableNumberPad
                            case .text:
                                return .default
                        }
                    }()
                )
            )
        }
    }
}

struct TextFieldClearButton: View {
    @ObservedObject var text: ObservableString
    var passableText: PassableString
    
    var body: some View {
        Button(action: {
            self.passableText.string = ""
        }) {
            Image(systemName: "multiply.circle.fill")
                .resizable()
                .frame(width: 14, height: 14)
                .opacity((text.string.isEmpty) ? 0 : 0.3)
                .foregroundColor(.primary)
        }
    }
}
