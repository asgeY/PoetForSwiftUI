//
//  Intro-Evaluator.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/24/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

extension Intro {
    class Evaluator {
        
        // Translator
        
        let translator: Translator = Translator()
        
        // Data
        
        private var page: Page = IntroDataStore.shared.page
    }
}

// MARK: View Cycle

extension Intro.Evaluator: ViewCycleEvaluator {
    func viewDidAppear() {
        translator.show(page: page)
    }
}
