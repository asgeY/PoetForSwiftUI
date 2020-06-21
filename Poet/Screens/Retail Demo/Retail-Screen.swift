//
//  Retail-Screen.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/28/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct Retail {}

extension Retail {
    struct Screen: View {
        
        let evaluator: Retail.Evaluator
        let translator: Retail.Translator
        
        init() {
            evaluator = Evaluator()
            translator = evaluator.translator
        }
        
        @State var navBarHidden: Bool = true
        
        var body: some View {
            ZStack {
                
                // MARK: Page View
                ObservingPageView(
                    sections: self.translator.sections,
                    viewMaker: Retail.ViewMaker(
                        findingProductsEvaluator: evaluator,
                        optionsEvaluator: evaluator
                    )
                )

                // MARK: Dismiss Button
                
                VStack {
                    DismissButton(orientation: .right)
                    DismissReceiver(translator.dismiss)
                    Spacer()
                }
                
                // MARK: Bottom Button
                
                VStack {
                    Spacer()
                    ObservingBottomButton(observableNamedEnabledAction: self.translator.bottomButtonAction, evaluator: evaluator)
                }
            }.onAppear() {
                self.navBarHidden = false
                self.navBarHidden = true
                UITableView.appearance().separatorColor = .clear
                self.evaluator.viewDidAppear()
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
