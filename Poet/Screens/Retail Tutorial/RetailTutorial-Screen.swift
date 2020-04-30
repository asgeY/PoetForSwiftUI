//
//  RetailTutorial-Screen.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/28/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct RetailTutorial {}

extension RetailTutorial {
    struct Screen: View {
        
        let _evaluator: RetailTutorial.Evaluator
        weak var evaluator: RetailTutorial.Evaluator?
        let translator: RetailTutorial.Translator
        
        init() {
            debugPrint("init RetailTutorial Screen")
            _evaluator = Evaluator()
            evaluator = _evaluator
            translator = _evaluator.translator
        }
        
        @State var navBarHidden: Bool = true
        
        var body: some View {
            ZStack {
                VStack {
                    Spacer().frame(height:12)
                    
                    // MARK: Title
                    
                    Text("Retail Tutorial")
                        .font(Font.subheadline.monospacedDigit().bold())
                        .layoutPriority(10)
                        .multilineTextAlignment(.center)
                        .layoutPriority(10)
                    
                    Spacer().frame(height:18)
                    
                    // MARK: Page View
                    
                    RetailTutorialPageView(
                        pageSections: self.translator.pageSections,
                        title: self.translator.pageData.title,
                        details: self.translator.pageData.details,
                        instruction: self.translator.pageData.instruction,
                        instructionNumber: self.translator.pageData.instructionNumber,
                        products: self.translator.pageData.products,
                        findableProducts: self.translator.pageData.findableProducts,
                        deliveryOptions: self.translator.pageData.deliveryOptions,
                        deliveryPreference: self.translator.pageData.deliveryPreference,
                        completedSummary: self.translator.pageData.completedSummary,
                        findingProductsEvaluator: evaluator,
                        optionsEvaluator: evaluator)
                        .layoutPriority(10)
                    
                }
                VStack {
                    
                    // MARK: Back Button
                    
                    BackButton()
                    Spacer()
                }
                VStack {
                    Spacer()
                    
                    // MARK: Bottom Button
                    
                    BottomButton(bottomButtonAction: self.translator.bottomButtonAction, evaluator: evaluator)
                }
            }.onAppear() {
                self.evaluator?.viewDidAppear()
                self.navBarHidden = false
                self.navBarHidden = true
            }.onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                self.navBarHidden = false
                self.navBarHidden = true
            }.onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                self.navBarHidden = false
                self.navBarHidden = true
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(navBarHidden)
        }
    }
}

struct BottomButton: View {
    @ObservedObject var bottomButtonAction: ObservableNamedEvaluatorAction
    weak var evaluator: BottomButtonEvaluator?
    
    var body: some View {
        Button(action: {
            self.evaluator?.bottomButtonTapped(action: self.bottomButtonAction.action?.action)
        }) {
            Text(bottomButtonAction.action?.name ?? "")
        }.opacity(
            bottomButtonAction.action?.action != nil ? 1 : 0
        )
    }
}
