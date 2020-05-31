//
//  Chapter_ANoteOnCombine.swift
//  Poet
//
//  Created by Steve Cotner on 5/26/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

extension Tutorial.PageStore {
    var chapter_ANoteOnCombine: Chapter {
        return Chapter(
            "A Note on Combine",
            pages:
            Page([
                .text("Compared to some other approaches that use the Combine framework, Poet is at once more conservative and more ambitious. It favors a clear structure with properly decoupled layers, instead of chaining publishers throughout an implementation and directly assigning values at the end of publisher streams."),
                .text("Combine's ability to apply multiple transformations to a stream, creating a single chain of logic from the start of a flow to its end in the view layer, is very powerful. But for many programmers at this early stage in Combine's history, that approach seems likely to encourage tightly coupled business and view logic and to prevent a more flexible relationship between business state and display state."),
                .text("As programmers develop their skills at Combine, it will be worth revisiting what approaches can fit well into a fully decoupled, unidirectional pattern. The Performer layer already shows how we can use chaining to transform business state with certainty. Everywhere else, Poet uses ObservableObject and PassthroughSubject comprehensively but relies on its own structure for the transformation of business state into display state."),
                .text("The difference in approaches isn't exactly six of one, half a dozen of the other. Often we want to apply several display state transformations in response to a single change in business state, or conversely to take into account several properties of business state in order to change a single property of display state. It's a little difficult to have it both ways unless we do all our thinking in one place."),
                .text("Combine could accomplish this by combining several inputs into a single publisher. You could imagine a different pattern where, instead of listening for a new step, an object listens to these agglomerated publishers, which could ultimately deliver multiple values in one fell swoop — a little like a step, but smaller and built with a certain use in mind."),
                .text("That could work well enough, but its application could be uneven and a little taxing on the reader: some publishers would promise a single property, while other publishers would deliver a combination. The layer that performs the transformations into display state would be at once dense and scattered, and individual choices would be hard to track down."),
                .text("Poet gets ahead of that problem by choosing instead to make steps a first class member of the pattern. The programmer always considers all of a step's transformations within a single method. The cognitive overhead of considering an entire step is minimal, as it improves readability and creates a flexible structure that suits all the transformations we might apply."),
                .text("Is there a cost? Yes, a little. Every time a Poet evaluator creates new business state, it must explicitly create a new step configuration. If it moves from one step to another, it will need to explicitly unwrap the old step's configuration and reuse any values needed in the new step's configuration."),
                .text("Even in complicated scenarios, that's not so bad. For instance, say we want to enter a certain step from several different steps, each containing a different set of values. We don't want to inspect all those steps individually, and we don't have to. The steps could conform to a protocol which promises the same names for certain properties. Our new step could unwrap the values it needs without caring which previous step they belonged to."),
                .text("Depending on the nature of the problem being solved, the inspection of a previous step to make a new one might seem like unnecessary overhead. On complicated screens, however, it helps. The steps create an explicit boundary around possible states, preventing us from inadvertently straddling an incoherent combination of states."),
                .text("Whenever we define a full step, we promise to have accounted for all business state. Each time we translate it, we promise to have accounted for all of our display state. If the programmer has made a mistake, it can be easily located and fixed. Poet's steps are not the only viable solution, but they are obvious and easy to reason about."),
                .text("In its relatively conservative approach, Poet errs on the side of readable and decoupled code, freeing the developer to think clearly and quickly. Business state is always stored in a single struct. Display state transformations always happen in a single place. The programmer gains speed, certainty, and the ability to create flexible, reusable code that is suprisingly powerful.")
            ])
        )
    }
}
