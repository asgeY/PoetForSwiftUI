//
//  DemoBuilder-Evaluator.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/2/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation
import SwiftUI

extension DemoBuilder {
    class Evaluator {
        
        // Translator
        lazy var translator: Translator = Translator(current)
        
        // Current Step
        var current = PassableStep(Step.initial)
        
        deinit {
            debugPrint("demobuilder deinit evaluator")
        }
    }
}

// MARK: Steps and Step Configurations

extension DemoBuilder.Evaluator {
    enum Step: EvaluatorStep {
        case initial
        case build(BuildStepConfiguration)
    }
    
    struct BuildStepConfiguration {
        var arrangedDemoProviders: [NamedDemoProvider]
    }
}

// MARK: View Cycle

extension DemoBuilder.Evaluator: ViewCycleEvaluating {
    func viewDidAppear() {
        showBuildStep()
    }
}

// MARK: Advancing Between Steps

extension DemoBuilder.Evaluator {
    func showBuildStep() {
        let configuration = BuildStepConfiguration(
            arrangedDemoProviders: []
        )
        current.step = .build(configuration)
    }
}

// MARK: Actions

extension DemoBuilder.Evaluator: ActionEvaluating {
    
    enum Action: EvaluatorAction {
        case promptToAddDemoView
        case addDemoView(NamedDemoProvider)
        case editDemoView(NamedDemoProvider)
        case deleteDemoView(NamedDemoProvider)
        case moveDemoViewUp(NamedDemoProvider)
        case moveDemoViewDown(NamedDemoProvider)
    }
    
    func implementEvaluate(_ action: EvaluatorAction?) {
        guard let action = action as? Action else { return }
        
        switch action {
            
        case .promptToAddDemoView:
            promptToAddDemoView()
            
        case .addDemoView(let namedDemoProvider):
            addDemoView(namedDemoProvider)
            
        case .editDemoView(let namedDemoProvider):
            editDemoView(namedDemoProvider)
            
        case .deleteDemoView(let namedDemoProvider):
            deleteDemoView(namedDemoProvider)
            
        case .moveDemoViewUp(let namedDemoProvider):
            moveDemoViewUp(namedDemoProvider)
            
        case .moveDemoViewDown(let namedDemoProvider):
            moveDemoViewDown(namedDemoProvider)
        }
    }
    
    func promptToAddDemoView() {
        translator.promptToAddDemoView.withValue([
            InstructionView.namedDemoProvider,
            DisplayableProductsView.namedDemoProvider,
            OptionsView.namedDemoProvider,
            TitleView.namedDemoProvider
        ])
    }
    
    func addDemoView(_ namedDemoProvider: NamedDemoProvider) {
        guard case var .build(configuration) = current.step else { return }
        configuration.arrangedDemoProviders.append(namedDemoProvider)
        
        // wait for dismiss to finish, so view renders correctly on screen.
        // otherwise, scroll view has buggy taps.
        // hoping this is a short term SwiftUI issue.
        afterWait(400) {
            self.current.step = .build(configuration)
        }
    }
    
    func editDemoView(_ namedDemoProvider: NamedDemoProvider) {
        let namedDemoProvider = namedDemoProvider.deepCopy()
        translator.editDemoView.withValue(
            DemoViewEditingConfiguration(
                namedDemoProvider: namedDemoProvider,
                evaluator: self
        ))
    }
    
    func deleteDemoView(_ namedDemoProvider: NamedDemoProvider) {
        guard case var .build(configuration) = current.step else { return }
        for (index, demoProvider) in configuration.arrangedDemoProviders.enumerated() {
            if demoProvider.id == namedDemoProvider.id {
                configuration.arrangedDemoProviders.remove(at: index)
                break
            }
        }
        current.step = .build(configuration)
    }
    
    func moveDemoViewUp(_ namedDemoProvider: NamedDemoProvider) {
        guard case var .build(configuration) = current.step else { return }
        for (index, demoProvider) in configuration.arrangedDemoProviders.enumerated() {
            if demoProvider.id == namedDemoProvider.id {
                guard index > 0 else { return }
                configuration.arrangedDemoProviders.remove(at: index)
                configuration.arrangedDemoProviders.insert(namedDemoProvider, at: index - 1)
                break
            }
        }
        current.step = .build(configuration)
    }
    
    func moveDemoViewDown(_ namedDemoProvider: NamedDemoProvider) {
        guard case var .build(configuration) = current.step else { return }
        for (index, demoProvider) in configuration.arrangedDemoProviders.enumerated() {
            if demoProvider.id == namedDemoProvider.id {
                guard index < configuration.arrangedDemoProviders.count - 1 else { return }
                configuration.arrangedDemoProviders.remove(at: index)
                configuration.arrangedDemoProviders.insert(namedDemoProvider, at: index + 1)
                break
            }
        }
        current.step = .build(configuration)
    }
}

// MARK: DemoViewEditingEvaluating

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

// MARK: DemoViewEditingEvaluating

extension DemoBuilder.Evaluator: ViewDemoPickerEvaluating {
    func pickViewDemo(_ provider: NamedDemoProvider) {
        addDemoView(provider)
    }
}

extension DemoBuilder.Evaluator: PresenterEvaluating {
    func presenterDidDismiss(elementName: EvaluatorElement?) {
        debugPrint("did dismiss")
    }
}
