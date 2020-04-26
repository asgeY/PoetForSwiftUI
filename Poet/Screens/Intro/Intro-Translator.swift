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
        struct Observable {
            var pageTitle = ObservableString()
            var pageBody = ObservableArray<Page.Element>([])
        }
        var observable = Observable()
    }
}

// MARK: Translating Methods

extension Intro.Translator {
    
    func show(page: Page) {
        observable.pageTitle.string = page.title
        observable.pageBody.array = page.body
    }
}
