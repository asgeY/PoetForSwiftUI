//
//  Menu-Evaluator.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/24/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation
import SwiftUI

extension Menu {
    class Evaluator {
        
        // Translator
        
        lazy var translator: Translator = Translator(items)
        
        // Data
        enum Item: String, CaseIterable, Identifiable, ListEvaluatorItem {
            case intro = "Intro"
            case pager = "Paging Tutorial"
            case retail = "Retail Example"
            
            var id: String {
                return self.name
            }
            
            var name: String {
                return self.rawValue
            }
        }
        
        var items = PassableArray<ListEvaluatorItem>()
    }
}

// MARK: View Cycle

extension Menu.Evaluator: ViewCycleEvaluator {
    func viewDidAppear() {
        items.array = Item.allCases
    }
}

// MARK: Navigation

extension Menu.Evaluator: ListEvaluator {
    
    // MARK: Note: NavigationLink currently calls this method for each screen as soon as Menu.Screen is loaded.
    // I will wait until SwiftUI 2.0 in June before I decide to optimize this behavior.
    // It doesn't load the bodies of those nested views, so it's harmless, at least in this case.
    
    func destination(for item: ListEvaluatorItem) -> AnyView? {
        guard let item = item as? Item else {
            return nil
        }
        
        switch item {
        case .intro:
            return AnyView(Intro.Screen())
        case .pager:
            return AnyView(PagingTutorial.Screen())
        case .retail:
            return AnyView(RetailTutorial.Screen())
        }
    }
}
