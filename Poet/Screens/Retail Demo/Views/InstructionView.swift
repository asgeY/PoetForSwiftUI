//
//  InstructionView.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/21/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

/* * * * * * * * * * * * * * * *
 
 TODO
 
 Make InstructionsView, similar to OptionsView.
 
* * * * * * * * * * * * * * * */


struct InstructionView: View {
    @ObservedObject var instructionNumber: ObservableInt
    @ObservedObject var instruction: ObservableString
    
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
                    Text(instruction.string)
                        .font(Font.system(size: 17, weight: .bold).monospacedDigit())
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(EdgeInsets(top: 0, leading: 76, bottom: 0, trailing: 76))
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
                instruction: instruction
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
