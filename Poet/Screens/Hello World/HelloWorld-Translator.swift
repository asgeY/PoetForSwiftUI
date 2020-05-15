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
        
        // Observable Display State
        var title = ObservableString()
        var imageName = ObservableString()
        var foregroundColor = Observable<Color>(.clear)
        var backgroundColor = Observable<Color>(.clear)
        var tapAction = Observable<Evaluator.ButtonAction?>(nil)
        var shouldShowTapMe = ObservableBool()
        
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
            
        case .imageTapping(let configuration):
            translateImageTappingStep(configuration)
        }
    }
    
    func translateLoadingStep() {
        // nothing to see here
    }
    
    func translateImageTappingStep(_ configuration: Evaluator.ImageTappingStepConfiguration) {
        // Set observable display state
        title.string = configuration.title
        imageName.string = configuration.currentImage
        foregroundColor.object = configuration.foreground
        backgroundColor.object = configuration.background
        tapAction.object = configuration.tapAction
        shouldShowTapMe.bool = configuration.tapAction != nil
    }
}
