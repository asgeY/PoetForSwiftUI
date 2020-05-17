//
//  HelloWorld-Translator.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/15/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

extension HelloWorld {

    class Translator {
        
        typealias Evaluator = HelloWorld.Evaluator
        typealias ButtonAction = Evaluator.ButtonAction
        
        // Observable Display State
        var title = ObservableString()
        var imageName = ObservableString()
        var foregroundColor = Observable<Color>(.clear)
        var backgroundColor = Observable<Color>(.clear)
        var tapAction = Observable<Evaluator.ButtonAction?>(nil)
        var shouldShowTapMe = ObservableBool()
        var tabs = ObservableArray<EvaluatorActionWithIconAndID>([])
        var currentTab = Observable<EvaluatorActionWithIconAndID?>(nil)
        
        // Passthrough Behavior
        private var behavior: Behavior?
        
        init(_ step: PassableStep<Evaluator.Step>) {
            behavior = step.subject.sink { value in
                self.translate(step: value)
            }
        }
    }
}

extension HelloWorld.Translator {
    func translate(step: Evaluator.Step) {
        switch step {
            
        case .loading:
            translateLoadingStep()
            
        case .celestialBody(let configuration):
            translateCelestialBodyStep(configuration)
        }
    }
    
    func translateLoadingStep() {
        // nothing to see here
    }
    
    func translateCelestialBodyStep(_ configuration: Evaluator.CelestialBodyStepConfiguration) {
        // Set observable display state
        title.string = "Hello \(configuration.currentCelestialBody.name)!"
        imageName.string = configuration.currentCelestialBody.images[configuration.currentImageIndex]
        foregroundColor.object = configuration.currentCelestialBody.foreground.color
        backgroundColor.object = configuration.currentCelestialBody.background.color
        tapAction.object = configuration.tapAction
        tabs.array = configuration.celestialBodies.map { ButtonAction.showCelestialBody($0) }
        withAnimation(.linear) {
            shouldShowTapMe.bool = configuration.tapAction != nil
        }
        withAnimation(.spring(response: 0.45, dampingFraction: 0.65, blendDuration: 0)) {
            currentTab.object = ButtonAction.showCelestialBody(configuration.currentCelestialBody)
        }
        
    }
}