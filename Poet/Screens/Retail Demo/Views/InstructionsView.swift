//
//  InstructionsView.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/21/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct InstructionsView: View {
    @ObservedObject var instructions: ObservableArray<String>
    @ObservedObject var focusableInstructionIndex: Observable<Int?>
    @ObservedObject var allowsCollapsingAndExpanding: ObservableBool
    
    @State var isFocused: Bool = true
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(0..<instructions.array.count, id: \.self) { instructionIndex in
                    VStack(alignment: .leading, spacing: 0) {
                        InstructionView(instructionNumber: instructionIndex + 1, instructionText: self.instructions.array[instructionIndex])
                            .frame(height: (self.allowsCollapsingAndExpanding.bool && self.isFocused) ? (self.focusableInstructionIndex.value == instructionIndex ? nil : 0) : nil)
                            .opacity((self.allowsCollapsingAndExpanding.bool) ? (self.isFocused ? (self.focusableInstructionIndex.value == instructionIndex ? 1 : 0) : (self.focusableInstructionIndex.value == instructionIndex ? 1 : 0.26)) : 1)
                    }
                }
                Spacer().frame(height: 18)
            }
            
            Spacer()
            
            HStack {
                Spacer()
                VStack {
                    Button(
                        action: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7, blendDuration: 0)) {
                                self.isFocused.toggle()
                            }
                    }) {
                        Image(systemName: self.isFocused ? "ellipsis.circle" : "xmark.circle" )
                            .frame(width: 24, height: 24)
                    }
                    .disabled(allowsCollapsingAndExpanding.bool ? false : true)
                    .opacity(allowsCollapsingAndExpanding.bool ? 1 : 0)
                    .foregroundColor(.primary)
                    .frame(width: 24, height: 24)
                    .padding(.trailing, 10)
                    
                    Spacer()
                }
            }
            .frame(width: 34, height: 50)
        }
    }
}


struct InstructionView: View {
    @ObservedObject var instructionNumber: ObservableInt
    @ObservedObject var instructionText: ObservableString
    
    init(instructionNumber: Int, instructionText: String) {
        self.instructionNumber = ObservableInt(instructionNumber)
        self.instructionText = ObservableString(instructionText)
    }
    
    init(instructionNumber: ObservableInt, instructionText: ObservableString) {
        self.instructionNumber = instructionNumber
        self.instructionText = instructionText
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                ZStack(alignment: .topLeading) {
                    Image.numberCircleFill(instructionNumber.int)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.primary)
                        .frame(width: 24, height: 24)
                        .padding(EdgeInsets(top: 0, leading: 39.5, bottom: 0, trailing: 0))
                    Text(instructionText.string)
                        .font(Font.system(size: 17, weight: .bold).monospacedDigit())
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(EdgeInsets(top: 0, leading: 76, bottom: 0, trailing: 10))
                        .offset(x: 0, y: 2)
                }
                Spacer()
            }
            Spacer().frame(height: 18)
        }
    }
}

extension InstructionView: ViewDemoing {
    static var demoProvider: DemoProvider { return InstructionView_DemoProvider() }
}

struct InstructionView_DemoProvider: DemoProvider, TextFieldEvaluating {
    var number = ObservableInt(1)
    var instruction = ObservableString("Just do it")
    
    enum Element: EvaluatorElement {
        case number
        case instruction
    }
    
    var contentView: AnyView {
        return AnyView(
            InstructionView(
                instructionNumber: number,
                instructionText: instruction
            )
        )
    }
    
    var controls: [DemoControl] {
        [
            DemoControl(
                title: "Number",
                instruction: "Type a number 1 through 50",
                type: DemoControl.Text(evaluator: self, elementName: Element.number, input: .number, initialText: String(number.int))
            ),
            
            DemoControl(
                title: "Instruction",
                type: DemoControl.Text(evaluator: self, elementName: Element.instruction, input: .text, initialText: instruction.string)
            )
        ]
    }
    
    func deepCopy() -> InstructionView_DemoProvider {
        return InstructionView_DemoProvider(
            number: number.deepCopy(),
            instruction: instruction.deepCopy()
        )
    }
    
    func textFieldDidChange(text: String, elementName: EvaluatorElement) {
        guard let elementName = elementName as? Element else { return }
        
        switch elementName {
        case .number:
            number.int = Int(text) ?? 0
        case .instruction:
            instruction.string = text
        }
    }
}

extension InstructionsView: ViewDemoing {
    static var demoProvider: DemoProvider { return InstructionsView_DemoProvider() }
}

struct InstructionsView_DemoProvider: DemoProvider, TextFieldEvaluating, ToggleEvaluating {
    var instructions = ObservableArray<String>(["Just do it", "Do something else", "And another thing"])
    var focusedInstructionIndex = Observable<Int?>(1)
    var allowsCollapsingAndExpanding = ObservableBool(false)
    
    enum Element: EvaluatorElement {
        case text
        case toggle
    }
    
    var contentView: AnyView {
        return AnyView(
            InstructionsView(
                instructions: instructions,
                focusableInstructionIndex: focusedInstructionIndex,
                allowsCollapsingAndExpanding: allowsCollapsingAndExpanding)
        )
    }
    
    var controls: [DemoControl] {
        return [
            DemoControl(
                title: "Instructions",
                instruction: "Type instructions separated by semicolons",
                type: DemoControl.Text(
                    evaluator: self,
                    elementName: Element.text,
                    input: .text,
                    initialText: instructions.array.joined(separator: ";"))),
            
            DemoControl(
                title: "Collapsing and Expanding",
                instruction: "Type instructions separated by semicolons",
                type: DemoControl.Toggle(
                    evaluator: self,
                    elementName: Element.toggle,
                    title: "Allow Collapsing and Expanding",
                    initialValue: allowsCollapsingAndExpanding.bool))
        ]
    }
    
    func textFieldDidChange(text: String, elementName: EvaluatorElement) {
        instructions.array = text.split(separator: ";").map{ String($0) }
    }
    
    func toggleDidChange(bool: Bool, elementName: EvaluatorElement) {
        allowsCollapsingAndExpanding.bool = bool
    }
    
    func deepCopy() -> InstructionsView_DemoProvider {
        let demoProvider = InstructionsView_DemoProvider(
            instructions: instructions.deepCopy(),
            focusedInstructionIndex: focusedInstructionIndex.deepCopy(),
            allowsCollapsingAndExpanding: allowsCollapsingAndExpanding.deepCopy()
        )
        return demoProvider
    }
}
