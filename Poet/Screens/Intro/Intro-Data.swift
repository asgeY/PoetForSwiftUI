//
//  Intro-Data.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/26/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

class IntroDataStore {
static let shared = IntroDataStore()

    let page: Page = Page(
        title: "Intro",
        body: [
            .text("The Poet pattern is an easy and powerful approach to making iOS apps with SwiftUI, one screen at a time. Poet is an acronym:"),
                
            .quote("Protocol-Oriented Evaluator Translator"),
            
            .image("poet-intro-small"),
                
            .text("Poet began before SwiftUI, but there was a lot more plumbing involved. Now, it's smaller and easier to follow. The benefits of Poet emerge as screens get more and more complex. No matter what you make, Poet code will remain:"),
                
            .quote(
                """
                * Readable
                * Refactorable
                * Composable
                * Testable
                * Observable
                """),
            
            .text("Poet was developed by Steve Cotner at a shoe company in Portland, Oregon from 2018 to 2020.  It began with some early encouragement from colleagues Dave Camp, Zach Heusinkveld, Ranjith Ramachandran, and Pete Salvo and has benefited from the feedback of many talented developers."),
                
            .quote("© 2020 Steve Cotner."),
            
            .fineprint(
                """
                All code and architectural patterns presented herein are shared under the MIT License.

                Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

                The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

                THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
                """)
        ]
    )
}
