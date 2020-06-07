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
            .text("Many design teams use the VQA process (Visual Quality Assurance) to ensure that views on screen meet their requirements. By making individual views know how to be demoed, we can streamline that process and help designers maintain a working library of views as components."),
            .text("View demos also allow developers and quality assurance testers to verify that views behave as expected. The demos are similar to SwiftUI's built-in Previews, but they can be tested on a device and can include controls for modifying values on screen.")
        ])
    )}
}
