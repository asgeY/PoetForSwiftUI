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
                .text("Hello! Somehow you found this tutorial about the Poet pattern for SwiftUI. Let's hope it's useful!"),
                .text("People choose patterns for all sorts of reasons, and sometimes they're sound. The only wrong choice is to believe that patterns are inconsequential. The right pattern makes a difference: it biases a programmer toward prioritizing certain virtues over others. This tutorial tries to provide the reasoning behind the Poet approach. Maybe it's for you, maybe not."),
                .text("What's the elevator pitch? Poet encourages a programmer to build up abstractions that let them compose a screen of reusable views which can be added and removed dynamically at runtime. Once these abstractions are built, most choices of display state and view logic become rote and automatic. A developer can then focus most of their thought on business logic, freeing them to construct complicated, multi-step interfaces with comprehensive branches of reasoning in a way that is still clear and easy to follow, test, and refactor."),
                .text("In the course of reading this tutorial, you'll be walked through several examples of Poet, ranging from the pretty simple to the pretty complex. Here are some of the screens you'll encounter:"),
                
                .title("Hello Worlds"),
                .text("Some Hello World examples that demonstrate the basic pattern and some simple state management."),
                .demo(.showHelloWorld),
                .demo(.showHelloSolarSystem),
                .demo(.showHelloData),
                
                .title("Login"),
                .text("A login flow with validated fields, networking, and a suite of tests."),
                .demo(.showLoginDemo),
                
                .title("Retail"),
                .text("A screen from a retail employee's app, with smooth animation between sequential steps. Under the hood, it sports a fully decoupled approach to showing or hiding sections on screen, based on the current step. This is the first substantial example that shows what powerful abstractions are possible with Poet."),
                .demo(.showRetailDemo),
                
                .divider,
                .text("Even the more complex screens, like the Retail example, are relatively quick and easy to make."),
                .text("The goal of this tutorial is to help programmers understand the underlying principes of the pattern, in order to decide if it suits their needs."),
                .text("There are a few different actors in Poet, and a few different techniques the pattern engenders, but they all are expressions of the pattern's underlying principle of effectively decoupling business state, display state, and view logic."),
                .text("Poet formalizes the distinction between these three layers of reasoning, where most patterns only formalize a distinction between a business layer and a view layer — an incomplete distinction that eventually leads to tangled code which is difficult to refactor over time."),
                .text("We'll learn about the pattern and its benefits by thinking about how many different screens were made. But first, why is it called Poet?")
            ])
        )
    }
}
