//
//  DemoBuilder-Evaluator.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/2/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

extension DemoBuilder {
    class Evaluator {
        
        // Translator
        lazy var translator: Translator = Translator(current)
        
        // Current Step
        var current = PassableStep(Step.initial)
    }
}

// Steps and Step Configurations
extension DemoBuilder.Evaluator {
    enum Step: EvaluatorStep {
        case initial
        case build(BuildStepConfiguration)
    }
    
    struct BuildStepConfiguration {
        var arrangedDemoProviders: [NamedDemoProvider]
    }
}

// View Cycle
extension DemoBuilder.Evaluator: ViewCycleEvaluating {
    func viewDidAppear() {
        showBuildStep()
    }
}

// Advancing Between Steps
extension DemoBuilder.Evaluator {
    func showBuildStep() {
        let configuration = BuildStepConfiguration(
            arrangedDemoProviders: []
        )
        current.step = .build(configuration)
    }
}

struct DemoViewEditingConfiguration {
    let namedDemoProvider: NamedDemoProvider
    let evaluator: DemoViewEditingEvaluating
}

protocol DemoViewEditingEvaluating {
    func saveChangesToProvider(_ namedDemoProvider: NamedDemoProvider)
}

extension DemoBuilder.Evaluator: ActionEvaluating {
    
    enum Action: EvaluatorAction {
        case addDemoView(NamedDemoProvider)
        case editDemoView(NamedDemoProvider)
    }
    
    func evaluate(_ action: EvaluatorAction?) {
        guard let action = action as? Action else { return }
        
        switch action {
            
        case .addDemoView(let namedDemoProvider):
            addDemoView(namedDemoProvider)
            
        case .editDemoView(let namedDemoProvider):
            editDemoView(namedDemoProvider)
        }
    }
    
    func addDemoView(_ namedDemoProvider: NamedDemoProvider) {
        guard case var .build(configuration) = current.step else { return }
        configuration.arrangedDemoProviders.append(namedDemoProvider)
        current.step = .build(configuration)
    }
    
    func editDemoView(_ namedDemoProvider: NamedDemoProvider) {
        let namedDemoProvider = namedDemoProvider.deepCopy()
        translator.editDemoView.withValue(
            DemoViewEditingConfiguration(
                namedDemoProvider: namedDemoProvider,
                evaluator: self
        ))
    }
}

extension DemoBuilder.Evaluator: DemoViewEditingEvaluating {
    func saveChangesToProvider(_ namedDemoProvider: NamedDemoProvider) {
        guard case var .build(configuration) = current.step else { return }
        let namedDemoProvider = namedDemoProvider.deepCopy()
        for (index, demoProvider) in configuration.arrangedDemoProviders.enumerated() {
            if demoProvider.id == namedDemoProvider.id {
                configuration.arrangedDemoProviders[index] = namedDemoProvider
                break
            }
        }
        current.step = .build(configuration)
    }
}

extension DemoBuilder.Evaluator: PresenterEvaluating {
    func presenterDidDismiss(elementName: EvaluatorElement?) {
        current.step = current.step
    }
}
