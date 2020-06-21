//
//  HelloSolarSystem-Translator.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/15/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine
import SwiftUI

extension HelloSolarSystem {

    class Translator {
        
        typealias Evaluator = HelloSolarSystem.Evaluator
        typealias Action = Evaluator.Action
        
        // Observable Display State
        var title = ObservableString()
        var imageName = ObservableString()
        var foregroundColor = Observable<Color>(.clear)
        var backgroundColor = Observable<Color>(.clear)
        var tapAction = Observable<Action?>()
        var shouldShowTapMe = ObservableBool()
        var tabs = ObservableArray<IconRepresentedAndIdentifiedEvaluatorAction<Action>>([])
        var currentTab = Observable<IconRepresentedAndIdentifiedEvaluatorAction<Action>?>(nil)
        
        // Passthrough Behavior
        private var stateSink: AnyCancellable?
        
        init(_ state: PassableState<Evaluator.State>) {
            stateSink = state.subject.sink { [weak self] value in
                self?.translate(state: value)
            }
        }
    }
}

extension HelloSolarSystem.Translator {
    func translate(state: Evaluator.State) {
        switch state {
            
        case .initial:
            break // no initial setup needed
            
        case .celestialBody(let state):
            translateCelestialBodyState(state)
        }
    }
    
    func translateCelestialBodyState(_ state: Evaluator.CelestialBodyState) {
        // Set observable display state
        title.string = "Hello \(state.currentCelestialBody.name)!"
        imageName.string = state.currentCelestialBody.images[state.currentImageIndex]
        foregroundColor.value = state.currentCelestialBody.foreground.color
        backgroundColor.value = state.currentCelestialBody.background.color
        tapAction.value = state.tapAction
        tabs.array = state.celestialBodies.map { Action.showCelestialBody($0).actionWithIconAndID() }.compactMap { $0 }
        withAnimation(.linear) {
            shouldShowTapMe.bool = state.tapAction != nil
        }
        withAnimation(.spring(response: 0.45, dampingFraction: 0.65, blendDuration: 0)) {
            currentTab.value = Action.showCelestialBody(state.currentCelestialBody).actionWithIconAndID()
        }
        
    }
}
