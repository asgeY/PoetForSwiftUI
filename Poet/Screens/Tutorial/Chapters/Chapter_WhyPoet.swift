//
//  Chapter02_WhyPoet.swift
//  Poet
//
//  Created by Steve Cotner on 5/26/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

extension Tutorial.PageStore {
    var chapter_WhyPoet: Chapter {
        return Chapter("Why Poet?", pages:
            Page([
                .text("Poet is an acronym that stands for Passable Observable Evaluator/Translator."),
                .text("The evaluator and translator are a pair that work together. Passing and Observing state — by making use of Combine's PassthroughSubject and ObservableObject types — are the two main techniques that guide their work."),
                .text("You can think of the evaluator and translator as two different layers in the pattern, or as two different phases of reasoning that the programmer will undertake. There is a third layer, too, called a screen, and another thing we sometimes need called a performer."),
                .title("Evaluator"),
                .text("The evaluator is the business logic decision-maker. It maintains what we might call “business state.”"),
                .title("Translator"),
                .text("The translator interprets the business state of the evaluator and turns it into observable “display state.”"),
                .title("Screen"),
                .text("The view layer — a screen made up of SwiftUI view structs — is the part that observes the translator's display state and implements view logic."),
                .title("Performer"),
                .text("The performer takes care of asynchronous work — mostly network calls — and publishes the results, which the evaluator consumes."),
                .divider,
                .text("Any given user flow requires participation from at least the first three layers — evaluator, translator, and screen."),
                .text("There's one more feature of the Poet pattern that's pretty fundamental: “steps.” The evaluator's business state is always encapsulated in a single step, a distinct unit of state. We'll talk a lot more about that soon."),
                .text("That's enough of a high-level overview. We'll jump into the pattern by looking at a basic template.")
            ])
        )
    }
}

