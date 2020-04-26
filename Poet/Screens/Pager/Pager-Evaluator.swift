//
//  Pager-Evaluator.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/24/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

extension Pager {
    class Evaluator {
        
        // Translator
        
        let translator: Translator = Translator()
        
        // Data
        
        private var pages = PagerDataStore.shared.pages
        
        // State
        
        private var pageIndex: Int = 0
        private var currentPage: Page { pages[pageIndex] }
    }
}

// MARK: Private methods for manipulating state

extension Pager.Evaluator {
    func decrementPage() {
        if pageIndex > 0 {
            pageIndex -= 1
        }
    }
    
    func incrementPage() {
        if pageIndex < pages.count - 1 {
            pageIndex += 1
        }
    }
}

// MARK: Button Handling

extension Pager.Evaluator {
    func leftAction() {
        decrementPage()
        showCurrentPage()
    }
    
    func rightAction() {
        incrementPage()
        showCurrentPage()
    }
    
    func pageNumberAction() {
        translator.showAlert(title: "Hello.", message: "You're on page \(pageIndex + 1) of \(pages.count)")
    }
    
    func showCurrentPage() {
        translator.show(
            page: currentPage,
            number: pageIndex + 1,
            of: pages.count)
    }
    
    func titleAction() {
        translator.showRandomEmoji()
    }
}

// MARK: View Cycle

extension Pager.Evaluator: ViewCycleEvaluator {
    func viewDidAppear() {
        showCurrentPage()
    }
}
