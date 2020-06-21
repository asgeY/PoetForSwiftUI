//
//  RetailTwo-Translator.swift
//  Poet
//
//  Created by Stephen E. Cotner on 6/20/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine
import SwiftUI

extension RetailTwo {
    
    class Translator {
        
        typealias Evaluator = RetailTwo.Evaluator
        typealias Section = Retail.ViewMaker.Section
        typealias Action = Evaluator.Action
        
        // Observable Display State
        var sections = ObservableArray<Section>([])
        var instructions = ObservableArray<String>([])
        var focusableInstructionIndex = Observable<Int?>()
        var allowsCollapsingAndExpanding = ObservableBool()
        var customerTitle = ObservableString()
        var feedback = ObservableString()
        var zoneOptions = ObservableArray<String>([])
        var zonePreference = ObservableString()
        
        var bottomButtonAction = Observable<NamedEnabledEvaluatorAction<Action>?>()
        
        // Passables
        var dismiss = PassablePlease()
        var alert = PassableAlert()
        
        // State Sink
        private var stateSink: AnyCancellable?
        
        init(_ state: PassableState<Evaluator.State>) {
            stateSink = state.subject.sink { [weak self] value in
                self?.translate(state: value)
            }
        }
    }
}

extension RetailTwo.Translator {
    func translate(state: Evaluator.State) {
        switch state {
            
        case .initial:
            // no initial setup needed
            break
            
        case .start(let state):
            translateStart(state)
            
        case .chooseZone(let state):
            translateChooseZone(state)
            
        case .done(let state):
            translateDone(state)
        }
    }
    
    func translateStart(_ state: Evaluator.StartState) {
        
        // Set observable display state
        
        customerTitle.string = "\(state.customerName) is the name of this customer"
        instructions.array = state.instructions
        allowsCollapsingAndExpanding.bool = false
        feedback.string = "Next you'll choose a zone"
        sections.array = [
            customerTitle_,
            instructions_
        ]
        bottomButtonAction.value = NamedEnabledEvaluatorAction(name: state.action.name, enabled: true, action: state.action)
    }
    
    func translateChooseZone(_ state: Evaluator.ChooseZoneState) {
        
        withAnimation(.linear) {
            customerTitle.string = "\(state.customerName) is still the name of this customer"
            instructions.array = state.instructions
            focusableInstructionIndex.value = state.focusedInstructionIndex
            allowsCollapsingAndExpanding.bool = true
            zoneOptions.array = state.zoneOptions
            zonePreference.string = state.zonePreference ?? ""
            sections.array = [
                customerTitle_,
                instructions_,
                zoneOptions_
            ]
        }
        
        if let action = state.action {
            bottomButtonAction.value =  NamedEnabledEvaluatorAction(name: action.name, enabled: true, action: action)
        } else {
            bottomButtonAction.value = nil
        }
    }
    
    func translateDone(_ state: Evaluator.DoneState) {
        withAnimation(.linear) {
            customerTitle.string = "\(state.customerName) is still the name of this customer"
            instructions.array = state.instructions
            focusableInstructionIndex.value = state.focusedInstructionIndex
            allowsCollapsingAndExpanding.bool = true
            feedback.string = "You picked \(state.zonePreference)"
            
            sections.array = [
                customerTitle_,
                instructions_,
                feedback_,
            ]
        }
            
        bottomButtonAction.value = NamedEnabledEvaluatorAction(name: state.action.name, enabled: true, action: state.action)
    }
}

// MARK: Sections

extension RetailTwo.Translator {
    var customerTitle_: Section {
        return Section.customerTitle(title: customerTitle)
    }
    
    var instructions_: Section {
        return Section.instructions(
            instructions: instructions,
            focusableInstructionIndex: focusableInstructionIndex,
            allowsCollapsingAndExpanding: allowsCollapsingAndExpanding)
    }
    
    var feedback_: Section {
        return Section.feedback(feedback: feedback)
    }
    
    var zoneOptions_: Section {
        return Section.options(options: zoneOptions, preference: zonePreference)
    }
}
