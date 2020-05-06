//
//  Template-Screen.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/2/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct Template {}

extension Template {
    struct Screen: View {
        
        let _evaluator: Evaluator
        weak var evaluator: Evaluator?
        let translator: Translator
        
        init() {
            _evaluator = Evaluator()
            evaluator = _evaluator
            translator = _evaluator.translator
        }
        
        var body: some View {
            VStack {
                ObservingTextView(translator.greeting)
            }.onAppear {
                self.evaluator?.viewDidAppear()
            }
        }
    }
}
