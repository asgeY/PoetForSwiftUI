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
        
        // Current State
        var current = PassableState(State.initial)
        
        deinit {
            debugPrint("demobuilder deinit evaluator")
        }
    }
}

// MARK: State

extension DemoBuilder.Evaluator {
    enum State: EvaluatorState {
        case initial
        case build(BuildState)
    }
    
    struct BuildState {
        var arrangedDemoProviders: [NamedDemoProvider]
    }
}

// MARK: View Cycle

extension DemoBuilder.Evaluator: ViewCycleEvaluating {
    func viewDidAppear() {
        showBuildState()
    }
    
    func showBuildState() {
        let state = BuildState(
            arrangedDemoProviders: []
        )
        current.state = .build(state)
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
    
    func _evaluate(_ action: Action) {
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
            InstructionsView.namedDemoProvider,
            DisplayableProductsView.namedDemoProvider,
            OptionsView.namedDemoProvider,
            TitleView.namedDemoProvider
        ])
    }
    
    func addDemoView(_ namedDemoProvider: NamedDemoProvider) {
        guard case var .build(state) = current.state else { return }
        state.arrangedDemoProviders.append(namedDemoProvider)
        
        // wait for dismiss to finish, so view renders correctly on screen.
        // otherwise, scroll view has buggy taps.
        // hoping this is a short term SwiftUI issue.
        afterWait(400) {
            self.current.state = .build(state)
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
        guard case var .build(state) = current.state else { return }
        for (index, demoProvider) in state.arrangedDemoProviders.enumerated() {
            if demoProvider.id == namedDemoProvider.id {
                state.arrangedDemoProviders.remove(at: index)
                break
            }
        }
        current.state = .build(state)
    }
    
    func moveDemoViewUp(_ namedDemoProvider: NamedDemoProvider) {
        guard case var .build(state) = current.state else { return }
        for (index, demoProvider) in state.arrangedDemoProviders.enumerated() {
            if demoProvider.id == namedDemoProvider.id {
                guard index > 0 else { return }
                state.arrangedDemoProviders.remove(at: index)
                state.arrangedDemoProviders.insert(namedDemoProvider, at: index - 1)
                break
            }
        }
        current.state = .build(state)
    }
    
    func moveDemoViewDown(_ namedDemoProvider: NamedDemoProvider) {
        guard case var .build(state) = current.state else { return }
        for (index, demoProvider) in state.arrangedDemoProviders.enumerated() {
            if demoProvider.id == namedDemoProvider.id {
                guard index < state.arrangedDemoProviders.count - 1 else { return }
                state.arrangedDemoProviders.remove(at: index)
                state.arrangedDemoProviders.insert(namedDemoProvider, at: index + 1)
                break
            }
        }
        current.state = .build(state)
    }
}

// MARK: DemoViewEditingEvaluating

extension DemoBuilder.Evaluator: DemoViewEditingEvaluating {
    func saveChangesToProvider(_ namedDemoProvider: NamedDemoProvider) {
        guard case var .build(state) = current.state else { return }
        let namedDemoProvider = namedDemoProvider.deepCopy()
        for (index, demoProvider) in state.arrangedDemoProviders.enumerated() {
            if demoProvider.id == namedDemoProvider.id {
                state.arrangedDemoProviders[index] = namedDemoProvider
                break
            }
        }
        
        current.state = .build(state)
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
