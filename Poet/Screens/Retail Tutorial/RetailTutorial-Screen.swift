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
                    
                    Text("Retail")
                        .font(Font.subheadline.monospacedDigit().bold())
                        .multilineTextAlignment(.center)
                        .layoutPriority(10)
                    
                    Spacer().frame(height:18)
                    
                    // MARK: Page View
                    
                    ObservingPageView(
                        sections: self.translator.sections,
                        viewMaker: PageViewMaker(
                            title: translator.title,
                            details: translator.details,
                            instruction: translator.instruction,
                            instructionNumber: translator.instructionNumber,
                            products: translator.products,
                            findableProducts: translator.findableProducts,
                            deliveryOptions: translator.deliveryOptions,
                            deliveryPreference: translator.deliveryPreference,
                            completedSummary: translator.completedSummary,
                            findingProductsEvaluator: evaluator,
                            optionsEvaluator: evaluator)
                    )
                        .layoutPriority(10)
                    
                }
                VStack {
                    
                    // MARK: Back Button
                    
                    BackButton()
                    DismissReceiver(translator: translator.dismissTranslator)
                    Spacer()
                }
                VStack {
                    Spacer()
                    
                    // MARK: Bottom Button
                    
                    BottomButton(bottomButtonAction: self.translator.bottomButtonAction, evaluator: evaluator)
                }
            }.onAppear() {
                self.navBarHidden = false
                self.navBarHidden = true
                UITableView.appearance().separatorColor = .clear
                self.evaluator?.viewDidAppear()
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
        GeometryReader() { geometry in
            VStack {
                Spacer()
                Button(action: {
                    self.evaluator?.bottomButtonTapped(action: self.bottomButtonAction.action?.action)
                }) {
                        
                    Text(
                        self.bottomButtonAction.action?.name ?? "")
                        .animation(.none)
                        .font(Font.headline)
                        .foregroundColor(Color(UIColor.systemBackground))
                        .frame(width: geometry.size.width - 100)
                        .padding(EdgeInsets(top: 16, leading: 18, bottom: 16, trailing: 18))
                        .background(
                            ZStack {
                                BlurView()
                                Rectangle()
                                    .fill(Color.primary.opacity(0.95))
                            }
                            .mask(
                                Capsule()
                            )
                    )
                    
                }
            }
            
            .opacity(
                self.bottomButtonAction.action?.action == nil ? 0 : 1
            )
            .offset(x: 0, y: self.bottomButtonAction.action?.action == nil ? 150 : 0)
                .animation(.spring(response: 0.35, dampingFraction: 0.7, blendDuration: 0), value: self.bottomButtonAction.action?.action == nil)
        }
    }
}
