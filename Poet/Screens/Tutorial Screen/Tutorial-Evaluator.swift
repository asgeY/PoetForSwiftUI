//
//  Tutorial-Evaluator.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/2/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

extension Tutorial {
    class Evaluator {
        
        // Translator
        lazy var translator: Translator = Translator(current)
        
        // Step       
        var current = PassableStep(Step.loading)
        
        // Button Actions
        enum ButtonAction: EvaluatorAction {
            case pageForward
            case pageBackward
            case helloWorld
            case advanceWorldImage
            case returnToTutorial(chapterIndex: Int, pageIndex: Int, pageData: [Chapter])
            case showChapter(chapterIndex: Int, pageData: [Chapter])
            
            var name: String {
                switch self {
                case .helloWorld:
                    return "Hello World"
                case .returnToTutorial:
                    return "Return to Tutorial"
                default:
                    return ""
                }
            }
        }
        
        struct Chapter {
            let title: String
            let pages: [Page]
            
            init(_ title: String, pages: Page...) {
                self.title = title
                self.pages = pages
            }
        }
        
        struct Page {
            
            let body: [Body]
            let action: ButtonAction?
            let supplement: [Body]?
            
            init(_ body: [Body], action: ButtonAction? = nil, supplement: [Body]? = nil) {
                self.body = body
                self.action = action
                self.supplement = supplement
            }
            
            enum Body {
                case text(String)
                case code(String)
                case smallCode(String)
                case extraSmallCode(String)
                
                var id: String {
                    switch self {
                    case .text(let text):
                        return "text_\(text)"
                    case .code(let text):
                        return "code_\(text)"
                    case .smallCode(let text):
                        return "smallCode_\(text)"
                    case .extraSmallCode(let text):
                        return "extraSmallCode_\(text)"
                    }
                }
            }
        }
        
        // Data
        var worldImages = [
            "world01",
            "world02",
            "world03",
            "world04",
            "world05",
            "world06"
        ]
        
        let pageStore = PageStore.shared
    }
}

// MARK: Steps and Step Configurations

extension Tutorial.Evaluator {
    
    // MARK: Steps
    
    enum Step: EvaluatorStep {
        case loading
        case interlude
        case mainTitle(MainTitleStepConfiguration)
        case chapterTitle(ChapterTitleStepConfiguration)
        case page(PageStepConfiguration)
        case world(WorldStepConfiguration)
    }
    
    // MARK: Configurations
    
    struct MainTitleStepConfiguration {
        var title: String
    }
    
    struct ChapterTitleStepConfiguration {
        var title: String
        var chapterIndex: Int
        var chapterNumber: Int { return chapterIndex + 1 }
    }
    
    struct PageStepConfiguration {
        var chapterIndex: Int
        var pageIndex: Int
        var pageData: [Chapter]
        
        // Computed
        var title: String { return pageData[chapterIndex].title }
        var body: [Page.Body] { return pageData[chapterIndex].pages[pageIndex].body }
        var supplement: [Page.Body]? { return pageData[chapterIndex].pages[pageIndex].supplement }
        var chapterNumber: Int { return chapterIndex + 1 }
        var pageNumber: Int { return pageIndex + 1 }
        var pageCountWithinChapter: Int { return pageData[chapterIndex].pages.count }
        var chapterCount: Int { return pageData.count }
        var buttonAction: ButtonAction? { return pageData[chapterIndex].pages[pageIndex].action }
        var selectableChapterTitles: [NumberedNamedEvaluatorAction] { return selectableChapterTitles(for: pageData)}
        
        func selectableChapterTitles(for pageData: [Chapter]) -> [NumberedNamedEvaluatorAction] {
            var selectableChapterTitles = [NumberedNamedEvaluatorAction]()
            
            for (i, chapter) in pageData.enumerated() {
                let selectableChapterTitle = NumberedNamedEvaluatorAction(
                    number: i + 1,
                    name: chapter.title,
                    action: ButtonAction.showChapter(chapterIndex: i, pageData: pageData)
                )
                selectableChapterTitles.append(selectableChapterTitle)
            }
            
            return selectableChapterTitles
        }
    }
    
    struct WorldStepConfiguration {
        var image: String
        var title: String
        var buttonAction: ButtonAction
    }
}

// MARK: View Cycle

extension Tutorial.Evaluator: ViewCycleEvaluator {
    
    func viewDidAppear() {
        
        // Get our pages
        let pageData = pageStore.pageData
        
        // Opening animation
        showInterludeStep()
        afterWait(500) {
            self.showMainTitleStep("The Poet Pattern")
            afterWait(1000) {
                self.showInterludeStep()
                afterWait(1000) {
                    self.showChapterTitleStep(
                        forChapterIndex: 0,
                        pageData: pageData)
                    afterWait(1000) {
                        self.showPageStep(
                            forChapterIndex: 0,
                            pageIndex: 0,
                            pageData: pageData)
                    }
                }
            }
        }
    }
}

// MARK: Button Actions

extension Tutorial.Evaluator: ButtonEvaluator {
    func buttonTapped(action: EvaluatorAction?) {
        guard let action = action as? ButtonAction else { return }
        switch action {
            
        case .pageForward:
            pageForward()
            
        case .pageBackward:
            pageBackward()
            
        case .advanceWorldImage:
            advanceWorldImage()
            
        case .helloWorld:
            showWorldStep()
            
        case .returnToTutorial(let chapterIndex, let pageIndex, let pageData):
            showInterludeStep()
            afterWait(200) {
                self.showPageStep(
                    forChapterIndex: chapterIndex,
                    pageIndex: pageIndex,
                    pageData: pageData)
            }
            
        case .showChapter(let chapterIndex, let pageData):
            self.showPageStep(
                forChapterIndex: chapterIndex,
                pageIndex: 0,
                pageData: pageData)
        }
    }
}

// MARK: Configuring Steps

extension Tutorial.Evaluator {
    
    func showInterludeStep() {
        current.step = .interlude
    }
    
    // MARK: Main Title
    
    func showMainTitleStep(_ text: String) {
        let configuration = MainTitleStepConfiguration(
            title: text
        )
        current.step = .mainTitle(configuration)
    }
    
    // MARK: Chapter Title
    
    func showChapterTitleStep(forChapterIndex chapterIndex: Int, pageData: [Chapter]) {
        let configuration = ChapterTitleStepConfiguration(
            title: pageData[chapterIndex].title,
            chapterIndex: chapterIndex)
        current.step = .chapterTitle(configuration)
    }
    
    // MARK: Page
    
    func showPageStep(forChapterIndex chapterIndex: Int, pageIndex: Int, pageData: [Chapter]) {
        let configuration = PageStepConfiguration(
            chapterIndex: chapterIndex,
            pageIndex: pageIndex,
            pageData: pageData
        )
        current.step = .page(configuration)
    }
    
    func pageForward() {
        // Must be in Page step
        guard case let .page(configuration) = current.step else { return }
        
        var isNewChapter = false
        
        let (nextChapter, nextPage): (Int, Int) = {
            if configuration.pageIndex < configuration.pageCountWithinChapter - 1 {
                return (configuration.chapterIndex, configuration.pageIndex + 1)
            } else {
                isNewChapter = true
                if configuration.chapterIndex < configuration.chapterCount - 1 {
                    return (configuration.chapterIndex + 1, 0)
                } else {
                    return (0, 0)
                }
            }
        }()
        
        if isNewChapter {
            showInterludeStep()
            afterWait(500) {
                self.showChapterTitleStep(
                    forChapterIndex: nextChapter,
                    pageData: configuration.pageData)
                afterWait(1000) {
                    self.showPageStep(
                        forChapterIndex: nextChapter,
                        pageIndex: nextPage,
                        pageData: configuration.pageData)
                }
            }
        } else {
            showPageStep(
                forChapterIndex: nextChapter,
                pageIndex: nextPage,
                pageData: configuration.pageData)
        }
    }
    
    func pageBackward() {
        // Must be in Page step
        guard case let .page(configuration) = current.step else { return }
        
        
        let (chapter, page): (Int, Int) = {
            if configuration.pageIndex > 0 {
                return (configuration.chapterIndex, configuration.pageIndex - 1)
            } else {
                if configuration.chapterIndex > 0 {
                    let newChapter = configuration.chapterIndex - 1
                    let newPage = configuration.pageData[newChapter].pages.count - 1
                    return (newChapter, newPage)
                } else {
                    return (0, 0)
                }
            }
        }()
        
        showPageStep(forChapterIndex: chapter, pageIndex: page, pageData: configuration.pageData)
    }
    
    // MARK: Hello World
    
    func showWorldStep() {
        // Must be in Page step
        if case let .page(configuration) = self.current.step {
            showInterludeStep()
            afterWait(500) {
                self.showWorld(rememberingChapterIndex: configuration.chapterIndex, pageIndex: configuration.pageIndex + 1, pageData: configuration.pageData)
            }
        }
    }

    func showWorld(rememberingChapterIndex chapterIndex: Int, pageIndex: Int, pageData: [Chapter]) {
        let configuration = WorldStepConfiguration(
            image: self.worldImages[0],
            title: "Hello World!",
            buttonAction: .returnToTutorial(chapterIndex: chapterIndex, pageIndex: pageIndex, pageData: pageData)
        )
        current.step = .world(configuration)
    }
    
    func advanceWorldImage() {
        // Must be in Image step
        guard case var .world(configuration) = current.step else { return }
        
        if let index = worldImages.firstIndex(of: configuration.image) {
            let newImage: String = {
                if index < worldImages.count - 1 {
                    return worldImages[index + 1]
                } else {
                    return worldImages[0]
                }
            }()
            
            configuration.image = newImage
        
            current.step = .world(configuration)
        }
    }
}

protocol ButtonEvaluator: class {
    func buttonTapped(action: EvaluatorAction?)
}
