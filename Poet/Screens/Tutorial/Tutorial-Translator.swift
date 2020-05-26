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

    class Translator: AlertTranslating, BezelTranslating {
        
        typealias Evaluator = Tutorial.Evaluator
        
        // Observable Display State
        
        // Strings
        var mainTitle = ObservableString()
        var chapterNumber = ObservableInt()
        var chapterTitle = ObservableString()
        var pageXofX = ObservableString()
        var imageName = ObservableString()
        var buttonName = ObservableString()
        var fileOfInterestName = ObservableString()
        
        // Arrays
        var body = ObservableArray<Evaluator.Page.Body>([])
        var selectableChapterTitles = ObservableArray<NumberedNamedEvaluatorAction>([])
        
        // Bools
        var shouldShowMainTitle = ObservableBool()
        var shouldShowChapterTitle = ObservableBool()
        var shouldShowChapterNumber = ObservableBool()
        var shouldFocusOnChapterTitle = ObservableBool()
        var shouldShowBody = ObservableBool()
        var shouldShowImage = ObservableBool()
        var shouldShowTapMe = ObservableBool()
        var shouldShowPageCount = ObservableBool()
        var shouldShowButton = ObservableBool()
        var shouldShowLeftAndRightButtons = ObservableBool()
        var shouldEnableLeftButton = ObservableBool()
        var shouldEnableRightButton = ObservableBool()
        var shouldShowTableOfContentsButton = ObservableBool()
        var shouldShowTableOfContents = ObservableBool()
        var shouldShowAboutButton = ObservableBool()
        var shouldShowFilesButton = ObservableBool()
        var shouldShowFileOfInterestButton = ObservableBool()
        
        // Passable
        var showChapterFileMenu = Passable<[TextFile]>()
        var showFile = PassableString()
        var showSupplement = PassablePlease()
        var showSomething = PassablePlease()
        var showTemplate = PassablePlease()
        var showHelloWorld = PassablePlease()
        var showHelloSolarSystem = PassablePlease()
        var showRetailDemo = PassablePlease()
        
        // Actions
        var buttonAction = Observable<EvaluatorAction?>(nil)
        var tableOfContentsAction = Observable<EvaluatorAction?>(nil)
        
        // Protocol-Oriented Translating
        var alertTranslator = AlertTranslator()
        var bezelTranslator = BezelTranslator()
        
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
            
        case .initial:
            break // no initial setup needed
            
        case .mainTitle(let configuration):
            translateMainTitleStep(configuration)
            
        case .chapterTitle(let configuration):
            translateChapterTitleStep(configuration)

        case .page(let configuration):
            translatePageStep(configuration)
            
        case .interlude:
            translateInterlude()
        }
    }
    
    func translateMainTitleStep(_ configuration: Evaluator.MainTitleStepConfiguration) {
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
        shouldShowFilesButton.bool = false
        shouldShowFileOfInterestButton.bool = false
        shouldShowPageCount.bool = false
    }
    
    func translateChapterTitleStep(_ configuration: Evaluator.ChapterTitleStepConfiguration) {
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
        shouldShowFilesButton.bool = false
        shouldShowFileOfInterestButton.bool = false
        shouldShowPageCount.bool = false
        
        chapterNumber.int = configuration.chapterNumber
        chapterTitle.string = configuration.title
    }
    
    func translatePageStep(_ configuration: Evaluator.PageStepConfiguration) {
        let firstPage = configuration.chapterNumber == 1 && configuration.pageNumber == 1
    
        // linear animation
        withAnimation(.linear(duration: 0.4)) {
            shouldShowChapterNumber.bool = true
            shouldShowChapterTitle.bool = true
            shouldFocusOnChapterTitle.bool = false
            shouldShowImage.bool = false
            shouldShowTableOfContents.bool = false
            shouldShowTableOfContentsButton.bool = true
            shouldShowAboutButton.bool = !firstPage
            shouldShowPageCount.bool = !firstPage
        }
        
        // spring animation
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0)) {
            shouldShowButton.bool = configuration.buttonAction != nil
        }
        
        // delayed animation
        withAnimation(Animation.linear(duration: 0.4).delay(0.35)) {
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
        
        // Files
        if let fileOfInterest = configuration.fileOfInterest {
            fileOfInterestName.string = fileOfInterest.title + ".swift"
        }

        withAnimation(.linear(duration: 0.2)) {
            self.shouldShowFilesButton.bool = configuration.chapterTextFiles.notEmpty
            self.shouldShowFileOfInterestButton.bool = configuration.fileOfInterest != nil
        }
        
        // Other values
        chapterNumber.int = configuration.chapterNumber
        chapterTitle.string = configuration.title
        body.array = configuration.body
        pageXofX.string = "\(configuration.pageNumber) / \(configuration.pageCountWithinChapter)"
        buttonAction.value = configuration.buttonAction
        selectableChapterTitles.array = configuration.selectableChapterTitles
        
        if let actionName = configuration.buttonAction?.name {
            buttonName.string = actionName
        }
    }
    
    func translateInterlude() {
        withAnimation(.linear(duration: 0.2)) {
            
            // hide everything
            shouldFocusOnChapterTitle.bool = false
            shouldShowMainTitle.bool = false
            shouldShowChapterNumber.bool = false
            shouldShowChapterTitle.bool = false
            shouldShowBody.bool = false
            shouldShowImage.bool = false
            shouldShowTapMe.bool = false
            shouldShowButton.bool = false
            shouldShowLeftAndRightButtons.bool = false
            shouldShowTableOfContentsButton.bool = false
            shouldShowTableOfContents.bool = false
            shouldShowAboutButton.bool = false
            shouldShowFilesButton.bool = false
            shouldShowFileOfInterestButton.bool = false
            shouldShowPageCount.bool = false
        }
    }
}
