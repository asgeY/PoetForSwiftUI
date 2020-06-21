//
//  RetailTwo.swift
//  Poet
//
//  Created by Stephen E. Cotner on 6/20/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct RetailTwo {}

extension RetailTwo {
    struct Screen: View {
        
        typealias Action = Evaluator.Action
        
        let evaluator: Evaluator
        let translator: Translator
        
        @State var navBarHidden: Bool = true
        
        init() {
            evaluator = Evaluator()
            translator = evaluator.translator
        }
        
        var body: some View {
            ZStack {
                VStack(spacing: 0) {
                    
                    ObservingPageView(
                        sections: self.translator.sections,
                        viewMaker: Retail.ViewMaker(
                            findingProductsEvaluator: evaluator,
                            optionsEvaluator: evaluator
                        )
                    )
                    
                    Spacer()
                }
                
                VStack(spacing: 0) {
                    DismissButton(orientation: .right)
                    DismissReceiver(translator.dismiss)
                    Spacer()
                }
                
                VStack {
                    Spacer()
                    ObservingBottomButton(observableNamedEnabledAction: self.translator.bottomButtonAction, evaluator: evaluator)
                }
                
                AlertPresenter(translator.alert)
                
            }.onAppear {
                self.navBarHidden = false
                self.navBarHidden = true
                self.evaluator.viewDidAppear()
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(navBarHidden)
        }
    }
}
