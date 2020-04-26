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
        
        private var page: Page = Page(
            title: "Intro",
            body: [
                .text("The Poet pattern is an easy and powerful approach to making iOS apps with SwiftUI, one screen at a time. Poet is an acronym:"),
                    
                .quote("Protocol-Oriented Evaluator Translator"),
                
                .image("poet-intro-small"),
                    
                .text("Poet began before SwiftUI, but there was a lot more plumbing involved. Now, it's smaller and easier to follow. The benefits of Poet emerge as screens get more and more complex. No matter what you make, Poet code will remain:"),
                    
                .quote(
                    """
                    * Readable
                    * Refactorable
                    * Composable
                    * Testable
                    * Observable
                    """),
                
                .text("Poet was developed by Steve Cotner at a shoe company in Portland, Oregon from 2018 to 2020.  It began with some early encouragement from colleagues and has benefited from the feedback of many talented developers."),
                    
                .quote(
                    """
                    © 2020 Steve Cotner
                    """),
            ]
        )
    }
}

// MARK: View Cycle

extension Intro.Evaluator: ViewCycleEvaluator {
    func viewDidAppear() {
        translator.show(page: page)
    }
}
