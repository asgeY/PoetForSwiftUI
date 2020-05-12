//
//  Tutorial-Translator.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/2/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation
import SwiftUI

extension Tutorial {

    class Translator {
        
        typealias Evaluator = Tutorial.Evaluator
        
        // Observable Display State
        
        // Strings
        var mainTitle = ObservableString()
        var chapterNumber = ObservableInt()
        var chapterTitle = ObservableString()
        var pageXofX = ObservableString()
        var imageName = ObservableString()
        var buttonName = ObservableString()
        
        // Arrays
        var body = ObservableArray<Evaluator.Page.Body>([])
        var extraBody = ObservableArray<Evaluator.Page.Body>([])
        var selectableChapterTitles = ObservableArray<NumberedNamedEvaluatorAction>([])
        
        // Bools
        var shouldShowMainTitle = ObservableBool()
        var shouldShowChapterTitle = ObservableBool()
        var shouldShowChapterNumber = ObservableBool()
        var shouldFocusOnChapterTitle = ObservableBool()
        var shouldShowBody = ObservableBool()
        var shouldShowImage = ObservableBool()
        var shouldShowTapMe = ObservableBool()
        var shouldShowButton = ObservableBool()
        var shouldShowLeftAndRightButtons = ObservableBool()
        var shouldEnableLeftButton = ObservableBool()
        var shouldEnableRightButton = ObservableBool()
        var shouldShowTableOfContentsButton = ObservableBool()
        var shouldShowTableOfContents = ObservableBool()
        var shouldShowAboutButton = ObservableBool()
        var shouldShowExtraButton = ObservableBool()
        
        // Actions
        var buttonAction = Observable<EvaluatorAction?>(nil)
        var tableOfContentsAction = Observable<EvaluatorAction?>(nil)
        
        // Passthrough Behavior
        var behavior: Behavior?
        
        init(_ step: PassableStep<Evaluator.Step>) {
            behavior = step.subject.sink { value in
                self.translate(step: value)
            }
        }
    }
}

extension Tutorial.Translator {
    func translate(step: Evaluator.Step) {
        switch step {
            
        case .loading:
            showLoading()
            
        case .mainTitle(let configuration):
            showMainTitleStep(configuration)
            
        case .chapterTitle(let configuration):
            showChapterTitleStep(configuration)

        case .page(let configuration):
            showPageStep(configuration)
            
        case .world(let configuration):
            showWorldStep(configuration)
            
        case .interlude:
            showInterlude()
        }
    }
    
    func showLoading() {
        // do nothing
    }
    
    func showMainTitleStep(_ configuration: Evaluator.MainTitleStepConfiguration) {
        shouldShowMainTitle.bool = true
        mainTitle.string = configuration.title
        
        shouldFocusOnChapterTitle.bool = false
        shouldShowChapterTitle.bool = false
        shouldShowChapterNumber.bool = false
        shouldShowBody.bool = false
        shouldShowImage.bool = false
        shouldShowTapMe.bool = false
        shouldShowButton.bool = false
        shouldShowLeftAndRightButtons.bool = false
        shouldShowTableOfContentsButton.bool = false
        shouldShowTableOfContents.bool = false
        shouldShowAboutButton.bool = false
        shouldShowExtraButton.bool = false
    }
    
    func showChapterTitleStep(_ configuration: Evaluator.ChapterTitleStepConfiguration) {
        withAnimation(.linear(duration: 0.1)) {
            shouldShowChapterTitle.bool = true
        }
        
        shouldFocusOnChapterTitle.bool = true
        shouldShowChapterNumber.bool = true
        
        shouldShowMainTitle.bool = false
        shouldShowBody.bool = false
        shouldShowImage.bool = false
        shouldShowTapMe.bool = false
        shouldShowButton.bool = false
        shouldShowLeftAndRightButtons.bool = false
        shouldShowTableOfContentsButton.bool = false
        shouldShowTableOfContents.bool = false
        shouldShowAboutButton.bool = false
        shouldShowExtraButton.bool = false
        
        chapterNumber.int = configuration.chapterNumber
        chapterTitle.string = configuration.title
    }
    
    func showPageStep(_ configuration: Evaluator.PageStepConfiguration) {
        let firstPage = configuration.chapterNumber == 1 && configuration.pageNumber == 1
    
        // linear animation
        withAnimation(.linear(duration: 0.4)) {
            shouldShowChapterNumber.bool = true
            shouldShowChapterTitle.bool = true
            shouldFocusOnChapterTitle.bool = false
            shouldShowImage.bool = false
            shouldShowTableOfContents.bool = false
            shouldShowTableOfContentsButton.bool = !firstPage
            shouldShowAboutButton.bool = !firstPage
        }
        
        // spring animation
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0)) {
            shouldShowButton.bool = configuration.buttonAction != nil
        }
        
        // delayed animation
        withAnimation(Animation.linear(duration: 0.4).delay(0.3)) {
            shouldShowBody.bool = true
            shouldEnableRightButton.bool = true
            shouldShowLeftAndRightButtons.bool = !firstPage
            shouldEnableLeftButton.bool = !firstPage
        }
        
        // "Tap Me" Chapter 1 Page 1
        if firstPage {
            withAnimation(Animation.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0).delay(0.8)) {
                self.shouldShowTapMe.bool = true
            }
        } else {
            withAnimation(Animation.linear(duration: 0.3)) {
                self.shouldShowTapMe.bool = false
            }
        }
        
        // Extra Reading button
        if configuration.extra != nil {
            withAnimation(Animation.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0)) {
                shouldShowExtraButton.bool = true
            }
        } else {
            withAnimation(Animation.linear(duration: 0.2)) {
                shouldShowExtraButton.bool = false
            }
        }
        
        // values
        chapterNumber.int = configuration.chapterNumber
        chapterTitle.string = configuration.title
        body.array = configuration.body
        extraBody.array = configuration.extra ?? []
        pageXofX.string = "\(configuration.pageNumber) / \(configuration.pageCountWithinChapter)"
        buttonAction.object = configuration.buttonAction
        selectableChapterTitles.array = configuration.selectableChapterTitles
        
        if let actionName = configuration.buttonAction?.name {
            buttonName.string = actionName
        }
    }
    
    func showWorldStep(_ configuration: Evaluator.WorldStepConfiguration) {
        
        // show
        shouldShowChapterTitle.bool = true
        shouldShowButton.bool = true
        
        // hide
        shouldFocusOnChapterTitle.bool = false
        shouldShowChapterNumber.bool = false
        shouldShowBody.bool = false
        shouldShowLeftAndRightButtons.bool = false
        shouldShowTableOfContentsButton.bool = false
        shouldShowTableOfContents.bool = false
        shouldShowAboutButton.bool = false
        shouldShowExtraButton.bool = false
        
        imageName.string = configuration.image
        chapterTitle.string = configuration.title
        buttonAction.object = configuration.buttonAction
        buttonName.string = configuration.buttonAction.name
        
        withAnimation(.linear(duration: 0.4)) {
            self.shouldShowImage.bool = true
        }
        
        // Delayed 0.5
        withAnimation(Animation.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0).delay(0.5)) {
            self.shouldShowTapMe.bool = true
        }
    }
    
    func showInterlude() {
        withAnimation(.linear(duration: 0.2)) {
            
            // hide
            shouldFocusOnChapterTitle.bool = false
            shouldShowMainTitle.bool = false
            shouldShowChapterTitle.bool = false
            shouldShowChapterNumber.bool = false
            shouldShowBody.bool = false
            shouldShowImage.bool = false
            shouldShowTapMe.bool = false
            shouldShowButton.bool = false
            shouldShowLeftAndRightButtons.bool = false
            shouldShowTableOfContentsButton.bool = false
            shouldShowTableOfContents.bool = false
            shouldShowAboutButton.bool = false
            shouldShowExtraButton.bool = false
        }
    }
}
