//
//  Chapter_ViewDemoing.swift
//  Poet
//
//  Created by Steve Cotner on 6/6/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

extension Tutorial.PageStore {
var chapter_ViewDemoing: Chapter {
    return Chapter(
        "View Demoing",
        pages:
        Page([
            .demo(.showViewDemoList),
            .text("Many design teams use the VQA process (Visual Quality Assurance) to ensure that views on screen meet their requirements."),
            .text("View Demos can help. By augmentiong individual views with the knowledge of how to demo themselves, we can streamline that process and help designers maintain a working library of views as components."),
            .text("Demos are similar to SwiftUI's built-in Previews, but they can be tested on a device and can include controls for modifying their values on screen. The result is an instantly configurable view that can be poked and prodded to a designer's heart's content."),
            .title("Ad Hoc Screens"),
            .text("A designer can also build their own demo by combining individual View Demos as building blocks (coming soon) — in effect, making an ad hoc new screen. It wouldn't be hard to imagine saving this info for later use, too, allowing designers to build a custom library over time. We can also imagine designers sending a link for the demo to someone else who has the same codebase installed, who could then open the same demo on their own device."),
            .text("We could also produce an image of the entire screen (even elements scrolled off screen) and save it to the camera roll or export it. Designers could then use their own tools to further inspect their creation."),
            .text("When designers have confidence in the interrelation of each component to others, they can spend significantly less time checking each screen an engineer produces. They can even use this building block approach to mock up new screens."),
            .title("Product"),
            .text("At the risk of encouraging premature “solutioning,” ad hoc screens would also allow product owners and managers to mock up their own ideas. Product folks would benefit by being able to tinker with new ideas, and teams with good habits of communication could take these product mock-ups as nothing more than napkin sketches — constructive suggestions meant to kick off more in-depth brainstorm sessions or design iterations."),
            .title("QA"),
            .text("View Demos also let engineers and quality assurance testers inspect views in isolation and verify that they behave as expected. This can include testing longer and shorter strings, different languages, and so on.")
        ])
    )}
}
