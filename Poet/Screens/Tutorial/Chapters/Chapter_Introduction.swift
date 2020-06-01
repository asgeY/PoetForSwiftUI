//
//  Chapter_Introduction.swift
//  Poet
//
//  Created by Steve Cotner on 5/26/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

extension Tutorial.PageStore {
    var chapter_Introduction: Chapter {
        return Chapter("Introduction", pages:
            Page([
                .text("Congratulations. Somehow you heard about the Poet pattern for SwiftUI and decided to learn about it. Things are looking up."),
                .text("In the course of reading this tutorial, you'll be walked through several examples of Poet, ranging from the very simple to the very complex. Here are some of the screens you'll encounter:"),
                
                .title("Hello Worlds"),
                .text("Two Hello World examples that demonstrate the basic pattern and some simple changes to state."),
                .demo(.showHelloWorld),
                .demo(.showHelloSolarSystem),
                
                .title("Login"),
                .text("A login flow with validated fields, networking, and a suite of tests."),
                .demo(.showLoginDemo),
                
                .title("Retail"),
                .text("A screen from a retail employee's app, with smooth animation between sequential steps. Under the hood, it sports a fully decoupled approach to showing or hiding sections on screen, based on the current step."),
                .demo(.showRetailDemo),
                
                .divider,
                .text("Screens like these are, for a programmer with moderate experience and a good understanding of the pattern, relatively easy to make."),
                .text("The goal of this tutorial is to help programmers understand the underlying principes of the pattern, in order to exercise them effectively. Once they do, the Poet approach allows them to write code that is clear, expressive, refactorable, reusable, and testable."),
                .text("While Poet may seem complex at first, it follows the philosophy that a pattern “should be made as simple as possible, but no simpler.”"),
                .text("There are a few different actors in Poet, and a few different techniques the pattern engenders, but they all are expressions of the pattern's underlying principle of effectively decoupling business state, display state, and view logic."),
                .text("Poet formalizes the distinction between these three layers of reasoning, where most patterns only formalize a distinction between a business layer and a view layer — an incomplete distinction that eventually leads to tangled code which is difficult to refactor over time."),
                .text("We'll learn about the pattern and its benefits by thinking about how these different screens were made. But first, why is it called Poet?")
            ])
        )
    }
}
