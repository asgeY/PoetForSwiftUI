//
//  Pager-Translator.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/24/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

extension Pager {
    
    class Translator: AlertTranslating {
        typealias Evaluator = Pager.Evaluator
        
        // Observable state
        struct Observable {
            var isLeftButtonEnabled = ObservableBool(true)
            var isRightButtonEnabled = ObservableBool(true)
            var pageTitle = ObservableString()
            var pageBody = ObservableArray<Page.Element>([])
            var pageXofX = ObservableString()
        }
        var observable = Observable()
        
        var alertTranslator = AlertTranslator()
        
        // Passable changes of state
        struct Passable {
            var emoji = PassableString()
        }
        var passable = Passable()
    }
}

// MARK: Translating Methods

/*
 Here we translate the expressed intent of the evaluator
 into state that our views can listen to: observables and passables
 */

extension Pager.Translator {
    
    func show(page: Page, number: Int, of total: Int) {
        observable.pageTitle.string = page.title
        observable.pageBody.array = page.body
        observable.pageXofX.string = "\(number) / \(total)"
        observable.isLeftButtonEnabled.bool = number > 1
        observable.isRightButtonEnabled.bool = number < total
    }
    
    func showRandomEmoji() {
        let emojis = ["🐥", "🦈", "🐄", "🐟", "🐙", "🦕", "🦉", "🐯", "🐢", "🐘", "🦔", "🐆", "🐛", "🐌", "🐞", "🐴", "👨🏻‍💻"]
        passable.emoji.string = emojis.randomElement()!
    }
}
