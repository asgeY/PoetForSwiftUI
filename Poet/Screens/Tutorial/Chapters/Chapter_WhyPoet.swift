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
            Page([.text("Poet is an acronym that stands for Passable Observable Evaluator/Translator. The evaluator and translator are a pair that work together. Passing and Observing state are the two main techniques that guide their work.")]),
            Page([.text("You can think of the evaluator and translator as two different layers in the pattern, or as two different phases of reasoning that the programmer will undertake.")]),
            Page([.text("The evaluator is the business logic decision-maker. It maintains what we might call “business state.”"),
                .text("The translator interprets the business state of the evaluator and turns it into observable “display state.”"),
                .text("And the view layer — a screen made up of SwiftUI View structs — is the part that observes the translator's display state.")]),
            Page([.text("A given user flow requires participation from all three layers — evaluator, translator, and view. Sometimes we need to be deliberate about each layer and spell out their work step by step."),
                .text("Other times, we already know what each layer should do, and protocol-oriented programming can bridge them all with default protocol implementations.")]),
            Page([.text("There's one more feature of the Poet pattern that's pretty fundamental: “steps.” The evaluator's business state is always encapsulated in a single step, a distinct unit of state. We'll talk a lot more about that soon.")]),
            Page([.text("That's enough of a high-level overview. We'll jump into the pattern by looking at a basic template.")])
        )
    }
}

