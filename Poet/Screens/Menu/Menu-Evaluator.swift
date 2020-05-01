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
        
        var items = PassableArray<MenuListItem>()
    }
}

// MARK: View Cycle

extension Menu.Evaluator: ViewCycleEvaluator {
    
    func viewDidAppear() {
        typealias Link = Menu.Link
        typealias Title = Menu.Title
        
        items.array = [
            Link("Introduction",
                 destination: { AnyView(Intro.Screen()) }),
            
            Link("The Smallest Tutorial",
                 destination: { AnyView(Text("Coming soon...")) }),
            
            Link("A Bigger Tutorial",
                 destination: { AnyView(BiggerTutorial.Screen()) }),
            
            Title("Retail Example"),
            
            Link("Retail Demo",
                 destination: { AnyView(RetailTutorial.Screen()) }),
            
            Link("Observable Page View Tutorial",
                 destination: { AnyView(Text("Coming soon...")) }),
            
            Title("Checklist Example"),
            
            Link("Checklist Demo",
                 destination: { AnyView(Text("Coming soon...")) }),
            
            Link("Checklist Tutorial",
                 destination: { AnyView(Text("Coming soon...")) }),
            
            Title("Little Helpers"),
            
            Link("Dismiss Receiver",
                 destination: { AnyView(DismissReceiverExample.Screen()) })
        ]
    }
}
