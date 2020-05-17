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
    struct PageViewMaker: ObservingPageView_ViewMaker {
        var title: ObservableString
        var details: ObservableString
        var instruction: ObservableString
        var instructionNumber: ObservableInt
        var displayableProducts: ObservableArray<Retail.Translator.DisplayableProduct>
        var products: ObservableArray<Product>
        var findableProducts: ObservableArray<FindableProduct>
        var deliveryOptions: ObservableArray<String>
        var deliveryPreference: ObservableString
        var completedSummary: ObservableString
        var findingProductsEvaluator: FindingProductsEvaluator?
        var optionsEvaluator: OptionsEvaluator?
        
        // Fade state
        let isDeliveryOptionsShowing = ObservableBool()
        let isCompletedSummaryShowing = ObservableBool()
        
        func view(for section: ObservingPageSection) -> AnyView {
            guard let section = section as? Retail.Page.Section else {
                return AnyView(EmptyView())
            }
            
            switch section {
                
            case .title:
                return AnyView(
                    HStack {
                        ObservingTextView(title)
                            .font(Font.system(size: 32, weight: .bold))
                            .padding(EdgeInsets(top: 0, leading: 40, bottom: 18, trailing: 40))
                            .id("title")
                        Spacer()
                    }
                )
                
            case .space:
                return AnyView(
                    Spacer().frame(height: 10)
                )
                
            case .divider:
                return AnyView(
                    Divider()
                        .background(Color.primary)
                        .frame(height: 1.75)
                        .opacity(0.22)
                        .padding(.bottom, 20)
                )
                
            case .details:
                return AnyView(
                    VStack {
                        HStack {
                            ObservingTextView(details)
                                .font(Font.headline.monospacedDigit().bold())
                                .opacity(0.4)
                                .padding(EdgeInsets(top: 0, leading: 40, bottom: 30, trailing: 42))
                                .id("details")
                            Spacer()
                        }
                    }
                )
                
            case .instruction:
                return AnyView(
                    InstructionView(instructionNumber: instructionNumber, instruction: instruction)
                        .id("instruction")
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                )
             
            case .displayableProducts:
                return AnyView(
                    DisplayableProductsView(displayableProducts: displayableProducts, evaluator: self.findingProductsEvaluator)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                )
                
            case .products:
                return AnyView(
                    ProductsView(products: products)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                )

            case .findableProducts:
                return AnyView(
                    FindableProductsView(findableProducts: findableProducts, evaluator: self.findingProductsEvaluator)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                )
                
            case .deliveryOptions:
                return AnyView(
                    Fadeable(isShowing: isDeliveryOptionsShowing) {
                        OptionsView(options: self.deliveryOptions, preference: self.deliveryPreference, evaluator: self.optionsEvaluator)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 34, trailing: 0))
                    }
                )
                
            case .completedSummary:
                return AnyView(
                    Fadeable(isShowing: isCompletedSummaryShowing) {
                        HStack {
                            ObservingTextView(self.completedSummary)
                                .font(Font.system(.headline))
                                .opacity(0.33)
                                .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
                            Spacer()
                        }
                    }
                )
            }
        }
    }
}

struct Fadeable<Content>: View where Content : View {
    @ObservedObject var isShowing: ObservableBool
    var content: () -> Content
    
    init(isShowing: ObservableBool, @ViewBuilder content: @escaping () -> Content) {
        debugPrint("init fadeable")
        self.isShowing = isShowing
        self.content = content
    }
    
    var body: some View {
        content()
            .opacity(isShowing.bool ? 1 : 0)
            .onDisappear() {
                withAnimation(Animation.linear(duration: 0.3)) {
                    self.isShowing.bool = false
                }
        }
            .onAppear() {
                withAnimation(Animation.linear(duration: 0.3).delay(0.25)) {
                    self.isShowing.bool = true
                }
        }
    }
}
