//
//  Simplest-Translator.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/2/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation
import SwiftUI

extension Simplest {

    class Translator {
        
        typealias Evaluator = Simplest.Evaluator
        
        // Observable Display State
        var chapterNumber = ObservableInt()
        var title = ObservableString()
        var text = ObservableString()
        var pageXofX = ObservableString()
        var imageName = ObservableString()
        var shouldShowAnything = ObservableBool()
        var shouldFocusOnTitle = ObservableBool()
        var shouldShowTitle = ObservableBool()
        var shouldShowChapterNumber = ObservableBool()
        var shouldShowText = ObservableBool()
        var shouldShowImage = ObservableBool()
        var shouldShowTapMe = ObservableBool()
        var shouldShowButton = ObservableBool()
        var buttonAction = Observable<EvaluatorAction?>(nil)
        var buttonName = ObservableString()
        
        // Passthrough Behavior
        var behavior: Behavior?
        
        init(_ step: PassableStep<Evaluator.Step>) {
            behavior = step.subject.sink { value in
                self.translate(step: value)
            }
        }
    }
}

extension Simplest.Translator {
    func translate(step: Evaluator.Step) {
        switch step {
            
        case .loading:
            showLoading()
            
        case .page(let configuration):
            showTextStep(configuration)
            
        case .title(let configuration):
            showTitleStep(configuration)
            
        case .world(let configuration):
            showWorldStep(configuration)
            
        case .interlude:
            showInterlude()
        }
    }
    
    func showLoading() {
        shouldShowAnything.bool = false
    }
    
    func showTextStep(_ configuration: Evaluator.TextStepConfiguration) {
        withAnimation(.linear(duration: 0.4)) {
            shouldShowAnything.bool = true
            shouldFocusOnTitle.bool = false
            shouldShowTitle.bool = true
            shouldShowChapterNumber.bool = true
            shouldShowText.bool = true
            shouldShowImage.bool = false
        }
        
        // Async so it doesn't compete with other animations
        DispatchQueue.main.async {
            withAnimation(Animation.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0).delay(0.3)) {
                self.shouldShowTapMe.bool = configuration.chapterIndex == 0 && configuration.pageNumber == 1
            }
        }
        shouldShowButton.bool = configuration.action != nil
        
        chapterNumber.int = configuration.chapterNumber
        title.string = configuration.title
        text.string = configuration.text
        pageXofX.string = "\(configuration.pageNumber) / \(configuration.pageCount)"
        buttonAction.object = configuration.action
        buttonName.string = configuration.action?.name ?? ""
    }
    
    func showTitleStep(_ configuration: Evaluator.TitleStepConfiguration) {
        shouldShowAnything.bool = true
        shouldFocusOnTitle.bool = true
        shouldShowTitle.bool = true
        shouldShowChapterNumber.bool = true
        shouldShowText.bool = false
        shouldShowImage.bool = false
        shouldShowTapMe.bool = false
        shouldShowButton.bool = false
        
        chapterNumber.int = configuration.chapterNumber
        title.string = configuration.title
    }
    
    func showWorldStep(_ configuration: Evaluator.WorldStepConfiguration) {
        shouldShowAnything.bool = true
        shouldFocusOnTitle.bool = false
        shouldShowTitle.bool = true
        shouldShowChapterNumber.bool = false
        shouldShowText.bool = false
        shouldShowButton.bool = true
        
        DispatchQueue.main.async {
            withAnimation(.linear(duration: 0.4)) {
                self.shouldShowImage.bool = true
            }
        }
        
        // Async so it doesn't compete with other animations
        DispatchQueue.main.async {
            withAnimation(Animation.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0).delay(0.3)) {
                self.shouldShowTapMe.bool = true
            }
        }
        
        imageName.string = configuration.image
        title.string = configuration.title
        buttonAction.object = configuration.action
        buttonName.string = configuration.action.name
    }
    
    func showInterlude() {
        withAnimation(.linear(duration: 0.2)) {
            shouldShowAnything.bool = false
        }
    }
}
