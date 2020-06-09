//
//  Tutorial-Translator.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/2/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine
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
        var nextChapterTitle = ObservableString()
        
        // Arrays
        var body = ObservableArray<Evaluator.Page.Body>([])
        var selectableChapterTitles = ObservableArray<NumberedNamedEvaluatorAction>([])
        
        // "Should Show" Bools
        var shouldShowMainTitle = ObservableBool()
        var shouldShowChapterTitle = ObservableBool()
        var shouldShowChapterNumber = ObservableBool()
        var shouldFocusOnChapterTitle = ObservableBool()
        var shouldShowNextChapterButton = ObservableBool()
        var shouldShowBody = ObservableBool()
        var shouldShowTableOfContents = ObservableBool()
        var shouldShowFilesButton = ObservableBool()
        
        // "Show ..." Passables
        var showChapterFileMenu = Passable<[TextFile]>()
        var showFile = PassableString()
        var showSupplement = PassablePlease()
        var showSomething = PassablePlease()
        var showTemplate = PassablePlease()
        var showHelloWorld = PassablePlease()
        var showHelloSolarSystem = PassablePlease()
        var showHelloData = PassablePlease()
        var showRetailDemo = PassablePlease()
        var showLoginDemo = PassablePlease()
        var showViewDemoList = PassablePlease()
        var showAlert = PassableAlert()
        
        // Actions
        var tableOfContentsAction = Observable<EvaluatorAction?>()
        
        // Protocol-Oriented Translating
        var alertTranslator = AlertTranslator()
        var bezelTranslator = BezelTranslator()
        
        // Passthrough Behavior
        var stepSink: AnyCancellable?
        
        init(_ step: PassableStep<Evaluator.Step>) {
            stepSink = step.subject.sink { [weak self] value in
                self?.translate(step: value)
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
            
        case .interlude(let configuration):
            translateInterlude(configuration)
        }
    }
    
    func translateMainTitleStep(_ configuration: Evaluator.MainTitleStepConfiguration) {
        shouldShowMainTitle.bool = true
        mainTitle.string = configuration.title
        
        shouldFocusOnChapterTitle.bool = false
        shouldShowChapterTitle.bool = false
        shouldShowChapterNumber.bool = false
        shouldShowBody.bool = false
        shouldShowTableOfContents.bool = false
        shouldShowFilesButton.bool = false
    }
    
    func translateChapterTitleStep(_ configuration: Evaluator.ChapterTitleStepConfiguration) {
        body.array = []
        
        withAnimation(.linear(duration: 0.1)) {
            shouldShowChapterTitle.bool = true
        }
        
        shouldFocusOnChapterTitle.bool = true
        shouldShowChapterNumber.bool = true
        shouldShowMainTitle.bool = false
        shouldShowBody.bool = false
        shouldShowTableOfContents.bool = false
        shouldShowFilesButton.bool = false
        
        chapterNumber.int = configuration.chapterNumber
        chapterTitle.string = configuration.chapterTitle        
    }
    
    func translatePageStep(_ configuration: Evaluator.PageStepConfiguration) {
        // linear animation
        withAnimation(.linear(duration: 0.4)) {
            shouldShowChapterNumber.bool = true
            shouldShowChapterTitle.bool = true
            shouldFocusOnChapterTitle.bool = false
            shouldShowTableOfContents.bool = false
        }
        
        // delayed animation
        withAnimation(Animation.linear(duration: 0.45).delay(0.4)) {
            shouldShowBody.bool = true
            shouldShowFilesButton.bool = configuration.chapterTextFiles.notEmpty
            shouldShowNextChapterButton.bool = configuration.nextChapterTitle?.isEmpty == false
        }
        
        // Other values
        chapterNumber.int = configuration.chapterNumber
        chapterTitle.string = configuration.chapterTitle
        nextChapterTitle.string = configuration.nextChapterTitle ?? ""
        body.array = configuration.body
        selectableChapterTitles.array = configuration.selectableChapterTitles
    }
    
    func translateInterlude(_ configuration: Evaluator.InterludeStepConfiguration) {
        let work = {
            // hide everything
            self.shouldFocusOnChapterTitle.bool = false
            self.shouldShowMainTitle.bool = false
            self.shouldShowChapterNumber.bool = false
            self.shouldShowChapterTitle.bool = false
            self.shouldShowBody.bool = false
            self.shouldShowTableOfContents.bool = false
            self.shouldShowFilesButton.bool = false
        }
        
        if configuration.animated {
            withAnimation(.linear(duration: 0.2)) {
                work()
            }
        } else {
            work()
        }
    }
}
