//
//  BiggerTutorial-Evaluator.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/24/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

extension BiggerTutorial {
    class Evaluator {
        
        // Translator
        
        lazy var translator: Translator = Translator(current)
        
        // Data
        
        private var pages = BiggerTutorialDataStore.shared.pages
        
        // Step
        
        var current = PassableStep(Step.loading)
    }
}

// MARK: Model

extension BiggerTutorial.Evaluator {
    
    enum Step: EvaluatorStep {
        case loading
        case page(PageConfiguration)
    }
    
    struct PageConfiguration {
        var page: Page
        var pageIndex: Int
        var pageNumber: Int { return pageIndex + 1}
        var pageCount: Int
    }

}

// MARK: Private methods for manipulating state

extension BiggerTutorial.Evaluator {
    func showFirstPage() {
        let configuration = PageConfiguration(
            page: pages[0],
            pageIndex: 0,
            pageCount: pages.count
        )
        current.step = .page(configuration)
    }
    
    func decrementPage() {
        if case var .page(configuration) = current.step {
            if configuration.pageIndex > 0 {
                configuration.pageIndex -= 1
                configuration.page = pages[configuration.pageIndex]
                current.step = .page(configuration)
            }
        }
    }
    
    func incrementPage() {
        if case var .page(configuration) = current.step {
            if configuration.pageIndex < pages.count - 1 {
                configuration.pageIndex += 1
                configuration.page = pages[configuration.pageIndex]
                current.step = .page(configuration)
            }
        }
    }
}

protocol EvaluatorStep {}

// MARK: Button Handling

extension BiggerTutorial.Evaluator {
    func leftAction() {
        decrementPage()
    }
    
    func rightAction() {
        incrementPage()
    }
    
    func titleAction() {
        translator.showBezel(character: randomEmoji())
    }
    
    func pageNumberAction() {
        if case let .page(configuration) = current.step {
            translator.showAlert(
                title: "Hello!",
                message:
                """
                You're on page \(configuration.pageNumber) of \(configuration.pageCount).
                Want to delete it?
                """,
                primaryAlertAction: AlertAction(title: "No thanks", style: .cancel, action: nil),
                secondaryAlertAction: AlertAction(title: "Delete", style: .destructive, action: {
                    [weak self] in
                    self?.deleteAction()
                })
            )
        }
    }
    
    func deleteAction() {
        translator.showAlert(
            title: "What?",
            message: "Why would you delete this?!",
            alertAction: AlertAction(title: "Sorry", style: .regular, action: nil)
        )
    }
    
    func randomEmoji() -> String {
        let emojis = ["🐥", "🦈", "🐄", "🐟", "🐙", "🦕", "🦉", "🐯", "🐢", "🐘", "🦔", "🐆", "🐛", "🐌", "🐞", "🐴", "👨🏻‍💻"]
        return emojis.randomElement()!
    }
}

// MARK: View Cycle

extension BiggerTutorial.Evaluator: ViewCycleEvaluator {
    func viewDidAppear() {
        showFirstPage()
    }
}
