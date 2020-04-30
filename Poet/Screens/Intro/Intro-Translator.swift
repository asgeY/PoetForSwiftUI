//
//  Intro-Translator.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/24/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

extension Intro {
    
    class Translator {
        typealias Evaluator = Intro.Evaluator
        
        // Observable state
        var pageBody = ObservableArray<Page.Element>([])
    }
}

// MARK: Translating Methods

extension Intro.Translator {
    
    func show(page: Page) {
        pageBody.array = page.body
    }
}
