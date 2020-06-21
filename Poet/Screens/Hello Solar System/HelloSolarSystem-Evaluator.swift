//
//  HelloSolarSystem-Evaluator.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/15/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

extension HelloSolarSystem {
    class Evaluator {
        
        typealias CelestialBody = HelloSolarSystem.CelestialBody
        
        // Translator
        lazy var translator: Translator = Translator(current)
        
        // Current State
        var current = PassableState(State.initial)
    }
}

// MARK: Actions
extension HelloSolarSystem.Evaluator {
    enum Action: EvaluatorAction {
        case advanceImage
        case showCelestialBody(CelestialBody)
        
        /*
         Each Celestial Body button can be treated as a tab on screen.
         */
        
        func actionWithIconAndID() -> IconRepresentedAndIdentifiedEvaluatorAction<Action>? {
            switch self {
                
            case .showCelestialBody(let body):
                return IconRepresentedAndIdentifiedEvaluatorAction(
                    icon: body.images.first ?? "",
                    id: String(body.id.uuidString),
                    action: self)
                
            default:
                return nil
            }
        }
    }
}

// MARK: States
extension HelloSolarSystem.Evaluator {
    
    enum State: EvaluatorState {
        case initial
        case celestialBody(CelestialBodyState)
    }
    
    struct CelestialBodyState {
        let celestialBodies: [CelestialBody]
        let currentCelestialBody: CelestialBody
        let currentImageIndex: Int
        let tapAction: Action?
        
        func stateForNextImage() -> CelestialBodyState {
            let newIndex: Int = {
                if currentImageIndex < currentCelestialBody.images.count - 1 {
                    return currentImageIndex + 1
                } else {
                    return 0
                }
            }()
            
            let state = CelestialBodyState(
                celestialBodies: celestialBodies,
                currentCelestialBody: currentCelestialBody,
                currentImageIndex: newIndex,
                tapAction: tapAction)
            
            return state
        }
    }
}

// MARK: View Cycle
extension HelloSolarSystem.Evaluator: ViewCycleEvaluating {
    
    /**
     On viewDidAppear(), we fetch data from a Store. Then we make (and assign) a CelestialBodyState that contains our fetched data.
     */
    func viewDidAppear() {
        let data = HelloSolarSystem.Store.shared.data
        
        if let first = data.first {
            
            // On viewDidAppear,
            
            let state = CelestialBodyState(
                celestialBodies: data,
                currentCelestialBody: first,
                currentImageIndex: 0,
                tapAction: first.images.count > 1 ? .advanceImage : nil)
            
            current.state = .celestialBody(state)
        }
    }
}

// MARK: Action Evaluating
extension HelloSolarSystem.Evaluator: ActionEvaluating {
    func _evaluate(_ action: Action) {
        switch action {
            
        case .advanceImage:
            advanceImage()
            
        case .showCelestialBody(let body):
            showCelestialBody(body)
        }
    }
    
    /**
    advanceImage(:) makes (and assigns) a new CelestialBodyState using the next image index.
    */
    func advanceImage() {
        guard case let .celestialBody(currentState) = current.state else { return }
        current.state = .celestialBody(currentState.stateForNextImage())
    }
    
    /**
     showCelestialBody(:) makes (and assigns) a new CelestialBodyState using the chosen celestial body.
     It carries over the `celestialBodies` data from the previous state.
     */
    func showCelestialBody(_ body: CelestialBody) {
        guard case let .celestialBody(currentState) = current.state else { return }
        
        let state = CelestialBodyState(
            celestialBodies: currentState.celestialBodies,
            currentCelestialBody: body,
            currentImageIndex: 0,
            tapAction: body.images.count > 1 ? .advanceImage : nil)
        
        current.state = .celestialBody(state)
    }
}
