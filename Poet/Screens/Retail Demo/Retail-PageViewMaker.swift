//
//  Retail-PageViewMaker.swift
//  Poet
//
//  Created by Stephen E Cotner on 5/1/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine
import SwiftUI

protocol FindingProductsEvaluating {
    func toggleProductFound(_ product: FindableProduct)
    func _toggleProductFound(_ product: FindableProduct)
    func toggleProductNotFound(_ product: FindableProduct)
    func _toggleProductNotFound(_ product: FindableProduct)
}

extension FindingProductsEvaluating {
    func toggleProductFound(_ product: FindableProduct) {
        breadcrumbToggleFound(product)
        _toggleProductFound(product)
    }
    
    func toggleProductNotFound(_ product: FindableProduct) {
        breadcrumbToggleNotFound(product)
        _toggleProductNotFound(product)
    }
    
    func breadcrumbToggleFound(_ product: FindableProduct) {
        debugPrint("breadcrumb. evaluator: \(self) toggled found: \(product)")
    }
    
    func breadcrumbToggleNotFound(_ product: FindableProduct) {
        debugPrint("breadcrumb. evaluator: \(self) toggled not found: \(product)")
    }
}

protocol OptionsEvaluating {
    func toggleOption(_ option: String)
    func _toggleOption(_ option: String)
}

extension OptionsEvaluating {
    func toggleOption(_ option: String) {
        breadcrumb(option)
        _toggleOption(option)
    }
    
    func breadcrumb(_ option: String) {
        debugPrint("breadcrumb. evaluator: \(self) toggled option: \(option)")
    }
}

extension Retail {
    struct ViewMaker: ObservingPageView_ViewMaker {
        
        enum Section: ObservingPageViewSection {
            case canceledTitle
            case completedTitle
            case completedSummary(completedSummary: ObservableString)
            case customerTitle(title: ObservableString)
            case options(options: ObservableArray<String>, preference: ObservableString)
            case feedback(feedback: ObservableString)
            case displayableProducts(displayableProducts: ObservableArray<DisplayableProduct>)
            case divider
            case instruction(instructionNumber: ObservableInt, instruction: ObservableString)
            case instructions(instructions: ObservableArray<String>, focusableInstructionIndex: Observable<Int?>, allowsCollapsingAndExpanding: ObservableBool)
            case topSpace
            case space
            
            var id: String {
                switch self {
                case .canceledTitle:        return "canceledTitle"
                case .completedTitle:       return "completedTitle"
                case .completedSummary:     return "completedSummary"
                case .customerTitle:        return "customerTitle"
                case .options:              return "options"
                case .feedback:             return "feedback"
                case .displayableProducts:  return "displayableProducts"
                case .divider:              return "divider"
                case .instruction:          return "instruction"
                case .instructions:         return "instructions"
                case .topSpace:             return "topSpace"
                case .space:                return "space"
                }
            }
        }
        
        let findingProductsEvaluator: FindingProductsEvaluating
        let optionsEvaluator: OptionsEvaluating
        
        func view(for section: Section) -> AnyView {
            switch section {
            
            case .topSpace:
                return AnyView(
                    Spacer().frame(height: 40)
                )
                
            case .space:
                return AnyView(
                    SpaceView()
                )
                
            case .canceledTitle:
                return AnyView(
                    Fadeable {
                        TitleView(
                            text: "Canceled",
                            color: Color(UIColor.systemRed)
                        )
                    }
                )
                
            case .completedTitle:
                return AnyView(
                    Fadeable {
                        TitleView(
                            text: "Completed",
                            color: Color(UIColor.systemGreen)
                        )
                    }
                )
                
            case .customerTitle(let title):
                return AnyView(
                    TitleView(
                        observableText: title,
                        color: Color.primary
                    )
                )
                
            case .divider:
                return AnyView(
                    DividerView()
                )
                
            case .feedback(let feedback):
                return AnyView(
                    FeedbackView(feedback: feedback)
                )
                
            case .instruction(let instructionNumber, let instruction):
                return AnyView(
                    InstructionView(instructionNumber: instructionNumber, instructionText: instruction)
                )
                
            case .instructions(let instructions, let focusableInstructionIndex, let allowsCollapsingAndExpanding):
                return AnyView(
                    InstructionsView(
                        instructions: instructions,
                        focusableInstructionIndex: focusableInstructionIndex,
                        allowsCollapsingAndExpanding: allowsCollapsingAndExpanding
                    )
                )
             
            case .displayableProducts(let displayableProducts):
                return AnyView(
                    VStack(spacing: 0) {
                        DisplayableProductsView(displayableProducts: displayableProducts, evaluator: self.findingProductsEvaluator)
                        
                        // This Spacer forces the products to stay at the top of their section when animating.
                        // The -10 bottom padding counteracts the spacer's minimum height.
//                        Spacer()
//                            .padding(.bottom, -10)
                        
                    }
                )
                
            case .options(let options, let preference):
                return AnyView(
                    Fadeable {
                        OptionsView(options: options, preference: preference, evaluator: self.optionsEvaluator)
                    }
                )
                
            case .completedSummary(let completedSummary):
                return AnyView(
                    Fadeable {
                        VStack(spacing: 0) {
                            HStack {
                                ObservingTextView(completedSummary)
                                    .font(Font.system(.headline))
                                    .opacity(0.36)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
                                Spacer()
                            }
                        }.padding(.bottom, 30)
                    }
                )
            }
        }
    }
}


struct TitleView: View {
    @ObservedObject var observableText = ObservableString()
    let color: Color
    
    init(text: String, color: Color) {
        self.observableText = ObservableString(text)
        self.color = color
    }
    
    init(observableText: ObservableString, color: Color) {
        self.observableText = observableText
        self.color = color
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Observer(observableText) { text in
                    Text(text)
                        .font(Font.system(size: 32, weight: .bold))
                        .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }
            }
            Spacer().frame(height: 24)
        }
        .foregroundColor(color)
    }
}

extension TitleView: ViewDemoing {
    static var demoProvider: DemoProvider {
        return TitleView_DemoProvider()
    }
}

struct TitleView_DemoProvider: DemoProvider, TextFieldEvaluating {
    var text = ObservableString("Hello")
    var color = Observable<Color>(.primary)
    
    enum Element: EvaluatorElement {
        case text
    }
    
    var contentView: AnyView {
        return AnyView(
            Observer2(text, color) { text, color in
                TitleView(
                    text: text,
                    color: color
                )
            }
        )
    }
    
    var controls: [DemoControl] {
        return [
            DemoControl(
                title: "Text",
                type: DemoControl.Text(evaluator: self, elementName: Element.text, input: .text, initialText: text.string)
            ),
            
            DemoControl(
                title: "Color",
                type: DemoControl.Buttons(
                    observable: color,
                    choices: [
                        NamedIdentifiedValue(title: "Primary", value: Color.primary),
                        NamedIdentifiedValue(title: "Green", value: Color(UIColor.systemGreen)),
                        NamedIdentifiedValue(title: "Red", value: Color(UIColor.systemRed)),
                    ]
                )
            )
        ]
    }
    
    func deepCopy() -> TitleView_DemoProvider {
        let provider = TitleView_DemoProvider(
            text: self.text.deepCopy(),
            color: self.color.deepCopy()
        )
        return provider
    }
    
    func textFieldDidChange(text: String, elementName: EvaluatorElement) {
        guard let elementName = elementName as? Element else { return }
        switch elementName {
        case .text:
            self.text.string = text
        }
    }
}
