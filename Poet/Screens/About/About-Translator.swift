//
//  About-Translator.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/24/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

extension About {
    
    class Translator {
        typealias Evaluator = About.Evaluator
        typealias Section = StaticPageViewMaker.Section
        
        // Observable state
        var sections = ObservableArray<Section>([])
    }
}

// MARK: Translating Methods

extension About.Translator {
    
    func show(page: StaticPage) {
        sections.array = page.body
    }
}
