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
    func toggleProductNotFound(_ product: FindableProduct)
}

protocol OptionsEvaluating {
    func toggleOption(_ option: String)
}

extension Retail {
    struct ViewMaker: ObservingPageView_ViewMaker {
        
        let findingProductsEvaluator: FindingProductsEvaluating
        let optionsEvaluator: OptionsEvaluating
        
        // Fade state
        let fadeDeliveryOptions = ObservableBool()
        let fadeCompletedSummary = ObservableBool()
        let fadeCompletedTitle = ObservableBool()
        let fadeCanceledTitle = ObservableBool()
        
        func view(for section: ObservingPageViewSection) -> AnyView {
            guard let section = section as? Retail.Translator.Section else {
                return AnyView(EmptyView())
            }
            
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
                            text: "Canceled",
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
                    InstructionView(instructionNumber: instructionNumber, instruction: instruction)
                )
             
            case .displayableProducts(let displayableProducts):
                return AnyView(
                    DisplayableProductsView(displayableProducts: displayableProducts, evaluator: self.findingProductsEvaluator)
                )
                
            case .deliveryOptions(let deliveryOptions, let deliveryPreference):
                return AnyView(
                    Fadeable {
                        OptionsView(options: deliveryOptions, preference: deliveryPreference, evaluator: self.optionsEvaluator)
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
