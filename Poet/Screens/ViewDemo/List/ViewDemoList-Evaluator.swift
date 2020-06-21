//
//  ViewDemoList-Evaluator.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/2/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

extension ViewDemoList {
    class Evaluator {
        
        // Translator
        lazy var translator: Translator = Translator(current)
        
        // Current State
        var current = PassableState(State.initial)
    }
}

// MARK: State

extension ViewDemoList.Evaluator {
    enum State: EvaluatorState {
        case initial
        case list(ListState)
    }
    
    struct ListState {
        var demoProviders: [NamedDemoProvider]
    }
}

// MARK: View Cycle

extension ViewDemoList.Evaluator: ViewCycleEvaluating {
    func viewDidAppear() {
        showList()
    }
    
    func showList() {
        let state = ListState(
            demoProviders: [
                ObservingTextView.namedDemoProvider,
                OptionsView.namedDemoProvider,
                ProductView.namedDemoProvider,
                DisplayableProductsView.namedDemoProvider
            ]
        )
        current.state = .list(state)
    }
}

// MARK: Actions

extension ViewDemoList.Evaluator: ActionEvaluating {
    
    enum Action: EvaluatorAction {
        case showDemo(NamedDemoProvider)
        case showDemoBuilder
    }
    
    func _evaluate(_ action: Action) {
        switch action {
        
        case .showDemo(let provider):
            translator.showDemo.withValue(provider)
        
        case .showDemoBuilder:
            translator.showDemoBuilder.please()
        }
    }
}

// MARK: PresenterEvaluating

extension ViewDemoList.Evaluator: PresenterEvaluating {
    func presenterDidDismiss(elementName: EvaluatorElement?) {
        // Reinitialize all the providers
        showList()
    }
}
