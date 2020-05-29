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
    let placeholder: String
    @ObservedObject var text: ObservableString
    @ObservedObject var isValid: ObservableBool
    @ObservedObject var validationMessage: ObservableString
    let shouldShowValidation: Bool
    let elementName: EvaluatorElement
    let isSecure: Bool
    @State var fieldText = ObservableString()
    weak var evaluator: TextFieldEvaluating?
    
    @State var behavior: Behavior?
    
    @State private var storedText: String = ""
    @State private var validationImageName: String = ""
    @State private var validationImageColor: Color = Color.clear
    @State private var shouldShowValidationMessage = false
    @State private var shouldShowValidationMark = false
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                textField(isSecure: isSecure)
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.primary.opacity(0.05))
                )
                    .padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 50))
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
                    Text(validationMessage.string)
                        .font(Font.caption.bold())
                        .foregroundColor(Color(UIColor.systemRed))
                        .frame(height: self.shouldShowValidationMessage ? nil : 0) // self.isValid.bool || self.text.string.isEmpty ? 0 : nil)
                        .opacity(self.shouldShowValidationMessage ? 1 : 0)
                        .padding(.top, self.shouldShowValidationMessage ? 10 : 0)
                        .animation(.linear, value: self.isValid.bool == false)
                }
                Spacer()
            }
        }
        .padding(.bottom, 14)
        .onReceive(text.objectWillChange) {
            if self.text.string == self.storedText { return }
            self.storedText = self.text.string
            
            self.behavior = self.isValid.$bool.debounce(for: 0.35, scheduler: DispatchQueue.main).sink { (value) in
                if self.text.string.isEmpty {
                    self.shouldShowValidationMessage = false
                    self.shouldShowValidationMark = false
                    return
                }
                self.validationImageName = (value == true ? "checkmark.circle" : "xmark.circle")
                self.validationImageColor = (value == true ? Color(UIColor.systemGreen) : Color(UIColor.systemRed))
                self.shouldShowValidationMark = true
                self.shouldShowValidationMessage = (value == false)
                self.behavior?.cancel()
            }
        }
    }
    
    func textField(isSecure: Bool) -> AnyView {
        switch isSecure {
        case true:
            return AnyView(
                SecureField(placeholder, text: self.$fieldText.string)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            )
        case false:
            return AnyView(
                TextField(placeholder, text: self.$fieldText.string)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            )
        }
    }
}
