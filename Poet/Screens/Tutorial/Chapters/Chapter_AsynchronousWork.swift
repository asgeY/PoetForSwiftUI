//
//  Chapter_AsynchronousWork.swift
//  Poet
//
//  Created by Steve Cotner on 5/26/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

extension Tutorial.PageStore {
    var chapter_AsynchronousWork: Chapter {
        return Chapter(
            "Asynchronous Work",
            pages:
            Page([
                .demo(.showLoginDemo),
                .text("If you tap “Login Demo” you'll see a basic login user flow. Try it out.")
            ])
        )
    }
}
