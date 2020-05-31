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
        var tapAction = ObservableEvaluatorAction()
        var shouldShowTapMe = ObservableBool()
        var tabs = ObservableArray<EvaluatorActionWithIconAndID>([])
        var currentTab = Observable<EvaluatorActionWithIconAndID?>(nil)
        
        // Passthrough Behavior
        private var stepSink: AnyCancellable?
        
        init(_ step: PassableStep<Evaluator.Step>) {
            stepSink = step.subject.sink { [weak self] value in
                self?.translate(step: value)
            }
        }
    }
}

extension HelloSolarSystem.Translator {
    func translate(step: Evaluator.Step) {
        switch step {
            
        case .initial:
            break // no initial setup needed
            
        case .celestialBody(let configuration):
            translateCelestialBodyStep(configuration)
        }
    }
    
    func translateCelestialBodyStep(_ configuration: Evaluator.CelestialBodyStepConfiguration) {
        // Set observable display state
        title.string = "Hello \(configuration.currentCelestialBody.name)!"
        imageName.string = configuration.currentCelestialBody.images[configuration.currentImageIndex]
        foregroundColor.value = configuration.currentCelestialBody.foreground.color
        backgroundColor.value = configuration.currentCelestialBody.background.color
        tapAction.action = configuration.tapAction
        tabs.array = configuration.celestialBodies.map { Action.showCelestialBody($0) }
        withAnimation(.linear) {
            shouldShowTapMe.bool = configuration.tapAction != nil
        }
        withAnimation(.spring(response: 0.45, dampingFraction: 0.65, blendDuration: 0)) {
            currentTab.value = Action.showCelestialBody(configuration.currentCelestialBody)
        }
        
    }
}
