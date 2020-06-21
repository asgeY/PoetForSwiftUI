//
//  Tutorial-Evaluator.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/2/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation
import SwiftUI

extension Tutorial {
    class Evaluator {
        
        // Translator
        lazy var translator: Translator = Translator(current)
        
        // State
        var current = PassableState(State.initial)
        
        struct Chapter {
            let title: String
            let files: [String]
            let pages: [Page]
            
            init(_ title: String, files: [String] = [], pages: Page...) {
                self.title = title
                self.files = files
                self.pages = pages
            }
        }
        
        struct Page {
            
            let body: [Body]
            let action: Action?
            let file: String?
            let supplement: Supplement?
            
            init(_ body: [Body], action: Action? = nil, file: String? = nil, supplement: Supplement? = nil) {
                self.body = body
                self.action = action
                self.file = file
                self.supplement = supplement
            }
            
            enum Body {
                case text(String)
                case title(String)
                case code(String)
                case smallCode(String)
                case extraSmallCode(String)
                case codeScrolling(String)
                case bullet(String)
                case divider
                case button(Action)
                case demo(Action)
                case file(String)
                case space(CGFloat = 12)
                case aside(String)
                
                var id: String {
                    switch self {
                    case .text(let text):
                        return "text_\(text)"
                    case .title(let text):
                        return "title_\(text)"
                    case .code(let text):
                        return "code_\(text)"
                    case .smallCode(let text):
                        return "smallCode_\(text)"
                    case .extraSmallCode(let text):
                        return "extraSmallCode_\(text)"
                    case .codeScrolling(let text):
                        return "codeScrolling_\(text)"
                    case .bullet(let text):
                        return "bullet_\(text)"
                    case .divider:
                        return "divider"
                    case .button(let action):
                        return "button_\(action.name)"
                    case .demo(let action):
                        return "demo_\(action.name)"
                    case .file(let fileName):
                        return "file_\(fileName)"
                    case .space(let space):
                        return "space_\(String(Double(space)))"
                    case .aside(let text):
                        return "aside_\(text)"
                    }
                }
            }
            
            struct Supplement {
                let shortTitle: String
                let fullTitle: String
                let body: [Body]
            }
        }
        
        let pageStore = PageStore.shared
    }
}

// MARK: State

extension Tutorial.Evaluator {
    
    // MARK: States
    
    enum State: EvaluatorState {
        case initial
        case interlude(InterludeState)
        case mainTitle(MainTitleState)
        case chapterTitle(ChapterTitleState)
        case page(PageState)
    }
    
    struct InterludeState {
        var animated: Bool
    }
    
    struct MainTitleState {
        var title: String
    }
    
    struct ChapterTitleState {
        var chapterTitle: String
        var chapterIndex: Int
        var chapterNumber: Int { return chapterIndex + 1 }
    }
    
    struct PageState {
        var chapterIndex: Int
        var pageIndex: Int
        var pageData: [Chapter]
        
        // Computed
        var chapterTitle: String { return pageData[chapterIndex].title }
        var body: [Page.Body] { return pageData[chapterIndex].pages[pageIndex].body }
        var chapterNumber: Int { return chapterIndex + 1 }
        var pageNumber: Int { return pageIndex + 1 }
        var pageCountWithinChapter: Int { return pageData[chapterIndex].pages.count }
        var chapterCount: Int { return pageData.count }
        var buttonAction: Action? { return pageData[chapterIndex].pages[pageIndex].action }
        var selectableChapterTitles: [NumberedNamedEvaluatorAction<Action>] { return selectableChapterTitles(for: pageData)}
        
        var nextChapterTitle: String? {
            if chapterIndex < chapterCount - 1 {
                return pageData[chapterIndex + 1].title
            }
            return nil
        }
        
        // Files
        var chapterTextFiles: [TextFile] {
            return pageData[chapterIndex].files.compactMap { fileName in
                return TextFile.fromFileName(fileName)
            }
        }
        
        var fileOfInterest: TextFile? {
            return TextFile.fromFileName(pageData[chapterIndex].pages[pageIndex].file)
        }
        
        // Helper methods
        func selectableChapterTitles(for pageData: [Chapter]) -> [NumberedNamedEvaluatorAction<Action>] {
            var selectableChapterTitles = [NumberedNamedEvaluatorAction<Action>]()
            
            for (i, chapter) in pageData.enumerated() {
                let selectableChapterTitle = NumberedNamedEvaluatorAction(
                    number: i + 1,
                    name: chapter.title,
                    action: Action.showChapter(chapterIndex: i, pageData: pageData)
                )
                selectableChapterTitles.append(selectableChapterTitle)
            }
            
            return selectableChapterTitles
        }
    }
}

// MARK: View Cycle

extension Tutorial.Evaluator: ViewCycleEvaluating {
    
    func viewDidAppear() {
        
        guard case .initial = current.state else { return }
        
        // Get our pages
        let pageData = pageStore.pageData
        
        // Opening animation
        showInterludeState(animated: false)
        afterWait(500) {
            self.showMainTitleState("Poet")
            afterWait(1000) {
                self.showInterludeState(animated: true)
                afterWait(1000) {
                    self.showChapterTitleState(
                        forChapterIndex: 0,
                        pageData: pageData)
                    afterWait(1000) {
                        self.showPageState(
                            forChapterIndex: 0,
                            pageIndex: 0,
                            pageData: pageData)
                    }
                }
            }
        }
    }
}

// MARK: Actions

extension Tutorial.Evaluator: ActionEvaluating {
    
    // Actions
    enum Action: EvaluatorAction {
        case pageForward
        case pageBackward
        case nextChapter
        case showChapter(chapterIndex: Int, pageData: [Chapter])
        case showChapterFiles
        case showFileOfInterest
        case showFile(String)
        case showSomething
        case showAlert
        case showAnotherAlert
        case showPassableAlert
        case showBezel
        case showTemplate
        case showHelloWorld
        case showHelloSolarSystem
        case showHelloData
        case showRetailDemo
        case showLoginDemo
        case showViewDemoList
        
        var name: String {
            switch self {
            case .showSomething:
                return "Show Something"
            case .showAlert:
                return "Show Alert"
            case .showAnotherAlert:
                return "Show Another Alert"
            case .showPassableAlert:
                return "Show Passable Alert"
            case .showBezel:
                return "Show Bezel"
            case .showTemplate:
                return "Template"
            case .showHelloWorld:
                return "Hello World"
            case .showHelloSolarSystem:
                return "Hello Solar System"
            case .showHelloData:
                return "Hello Data"
            case .showRetailDemo:
                return "Retail Demo"
            case .showLoginDemo:
                return "Login Demo"
            case .showViewDemoList:
                return "View Demo List"
            default:
                return ""
            }
        }
        
        var breadcrumbDescription: String {
            switch self {
            case .showChapter(let chapterIndex, _):
                return "showChapter: \(chapterIndex)"
            default:
                return String(describing: self)
            }
        }
    }
    
    func _evaluate(_ action: Action) {
        switch action {
            
        case .pageForward:
            pageForward()
            
        case .pageBackward:
            pageBackward()
            
        case .nextChapter:
            proceedToNextChapter()
            
        case .showChapter(let chapterIndex, let pageData):
            showChapter(chapterIndex: chapterIndex, pageData: pageData)
            
        case .showChapterFiles:
            showChapterFiles()
            
        case .showFileOfInterest:
            showFileOfInterest()
            
        case .showFile(let text):
            showFile(text)
            
        case .showSomething:
            translator.showSomething.please()
            
        case .showTemplate:
            translator.showTemplate.please()
            
        case .showHelloWorld:
            translator.showHelloWorld.please()
            
        case .showHelloSolarSystem:
            translator.showHelloSolarSystem.please()
            
        case .showHelloData:
            translator.showHelloData.please()
            
        case .showRetailDemo:
            translator.showRetailDemo.please()
            
        case .showLoginDemo:
            translator.showLoginDemo.please()
            
        case .showAlert:
            translator.showAlert(title: "Alert!", message: "You did it.")
            
        case .showAnotherAlert:
            translator.showAlert(
                title: "Something went wrong!",
                message: "Just kidding, it's fine.",
                primaryAlertAction: AlertAction(
                    title: "Cancel",
                    style: .cancel,
                    action: nil),
                secondaryAlertAction: AlertAction(
                    title: "Delete",
                    style: .destructive,
                    action: {
                        self.translator.showAlert(title: "What?", message: "There's nothing to delete.")
                }))
            
        case .showPassableAlert:
            translator.showAlert.withConfiguration(title: "Alert!", message: "You did it again.")
            
        case .showBezel:
            let emojis = ["🐥", "🦈", "🐄", "🐟", "🐙", "🦕", "🦉", "🐯", "🐢", "🐘", "🦔", "🐆", "🐛", "🐌", "🐞", "🐴", "👨🏻‍💻"]
            translator.showBezel(text: emojis.randomElement() ?? "", textSize: .big)
            
        case .showViewDemoList:
            translator.showViewDemoList.please()
        }
    }
}

// MARK: States

extension Tutorial.Evaluator {
    
    func showInterludeState(animated: Bool) {
        let state = InterludeState(
            animated: animated
        )
        current.state = .interlude(state)
    }
    
    // MARK: Main Title
    
    func showMainTitleState(_ text: String) {
        let state = MainTitleState(
            title: text
        )
        current.state = .mainTitle(state)
    }
    
    // MARK: Chapter Title
    
    func showChapterTitleState(forChapterIndex chapterIndex: Int, pageData: [Chapter]) {
        let state = ChapterTitleState(
            chapterTitle: pageData[chapterIndex].title,
            chapterIndex: chapterIndex)
        current.state = .chapterTitle(state)
    }
    
    // MARK: Page
    
    func showPageState(forChapterIndex chapterIndex: Int, pageIndex: Int, pageData: [Chapter]) {
        let state = PageState(
            chapterIndex: chapterIndex,
            pageIndex: pageIndex,
            pageData: pageData
        )
        current.state = .page(state)
    }
    
    func showChapter(chapterIndex: Int, pageData: [Chapter]) {
        showInterludeState(animated: false)
        afterWait(500) {
            self.showChapterTitleState(
                forChapterIndex: chapterIndex,
                pageData: pageData)
            afterWait(1000) {
                self.showPageState(
                    forChapterIndex: chapterIndex,
                    pageIndex: 0,
                    pageData: pageData)
            }
        }
    }
    
    func proceedToNextChapter() {
        guard case let .page(currentState) = current.state else { return }
        
        if currentState.chapterIndex < currentState.chapterCount - 1 {
            showChapter(chapterIndex: currentState.chapterIndex + 1, pageData: currentState.pageData)
        }
    }
    
    func pageForward() {
        // Must be in Page state
        guard case let .page(currentState) = current.state else { return }
        
        var isNewChapter = false
        
        let (nextChapter, nextPage): (Int, Int) = {
            if currentState.pageIndex < currentState.pageCountWithinChapter - 1 {
                return (currentState.chapterIndex, currentState.pageIndex + 1)
            } else {
                isNewChapter = true
                if currentState.chapterIndex < currentState.chapterCount - 1 {
                    return (currentState.chapterIndex + 1, 0)
                } else {
                    return (0, 0)
                }
            }
        }()
        
        if isNewChapter {
            showInterludeState(animated: true)
            afterWait(500) {
                self.showChapterTitleState(
                    forChapterIndex: nextChapter,
                    pageData: currentState.pageData)
                afterWait(1000) {
                    self.showPageState(
                        forChapterIndex: nextChapter,
                        pageIndex: nextPage,
                        pageData: currentState.pageData)
                }
            }
        } else {
            showPageState(
                forChapterIndex: nextChapter,
                pageIndex: nextPage,
                pageData: currentState.pageData)
        }
    }
    
    func pageBackward() {
        // Must be in Page state
        guard case let .page(currentState) = current.state else { return }
        
        let (chapter, page): (Int, Int) = {
            if currentState.pageIndex > 0 {
                return (currentState.chapterIndex, currentState.pageIndex - 1)
            } else {
                if currentState.chapterIndex > 0 {
                    let newChapter = currentState.chapterIndex - 1
                    let newPage = currentState.pageData[newChapter].pages.count - 1
                    return (newChapter, newPage)
                } else {
                    return (0, 0)
                }
            }
        }()
        
        showPageState(forChapterIndex: chapter, pageIndex: page, pageData: currentState.pageData)
    }
    
    func showChapterFiles() {
        guard case let .page(currentState) = current.state else { return }
        
        translator.showChapterFileMenu.withValue(currentState.chapterTextFiles)
    }
    
    func showFileOfInterest() {
        guard case let .page(currentState) = current.state else { return }
        
        if let fileOfInterest = currentState.fileOfInterest {
            translator.showFile.withString(fileOfInterest.body)
        }
    }
    
    func showFile(_ text: String) {
        translator.showFile.withString(text)
    }
}
