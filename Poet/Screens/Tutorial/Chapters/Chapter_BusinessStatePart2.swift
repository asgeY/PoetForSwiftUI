//
//  Chapter_BusinessStatePart2.swift
//  Poet
//
//  Created by Steve Cotner on 5/26/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

extension Tutorial.PageStore {
    var chapter_BusinessStatePart2: Chapter {
        return Chapter(
            "Business State, Part 2 (In Progress)",
            pages:
            Page([.text("In this chapter, we build on familiar concepts and run through a quick example of an evaluator/translator/screen working together in a new scenario."),
                  .text("Tap the button that says “Show Hello Solar System” to see a new screen. Play around for a bit and come back when you're done.")
            ],
                 action: .showHelloSolarSystem),
            Page([.text("The Hello Solar System example demonstrates how a good pattern actually simplifies our logic even as the problem grows more complex. Our Evaluator does most of its thinking using two types:"),
                  .smallCode("CelestialBody\nCelestialBodyStepConfiguration")], action: .showHelloSolarSystem),
            Page([.text("In viewDidAppear(), we map instances of CelestialBody from JSON data. We then make a step configuration to store that data and select the first CelestialBody as our “currentCelestialBody.”")], action: .showHelloSolarSystem),
            Page([.text("The evaluator only thinks about three things: what are all the celestial bodies? Which one is currently showing? And which image is currently showing for that body?")], action: .showHelloSolarSystem),
            Page([.text("As our screens get more complex, display state gets more interesting. Our translator interprets the business state by doing some rote extraction (names, images), but also by creating an array of tabs to show on screen.")], action: .showHelloSolarSystem),
            
            Page([.text("Each tab is just an Action, which on this screen conforms to a protocol promising an icon and ID for each action:"),
              .extraSmallCode(
                """
                tabs.array =
                 configuration.celestialBodies.map {
                  Action.showCelestialBody($0) }
                """
            )], action: .showHelloSolarSystem),
            
            Page([.text("Whichever body is designated as the currentCelestialBody will inform which tab is selected:"),
                  .extraSmallCode(
                    """
                    currentTab.object =
                     Action.showCelestialBody(
                      configuration.currentCelestialBody)
                    """
                )], action: .showHelloSolarSystem),
            
            Page([.text("These are only slight transformations, but they justify the translator as a separate layer. Our business and display logic are cleanly separated and we don't repeat ourselves.")], action: .showHelloSolarSystem),
            Page([.text("Such a clean division between evaluator and translator is possible because the view layer does its part, too.")], action: .showHelloSolarSystem),
            
            Page([.text("The screen features a custom view that observes the translator's tabs and creates a CircularTabButton for each one:"),
                  .extraSmallCode(
                    """
                    ForEach(self.tabs.array, id: \\.id) {
                      tab in
                      CircularTabButton(
                        evaluator:self.evaluator, tab: tab
                      )
                    }
                    """
                )],
                 action: .showHelloSolarSystem,
                 supplement: Supplement(shortTitle: "CircularTabBar", fullTitle: "", body: [.code(
                    
                """
                struct CircularTabBar: View {
                    typealias TabButtonAction = EvaluatorActionWithIconAndID
                    
                    weak var evaluator: ActionEvaluating?
                    @ObservedObject var tabs: ObservableArray<TabButtonAction>
                    @ObservedObject var currentTab: Observable<TabButtonAction?>
                    let spacing: CGFloat = 30
                    
                    var body: some View {
                        ZStack {
                            HStack(spacing: spacing) {
                                // MARK: World Button
                                ForEach(self.tabs.array, id: \\.id) { tab in
                                    CircularTabButton(evaluator: self.evaluator, tab: tab)
                                }
                            }.overlay(
                                GeometryReader() { geometry in
                                    Capsule()
                                        .fill(Color.primary.opacity(0.06))
                                        .frame(width: geometry.size.width / CGFloat(self.tabs.array.count), height: 48)
                                        .opacity(self.indexOfCurrentTab() != nil ? 1 : 0)
                                        .offset(x: {
                                            let divided = CGFloat((geometry.size.width + self.spacing) / CGFloat(self.tabs.array.count))
                                            return divided * CGFloat(self.indexOfCurrentTab() ?? 0) + (self.spacing / 2.0) - (geometry.size.width / 2.0)
                                        }(), y: 0)
                                        .allowsHitTesting(false)
                                }
                            )
                        }
                    }
                    
                    func indexOfCurrentTab() -> Int? {
                        if let currentTabObject = currentTab.object {
                            return self.tabs.array.firstIndex { tab in
                                tab.id == currentTabObject.id
                            }
                        }
                        return nil
                    }
                    
                    struct CircularTabButton: View {
                        weak var evaluator: ActionEvaluating?
                        let tab: TabButtonAction
                        var body: some View {
                            Button(action: { evaluate(self.tab) }) {
                                Image(self.tab.icon)
                                .resizable()
                                .frame(width: 30, height: 30)
                            }
                        }
                    }
                }
                """)])
            ),
                
            Page([.text("The CircularTabBar also figures out which tab button should be highlighted, based on the currentTab it observes. It calculates the offset of the highlight to match the correct tab's location.")], action: .showHelloSolarSystem),
            
            Page([.text("So the view is smart about view logic but unopinionated about its content, which is determined by business and display state.")], action: .showHelloSolarSystem),
            
            Page([.text("This separation of concerns makes it easy for the translator to animate its changes:"),
                  .extraSmallCode(
                    """
                    withAnimation(
                    .spring(response: 0.45,
                            dampingFraction: 0.65,
                            blendDuration: 0)) {
                      currentTab.object =
                       Action.showCelestialBody(
                       configuration.currentCelestialBody)
                    }
                    """
                )],
                 action: .showHelloSolarSystem,
                 supplement: Supplement(shortTitle: "translateCelestialBodyStep", fullTitle: "", body: [
                    .code(
                        """
                        func translateCelestialBodyStep(_ configuration: Evaluator.CelestialBodyStepConfiguration) {
                            // Set observable display state
                            title.string = "Hello \\(configuration.currentCelestialBody.name)!"
                            imageName.string = configuration.currentCelestialBody.images[configuration.currentImageIndex]
                            foregroundColor.object = configuration.currentCelestialBody.foreground.color
                            backgroundColor.object = configuration.currentCelestialBody.background.color
                            tapAction.object = configuration.tapAction
                            tabs.array = configuration.celestialBodies.map { Action.showCelestialBody($0) }
                            withAnimation(.linear) {
                                shouldShowTapMe.bool = configuration.tapAction != nil
                            }
                            withAnimation(.spring(response: 0.45, dampingFraction: 0.65, blendDuration: 0)) {
                                currentTab.object = Action.showCelestialBody(configuration.currentCelestialBody)
                            }
                        }
                        """
                    )
                ])
            ),
            
            Page([.text("The end result is a well-organized screen that is flexible enough to show whatever the JSON prescribes, with clearly defined business state, display state, and view logic. Now let's move on to something more complex.")])
        )
    }
}
