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
                Page.Element(
                    text:"The Poet pattern is an easy and powerful approach to making iOS apps with SwiftUI, one screen at a time. Poet is an acronym:",
                    type: .text),
                Page.Element(
                    text:"Protocol-Oriented Evaluator Translator",
                    type: .quote),
                Page.Element(
                    text:"Poet began before SwiftUI, but there was a lot more plumbing involved. Now, it's smaller and easier to follow. The benefits of Poet emerge as screens get more and more complex. No matter what you make, Poet code will remain:",
                    type: .text),
                Page.Element(
                    text:
                    """
                    * Readable
                    * Refactorable
                    * Composable
                    * Testable
                    * Observable
                    """, type: .quote),
                Page.Element(
                text:"Poet was developed by Steve Cotner at a shoe company in Portland, Oregon from 2018 to 2020.  It began with some early encouragement from colleagues and has benefited from the feedback of many talented developers.",
                type: .text),
                
            ]
        )
    }
}

// MARK: View Cycle

extension Intro.Evaluator: ViewCycleEvaluator {
    func viewDidAppear() {
        translator.showPage(title: page.title, body: page.body)
    }
}
