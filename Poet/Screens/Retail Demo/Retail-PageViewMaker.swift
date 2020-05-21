//
//  Retail-PageViewMaker.swift
//  Poet
//
//  Created by Stephen E Cotner on 5/1/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine
import SwiftUI

protocol FindingProductsEvaluator: class {
    func toggleProductFound(_ product: FindableProduct)
    func toggleProductNotFound(_ product: FindableProduct)
}

protocol OptionsEvaluator: class {
    func toggleOption(_ option: String)
}

extension Retail {
    struct ViewMaker: ObservingPageView_ViewMaker {
        
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
                
            case .canceledTitle:
            return AnyView(
                Fadeable {
                    HStack {
                        Text("Canceled")
                            .font(Font.system(size: 32, weight: .bold))
                            .padding(EdgeInsets(top: 0, leading: 40, bottom: 18, trailing: 40))
                        Spacer()
                    }.foregroundColor(Color(UIColor.systemRed))
                }
            )
                
            case .completedTitle:
                return AnyView(
                    Fadeable {
                        HStack {
                            Text("Completed")
                                .font(Font.system(size: 32, weight: .bold))
                                .padding(EdgeInsets(top: 0, leading: 40, bottom: 18, trailing: 40))
                            Spacer()
                        }.foregroundColor(Color(UIColor.systemGreen))
                    }
                )
                
            case .customerTitle(let title):
                return AnyView(
                    HStack {
                        ObservingTextView(title)
                            .font(Font.system(size: 32, weight: .bold))
                            .padding(EdgeInsets(top: 0, leading: 40, bottom: 18, trailing: 40))
                        Spacer()
                    }
                )
                
            case .divider:
                return AnyView(
                    Divider()
                        .background(Color.primary)
                        .frame(height: 2)
                        .opacity(0.25)
                        .padding(EdgeInsets(top: 0, leading: 40, bottom: 20, trailing: 0))
                )
                
            case .feedback(let feedback):
                return AnyView(
                    VStack {
                        HStack {
                            ObservingTextView(feedback)
                                .font(Font.headline.monospacedDigit().bold())
                                .opacity(0.4)
                                .padding(EdgeInsets(top: 0, leading: 40, bottom: 26, trailing: 42))
                            Spacer()
                        }
                    }
                )
                
            case .instruction(let instructionNumber, let instruction):
                return AnyView(
                    InstructionView(instructionNumber: instructionNumber, instruction: instruction)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                )
             
            case .displayableProducts(let displayableProducts, let findingProductsEvaluator):
                return AnyView(
                    DisplayableProductsView(displayableProducts: displayableProducts, evaluator: findingProductsEvaluator)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                )
                
            case .deliveryOptions(let deliveryOptions, let deliveryPreference, let optionsEvaluator):
                return AnyView(
                    Fadeable {
                        OptionsView(options: deliveryOptions, preference: deliveryPreference, evaluator: optionsEvaluator)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 34, trailing: 0))
                    }
                )
                
            case .completedSummary(let completedSummary):
                return AnyView(
                    Fadeable {
                        VStack {
                            Divider()
                            .background(Color.primary)
                            .frame(height: 1.75)
                            .opacity(0.22)
                            .padding(EdgeInsets(top: 0, leading: 40, bottom: 20, trailing: 0))
                            
                            HStack {
                                ObservingTextView(completedSummary)
                                    .font(Font.system(.headline))
                                    .opacity(0.33)
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
