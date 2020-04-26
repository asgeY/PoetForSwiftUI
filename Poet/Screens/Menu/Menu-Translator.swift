//
//  Menu-Translator.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/24/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

extension Menu {
    
    class Translator {
        typealias Evaluator = Menu.Evaluator
        
        // Observable state
        struct Observable {
            var items = ObservableArray<ListEvaluatorItem>(Evaluator.Item.allCases)
        }
        var observable = Observable()
    }
}

// MARK: Translating Methods

/*
 Here we translate the expressed intent of the evaluator
 into state that our views can listen to: observables and passables
 */

extension Menu.Translator {
    
    func show(items: [Evaluator.Item]) {
        observable.items.array = items
    }
}
