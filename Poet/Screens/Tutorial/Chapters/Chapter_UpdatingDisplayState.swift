//
//  Chapter_BusinessStatePart2.swift
//  Poet
//
//  Created by Steve Cotner on 5/26/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

extension Tutorial.PageStore {
    var chapter_UpdatingDisplayState: Chapter {
        return Chapter(
            "Updating Display State",
            pages:
            Page([
                .demo(.showHelloSolarSystem),
                .text("In this chapter, we build on familiar concepts and run through a quick example of an evaluator/translator/screen working together in a new scenario."),
                .text("Tap the button that says “Hello Solar System” to see a new screen. Play around for a bit and come back when you're done."),
                .text("The Hello Solar System example demonstrates how a good pattern actually simplifies our logic even as the problem grows more complex. Our Evaluator does most of its thinking using two types:"),
                .code("CelestialBody\nCelestialBodyState"),
                .text("In viewDidAppear(), we map instances of CelestialBody from JSON data. We then make a step configuration to store that data and select the first CelestialBody as our “currentCelestialBody.”"),
                .text("The evaluator only thinks about three things: what are all the celestial bodies? Which one is currently showing? And which image is currently showing for that body?"),
                .text("As our screens get more complex, display state gets more interesting. Our translator interprets the business state by doing some rote extraction (names, images), but also by creating an array of tabs to show on screen."),
                .text("Each tab is just an Action, which on this screen conforms to a protocol promising an icon and ID for each action:"),
                .code(
                    """
                    tabs.array =
                     configuration.celestialBodies.map {
                      Action.showCelestialBody($0) }
                    """
                ),
                .file("HelloSolarSystem-Translator"),
                .space(),
            
                .text("Whichever body is designated as the currentCelestialBody will inform which tab is selected:"),
                .code(
                    """
                    currentTab.value =
                     Action.showCelestialBody(
                      configuration.currentCelestialBody)
                    """
                ),
            
                .text("These are only slight transformations, but they justify the translator as a separate layer. Our business and display logic are cleanly separated and we don't repeat ourselves."),
                .text("Such a clean division between evaluator and translator is possible because the view layer does its part, too."),
            
                .text("The screen features a custom view that observes the translator's tabs and creates a CircularTabButton for each one:"),
                .code(
                    """
                    ForEach(self.tabs.array, id: \\.id) {
                      tab in
                      CircularTabButton(
                        evaluator:self.evaluator, tab: tab
                      )
                    }
                    """
                ),
                .file("CircularTabBar"),
                
                .text("The CircularTabBar also figures out which tab button should be highlighted, based on the currentTab it observes. It calculates the offset of the highlight to match the correct tab's location."),
            
                .text("So the view is smart about view logic but unopinionated about its content, which is determined by business and display state."),
            
                .text("This separation of concerns makes it easy for the translator to animate its changes:"),
                .code(
                    """
                    withAnimation(
                    .spring(response: 0.45,
                            dampingFraction: 0.65,
                            blendDuration: 0)) {
                      currentTab.value =
                       Action.showCelestialBody(
                       configuration.currentCelestialBody)
                    }
                    """
                ),
                .text("The end result is a well-organized screen that is flexible enough to show whatever the JSON prescribes, with clearly defined business state, display state, and view logic. Now let's move on to something more complex.")
            ])
        )
    }
}
