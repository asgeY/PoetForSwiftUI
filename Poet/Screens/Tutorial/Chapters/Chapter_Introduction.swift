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
            Page([.text("You're looking at a screen made with the Poet pattern. The code behind it emphasizes clarity, certainty, flexibility, and reusability.")]),
            Page([.text("The process of writing Poet code is methodical but relatively quick. It follows the philosophy that a pattern “should be made as simple as possible, but no simpler.”")]),
            Page([.text("Poet has a rote structure but it frees you to write with confidence, without fearing that your code will get tangled up over time.")]),
            Page([
                .text("It achieves this through the effective decoupling of business state, display state, and view logic."),
                .text("Poet formalizes the distinction between these three layers of reasoning, where most patterns only formalize a distinction between a business layer and a view layer.")
                ]),
            Page([.text("We'll learn about the pattern and its benefits by thinking about how some different screens were made. But first, why is it called Poet?")])
        )
    }
}
