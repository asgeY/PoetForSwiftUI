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
        
        // Strings
        var mainTitle = ObservableString()
        var chapterNumber = ObservableInt()
        var chapterTitle = ObservableString()
        var text = ObservableString()
        var pageXofX = ObservableString()
        var imageName = ObservableString()
        var buttonName = ObservableString()
        var selectableChapterTitles = ObservableArray<NamedEvaluatorAction>([])
        
        // Bools
        var shouldShowMainTitle = ObservableBool()
        var shouldShowChapterTitle = ObservableBool()
        var shouldShowChapterNumber = ObservableBool()
        var shouldFocusOnChapterTitle = ObservableBool()
        var shouldShowText = ObservableBool()
        var shouldShowImage = ObservableBool()
        var shouldShowTapMe = ObservableBool()
        var shouldShowButton = ObservableBool()
        var shouldShowLeftAndRightButtons = ObservableBool()
        var shouldEnableLeftButton = ObservableBool()
        var shouldEnableRightButton = ObservableBool()
        var shouldShowTableOfContentsButton = ObservableBool()
        var shouldShowTableOfContents = ObservableBool()
        
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

extension Simplest.Translator {
    func translate(step: Evaluator.Step) {
        switch step {
            
        case .loading:
            showLoading()
            
        case .mainTitle(let configuration):
            showMainTitleStep(configuration)
            
        case .chapterTitle(let configuration):
            showChapterTitleStep(configuration)

        case .page(let configuration):
            showTextStep(configuration)
            
        case .world(let configuration):
            showWorldStep(configuration)
            
        case .interlude:
            showInterlude()
            
        case .tableOfContents(let configuration):
            showTableOfContents(configuration)
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
        shouldShowText.bool = false
        shouldShowImage.bool = false
        shouldShowTapMe.bool = false
        shouldShowButton.bool = false
        shouldShowLeftAndRightButtons.bool = false
        shouldShowTableOfContentsButton.bool = false
        shouldShowTableOfContents.bool = false
    }
    
    func showChapterTitleStep(_ configuration: Evaluator.ChapterTitleStepConfiguration) {
        withAnimation(.linear(duration: 0.1)) {
            shouldShowChapterTitle.bool = true
        }
        
        shouldFocusOnChapterTitle.bool = true
        shouldShowChapterNumber.bool = true
        
        shouldShowMainTitle.bool = false
        shouldShowText.bool = false
        shouldShowImage.bool = false
        shouldShowTapMe.bool = false
        shouldShowButton.bool = false
        shouldShowLeftAndRightButtons.bool = false
        shouldShowTableOfContentsButton.bool = false
        shouldShowTableOfContents.bool = false
        
        chapterNumber.int = configuration.chapterNumber
        chapterTitle.string = configuration.title
    }
    
    func showTextStep(_ configuration: Evaluator.TextStepConfiguration) {
        let firstPage = configuration.chapterNumber == 1 && configuration.pageNumber == 1
    
        withAnimation(.linear(duration: 0.4)) {
            shouldFocusOnChapterTitle.bool = false
            shouldShowChapterTitle.bool = true
            shouldShowChapterNumber.bool = true
            shouldShowImage.bool = false
            shouldShowButton.bool = configuration.buttonAction != nil
            shouldShowTableOfContentsButton.bool = !firstPage
            shouldShowTableOfContents.bool = false
        }
        
        withAnimation(Animation.linear(duration: 0.4).delay(0.3)) {
            shouldShowText.bool = true
            shouldShowLeftAndRightButtons.bool = !firstPage
            shouldEnableLeftButton.bool = !firstPage
            shouldEnableRightButton.bool = true
        }
        
        // "Tap Me" Chapter 1 Page 1
        if firstPage {
            withAnimation(Animation.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0).delay(0.8)) {
                self.shouldShowTapMe.bool = true
            }
        } else {
            withAnimation(Animation.linear(duration: 0.5)) {
                self.shouldShowTapMe.bool = false
            }
        }
        
        chapterNumber.int = configuration.chapterNumber
        chapterTitle.string = configuration.title
        text.string = configuration.text
        pageXofX.string = "\(configuration.pageNumber) / \(configuration.pageCount)"
        buttonAction.object = configuration.buttonAction
        tableOfContentsAction.object = configuration.tableOfContentsAction
        
        if let actionName = configuration.buttonAction?.name {
            buttonName.string = actionName
        }
    }
    
    func showWorldStep(_ configuration: Evaluator.WorldStepConfiguration) {
        shouldFocusOnChapterTitle.bool = false
        shouldShowChapterTitle.bool = true
        shouldShowChapterNumber.bool = false
        shouldShowText.bool = false
        shouldShowButton.bool = true
        shouldShowLeftAndRightButtons.bool = false
        shouldShowTableOfContentsButton.bool = false
        shouldShowTableOfContents.bool = false
        
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
            shouldFocusOnChapterTitle.bool = false
            shouldShowMainTitle.bool = false
            shouldShowChapterTitle.bool = false
            shouldShowChapterNumber.bool = false
            shouldShowText.bool = false
            shouldShowImage.bool = false
            shouldShowTapMe.bool = false
            shouldShowButton.bool = false
            shouldShowLeftAndRightButtons.bool = false
            shouldShowTableOfContentsButton.bool = false
            shouldShowTableOfContents.bool = false
        }
    }
    
    func showTableOfContents(_ configuration: Evaluator.TableOfContentsConfiguration) {
        selectableChapterTitles.array = configuration.selectableChapterTitles
        tableOfContentsAction.object = configuration.returnAction
        withAnimation(Animation.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0)) {
            shouldShowTableOfContents.bool = true
        }
    }
}
