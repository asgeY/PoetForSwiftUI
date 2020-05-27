//
//  Chapter_PassableStatePart2.swift
//  Poet
//
//  Created by Steve Cotner on 5/26/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

extension Tutorial.PageStore {
    var chapter_PassableStatePart2: Chapter {
        return Chapter(
            "Passable State, Part 2 (In Progress)",
            pages:
            Page([.text("(Coming soon)\n\nThis chapter will cover PresenterWithString and PresenterWithPassableValue.")]),
            
            Page([.text("...")]),
            
            Page([.text("Speaking of minimal code, let's look at another technique that saves us from being repetitive as we bridge our different layers: protocol-oriented translating.")])
        )
    }
}
