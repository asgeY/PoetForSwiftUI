//
//  RetailTwo-Evaluator.swift
//  Poet
//
//  Created by Stephen E. Cotner on 6/20/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

extension RetailTwo {
    class Evaluator {
        
        // Translator
        lazy var translator: Translator = Translator(current)
        
        // Current State
        var current = PassableState(State.initial)
    }
}

// MARK: State

extension RetailTwo.Evaluator {
    enum State: EvaluatorState {
        case initial
        case start(StartState)
        case chooseZone(ChooseZoneState)
        case done(DoneState)
    }
    
    struct StartState {
        var customerName: String
        var instructions: [String]
        var action: Action
    }
    
    struct ChooseZoneState {
        var customerName: String
        var instructions: [String]
        var focusedInstructionIndex: Int
        var zoneOptions: [String]
        var zonePreference: String?
        var action: Action?
    }
    
    struct DoneState {
        var customerName: String
        var instructions: [String]
        var focusedInstructionIndex: Int
        var zonePreference: String
        var action: Action
    }
}

// MARK: View Cycle

extension RetailTwo.Evaluator: ViewCycleEvaluating {
    func viewDidAppear() {
//        afterWait(500) {
            self.showStartState()
//        }
    }
    
    func showStartState() {
        let state = StartState(
            customerName: "Fleventy Five",
            instructions: [
                "Claim the order",
                "Pick a zone"
                ],
            action: .advanceFrom_Start
        )
        current.state = .start(state)
    }
}

// Mark: Actions

extension RetailTwo.Evaluator: ActionEvaluating {
    enum Action: EvaluatorAction {
        case advanceFrom_Start
        case advanceFrom_ChooseZone
        case done
        
        var name: String {
            switch self {
                
            case .advanceFrom_Start:
                return "Start"
                
            case .advanceFrom_ChooseZone:
                return "Next"
                
            case .done:
                return "Done"
            }
        }
    }
    
    func _evaluate(_ action: Action) {
        switch action {
            
        case .advanceFrom_Start:
            advanceFrom_Start()
            
        case .advanceFrom_ChooseZone:
            advanceFrom_ChooseZone()
            
        case .done:
            translator.dismiss.please()
        }
    }
    
    func advanceFrom_Start() {
        guard case let .start(currentState) = current.state else { return }
        let state = ChooseZoneState(
            customerName: currentState.customerName,
            instructions: currentState.instructions,
            focusedInstructionIndex: 1,
            zoneOptions: ["Zone A", "Zone B", "Zone C"],
            zonePreference: nil,
            action: nil
        )
        current.state = .chooseZone(state)
    }
    
    func advanceFrom_ChooseZone() {
        guard case let .chooseZone(currentState) = current.state else { return }
        
        if currentState.zonePreference == "Zone C" {
            
            translator.alert.withConfiguration(title: "Bad Zone", message: "There was a problem with Zone C. Please choose another.")
            
            let state = ChooseZoneState(
                customerName: currentState.customerName,
                instructions: currentState.instructions,
                focusedInstructionIndex: 1,
                zoneOptions: ["Zone A", "Zone B"],
                zonePreference: nil,
                action: nil)
            current.state = .chooseZone(state)
        } else {
            let state = DoneState(
                customerName: currentState.customerName,
                instructions: currentState.instructions + ["You're all set"],
                focusedInstructionIndex: currentState.instructions.count,
                zonePreference: currentState.zonePreference ?? "unknown",
                action: .done
            )
            current.state = .done(state)
        }
    }
}

// MARK: Options

extension RetailTwo.Evaluator: OptionsEvaluating {
    func _toggleOption(_ option: String) {
        guard case var .chooseZone(state) = current.state else { return }
        if state.zonePreference == option {
            state.zonePreference = nil
            state.action = nil
        } else {
            state.zonePreference = option
            state.action = .advanceFrom_ChooseZone
        }
        current.state = .chooseZone(state)
    }
}

// MARK: Finding products

extension RetailTwo.Evaluator: FindingProductsEvaluating {
    func _toggleProductFound(_ product: FindableProduct) {
        //
    }
    
    func _toggleProductNotFound(_ product: FindableProduct) {
        //
    }
}

