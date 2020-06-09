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
        )
        current.step = .build(configuration)
    }
}

extension DemoBuilder.Evaluator: ActionEvaluating {
    
    enum Action: EvaluatorAction {
        case addDemoView(DemoProvider)
    }
    
    func evaluate(_ action: EvaluatorAction?) {
        guard let action = action as? Action else { return }
        
        switch action {
            
        case .addDemoView(let demoProvider):
            break
            
        }
    }
}

extension DemoBuilder.Evaluator: PresenterEvaluating {
    func presenterDidDismiss(elementName: EvaluatorElement?) {
        
    }
}
