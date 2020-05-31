//
//  Menu-Translator.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/24/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine
import Foundation

extension Menu {
    
    class Translator {
        typealias Evaluator = Menu.Evaluator
        
        // Observable state
        var items = ObservableArray<MenuListItem>([])
        
        // Behavior
        var stepSink: AnyCancellable?
        
        init(_ items: PassableArray<MenuListItem>) {
            self.stepSink = items.subject.sink(receiveValue: { (value) in
                if let value = value {
                    self.items.array = value
                }
            })
        }
    }
}
