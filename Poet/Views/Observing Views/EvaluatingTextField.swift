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
    @ObservedObject var fieldText = ObservableString()
    let evaluator: TextFieldEvaluating
    
    @State var validationSink: AnyCancellable?
    private var passableText: PassableString = PassableString()
    
    @State private var lastValidatedText: String = ""
    let validIconImageName: String = "checkmark.circle"
    let invalidIconImageName: String = "exclamationmark.circle"
    let validColor: Color = Color(UIColor.systemGreen)
    let invalidColor: Color = Color(UIColor.systemRed)
    @State private var validationImageColor: Color = Color.clear
    @State private var shouldShowValidationMessage = false
    @State private var shouldShowValidationMark = false
    @State private var shouldShowCheckmark = false
    @State private var shouldShowExclamationMark = false
    
    enum Input {
        case text
        case number
    }
    
    init(placeholder: String, elementName: EvaluatorElement, isSecure: Bool, input: Input = .text, evaluator: TextFieldEvaluating, initialText: String? = nil, validation: ObservableValidation? = nil, passableText: PassableString? = nil) {
        self.placeholder = placeholder
        self.elementName = elementName
        self.isSecure = isSecure
        self.input = input
        self.evaluator = evaluator
        if let initialText = initialText {
            self.fieldText.string = initialText
        }
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
                    ZStack {
                        
                        if shouldShowCheckmark {
                            Image(systemName: validIconImageName)
                                .resizable()
                                .opacity(shouldShowCheckmark ? 1 : 0)
                                .frame(width: shouldShowCheckmark ? 21 : 15, height: shouldShowCheckmark ? 21 : 15)
//                                .transition(AnyTransition.asymmetric(insertion: AnyTransition.opacity.combined(with: AnyTransition.scale(scale: 0.9)), removal: AnyTransition.opacity.combined(with: AnyTransition.scale(scale: 0.85))))
                                .animation(.spring(response: 0.1, dampingFraction: 0.6, blendDuration: 0), value: shouldShowCheckmark)
                                .foregroundColor(validColor)
                        }
                        
                        if shouldShowExclamationMark {
                            Image(systemName: invalidIconImageName)
                                .resizable()
                                .opacity(shouldShowExclamationMark ? 1 : 0)
                                .frame(width: shouldShowExclamationMark ? 21 : 15, height: shouldShowExclamationMark ? 21 : 15)
//                                .transition(AnyTransition.asymmetric(insertion: AnyTransition.opacity.combined(with: AnyTransition.scale(scale: 0.9)), removal: AnyTransition.opacity.combined(with: AnyTransition.scale(scale: 0.85))))
                                .animation(.spring(response: 0.1, dampingFraction: 0.6, blendDuration: 0), value: shouldShowExclamationMark)
                                .foregroundColor(invalidColor)
                        }
                            
                        EmptyView()
                    }
                    
                    .frame(width: 21, height: 21)
                    Spacer().frame(width:20)
                }
            }
            
            HStack {
                Spacer().frame(width: 50)
                Group {
                    if shouldShowValidation && self.shouldShowValidationMessage {
                        Text(validationMessage.string)
                                .font(Font.caption.bold())
                                .foregroundColor(Color(UIColor.systemRed))
                                .fixedSize(horizontal: true, vertical: true)
                                .padding(.top, 10)
                                .animation(.none)
                                .transition(.opacity)
                    }
                }
                .animation(.linear)
                Spacer()
            }
        }
        .padding(.bottom, 10)
        .onReceive(fieldText.objectDidChange) {
            if self.fieldText.string == self.lastValidatedText { return }
            self.lastValidatedText = self.fieldText.string

            self.validationSink = self.isValid.$value.debounce(for: 0.35, scheduler: DispatchQueue.main).sink { (value) in
                if self.fieldText.string.isEmpty {
                    self.shouldShowValidationMessage = false
                    self.shouldShowValidationMark = false
                    self.shouldShowCheckmark = false
                    self.shouldShowExclamationMark = false
                    return
                }
                self.shouldShowValidationMark = true
                self.shouldShowValidationMessage = (value == false)
                self.shouldShowCheckmark = value
                self.shouldShowExclamationMark = (value == false)
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
