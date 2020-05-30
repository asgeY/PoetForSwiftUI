//
//  Chapter_LoginDemo.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/30/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

extension Tutorial.PageStore {
    var chapter_LoginDemo: Chapter {
        return Chapter(
            "Login Demo",
            pages:
            Page([.text("If you tap “Show Login Demo” you'll see a basic login user flow. Try it out.")], action: .showLoginDemo)
        )
    }
}
