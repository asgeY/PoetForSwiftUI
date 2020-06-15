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
        
        // Current Step
        var current = PassableStep(Step.initial)
    }
}

// Steps and Step Configurations
extension ViewDemoList.Evaluator {
    enum Step: EvaluatorStep {
        case initial
        case list(ListStepConfiguration)
    }
    
    struct ListStepConfiguration {
        var demoProviders: [NamedDemoProvider]
    }
}

// View Cycle
extension ViewDemoList.Evaluator: ViewCycleEvaluating {
    func viewDidAppear() {
        showListStep()
    }
}

// Advancing Between Steps
extension ViewDemoList.Evaluator {
    func showListStep() {
        let configuration = ListStepConfiguration(
            demoProviders: [
                ObservingTextView.namedDemoProvider,
                OptionsView.namedDemoProvider,
                ProductView.namedDemoProvider,
                DisplayableProductsView.namedDemoProvider
            ]
        )
        current.step = .list(configuration)
    }
}

extension ViewDemoList.Evaluator: ActionEvaluating {
    
    enum Action: EvaluatorAction {
        case showDemo(NamedDemoProvider)
        case showDemoBuilder
    }
    
    func implementEvaluate(_ action: EvaluatorAction?) {
        guard let action = action as? Action else { return }
        
        switch action {
        
        case .showDemo(let provider):
            translator.showDemo.withValue(provider)
        
        case .showDemoBuilder:
            translator.showDemoBuilder.please()
        }
    }
}

extension ViewDemoList.Evaluator: PresenterEvaluating {
    func presenterDidDismiss(elementName: EvaluatorElement?) {
        // Reinitialize all the providers
        showListStep()
    }
}
