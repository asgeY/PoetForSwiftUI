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
        typealias Action = Tutorial.Evaluator.Action
        
        // Observable Display State
        
        // Strings
        var mainTitle = ObservableString()
        var chapterNumber = ObservableInt()
        var chapterTitle = ObservableString()
        var nextChapterTitle = ObservableString()
        
        // Arrays
        var body = ObservableArray<Evaluator.Page.Body>([])
        var selectableChapterTitles = ObservableArray<NumberedNamedEvaluatorAction<Action>>([])
        
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
        var stateSink: AnyCancellable?
        
        init(_ state: PassableState<Evaluator.State>) {
            stateSink = state.subject.sink { [weak self] value in
                self?.translate(state: value)
            }
        }
    }
}

extension Tutorial.Translator {
    func translate(state: Evaluator.State) {
        switch state {
            
        case .initial:
            break // no initial setup needed
            
        case .mainTitle(let state):
            translateMainTitleState(state)
            
        case .chapterTitle(let state):
            translateChapterTitleState(state)

        case .page(let state):
            translatePageState(state)
            
        case .interlude(let state):
            translateInterlude(state)
        }
    }
    
    func translateMainTitleState(_ state: Evaluator.MainTitleState) {
        shouldShowMainTitle.bool = true
        mainTitle.string = state.title
        
        shouldFocusOnChapterTitle.bool = false
        shouldShowChapterTitle.bool = false
        shouldShowChapterNumber.bool = false
        shouldShowBody.bool = false
        shouldShowTableOfContents.bool = false
        shouldShowFilesButton.bool = false
    }
    
    func translateChapterTitleState(_ state: Evaluator.ChapterTitleState) {
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
        
        chapterNumber.int = state.chapterNumber
        chapterTitle.string = state.chapterTitle
    }
    
    func translatePageState(_ state: Evaluator.PageState) {
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
            shouldShowFilesButton.bool = state.chapterTextFiles.notEmpty
            shouldShowNextChapterButton.bool = state.nextChapterTitle?.isEmpty == false
        }
        
        // Other values
        chapterNumber.int = state.chapterNumber
        chapterTitle.string = state.chapterTitle
        nextChapterTitle.string = state.nextChapterTitle ?? ""
        body.array = state.body
        selectableChapterTitles.array = state.selectableChapterTitles
    }
    
    func translateInterlude(_ state: Evaluator.InterludeState) {
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
        
        if state.animated {
            withAnimation(.linear(duration: 0.2)) {
                work()
            }
        } else {
            work()
        }
    }
}
