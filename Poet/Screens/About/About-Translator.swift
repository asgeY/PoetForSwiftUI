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
        
        // Observable state
        var sections = ObservableArray<ObservingPageViewSection>([])
    }
}

// MARK: Translating Methods

extension About.Translator {
    
    func show(page: StaticPage) {
        sections.array = page.body
    }
}
