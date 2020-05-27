//
//  Chapter_BusinessState.swift
//  Poet
//
//  Created by Steve Cotner on 5/26/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

extension Tutorial.PageStore {
    var chapter_BusinessState: Chapter {
        return Chapter(
            "Business State (In Progress)",
            files: [
                        "SayHelloWorld-Evaluator"
            ],
            pages:
            Page([.text("A cleanly separated business state doesn't mean much to us unless we can update it. If you tap the button that says “Show Hello World,” you'll see a screen that includes some basic user interaction and some very minimal updates to business state.")],
                 action: .showHelloWorld
            ),
            
            Page([.text("In its structure, Hello World isn't too different from the Template we've already seen. That previous screen's evaluator only included one step (besides initial), named “text.” Likewise, Hello World's evaluator only includes a single step, which it calls “sayStuff.”"),
                  .text("But this evaluator also knows about two Actions, named “sayHello” and “sayNothing.”")],
                 action: .showHelloWorld
            ),
            
            Page([.text("...")],
                 action: .showHelloWorld
            ),
            
            Page([.text("...")],
                 action: .showHelloWorld
            )
            
            // ////////////////////////////////////
            
            /*
             Page([
             .text("In the evaluator, our buttonTapped(:) method is where we first hear that a button was tapped."),
             .smallCode(
             """
             func evaluate(_ action: EvaluatorAction?) {
             // …
             }
             """
             )
             ]),
             
             Page([
             .text("Within that method, we make sure the general EvaluatorAction type sent to us is really the ButtonAction type we expect:"),
             .smallCode(
             """
             guard let action = action as? ButtonAction else { return }
             """
             )
             ]),
             
             Page([
             .text("Then we switch on the action and call a method to handle it:"),
             .code(
             """
             switch action {
             case .pageForward:
             pageForward()
             """
             )
             ], supplement: Supplement(shortTitle: "buttonTapped()", fullTitle: "", body:[
             .code(
             """
             extension Tutorial.Evaluator: ActionEvaluating {
             func evaluate(_ action: EvaluatorAction?) {
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
             """
             )
             ])),
             
             Page([
             .text("Now the evaluator begins the work of reflecting on its current state and then updating it. It starts by looking at our current “step.”"),
             ]),
             
             Page([
             .text("The evaluator always has one and only one current step. A step is a simple enum case that represents a coherent unit of business state."),
             ]),
             
             Page([
             .text("Our evaluator has a few different steps it could be in, including a .page step:"),
             .code(
             """
             case page(PageStepConfiguration)
             """)
             ], supplement: Supplement(shortTitle: "Step", fullTitle: "", body: [
             .code(
             """
             enum Step: EvaluatorStep {
             case initial
             case interlude
             case mainTitle(MainTitleStepConfiguration)
             case chapterTitle(ChapterTitleStepConfiguration)
             case page(PageStepConfiguration)
             }
             """)
             ])),
             
             Page([
             .text("We should currently be in the page step. We'll check just to make sure:"),
             .code(
             """
             func pageForward() {
             guard case let .page(configuration)
             = current.step else { return }
             """)
             ]),
             
             Page([
             .text("Now we know our current step's state, stored as a PageStepConfiguration. That configuration has lots of data stored on it:"),
             .code(
             """
             struct PageStepConfiguration {
             var chapterIndex: Int
             var pageIndex: Int
             var pageData: [Chapter]
             // etc.
             """)
             ], supplement: Supplement(shortTitle: "PageStepConfiguration", fullTitle: "", body: [
             .code(
             """
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
             
             // Helper methods
             // ...
             }
             """)
             ])),
             
             Page([
             .text("We'll use the configuration's data to reason about our current business state. We've been asked to page forward, but first we need to figure out if we're in the middle of a chapter or at the end of one.")
             ]),
             
             Page([
             .text("We know there are two values stored in our page configuration which will let us figure that out:"),
             .code(".pageIndex"),
             .text("and"),
             .code(".pageCountWithinChapter")
             ]),
             
             Page([
             .text("Notice that all the data we need is on the configuration itself. We haven't looked anywhere else. In most implementations of the Poet pattern, the configuration is always the entire source of truth for the evaluator's state.")
             ]),
             
             Page([
             .text("Why be so exacting? By making the step the source of truth, we can avoid ambiguous or mismatched state. There is no global state, on the evaluator or beyond, to mismanage. There is only what is defined on the current step.")
             ]),
             
             Page([
             .text("If we determine that we are in the middle of a chapter, we'll figure out the next page index and ask to show it:"),
             .code(
             """
             showPageStep(
             forChapterIndex: nextChapter,
             pageIndex: nextPage,
             pageData: configuration.pageData)
             """)
             ]),
             
             
             Page([
             .text("We'll do a little extra if we're at the end of a chapter:"),
             .code(
             """
             showInterludeStep()
             afterWait(500) {
             self.showChapterTitleStep( ... )
             afterWait(1000) {
             self.showPageStep( ... )
             """)
             ], supplement: Supplement(shortTitle: "pageForward()", fullTitle: "", body: [
             .code(
             """
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
             """)
             ])),
             
             Page([
             .text("What does it mean to “show” a step? We just make a new configuration and save it:"),
             .code(
             """
             let configuration = PageStepConfiguration(
             chapterIndex: chapterIndex,
             pageIndex: pageIndex,
             pageData: pageData
             )
             
             current.step = .page(configuration)
             """
             )
             ], supplement: Supplement(shortTitle: "showPageStep()", fullTitle: "", body: [
             .code(
             """
             func showPageStep(forChapterIndex chapterIndex: Int, pageIndex: Int, pageData: [Chapter]) {
             let configuration = PageStepConfiguration(
             chapterIndex: chapterIndex,
             pageIndex: pageIndex,
             pageData: pageData
             )
             
             current.step = .page(configuration)
             }
             """
             )
             ])),
             
             Page([
             .text("When we save the step, our Translator will hear about it. That's because the step is a “Passable” type that publishes its changes:"),
             .code("var current = PassableStep(Step.initial)")
             ]),
             
             Page([.text("PassableStep is just a helpful wrapper:"),
             .smallCode(
             """
             class PassableStep<S: EvaluatorStep> {
             var subject = PassthroughSubject<S, Never>()
             
             var step: S {
             willSet { subject.send(newValue) }
             }
             
             init(_ step: S) { self.step = step }
             }
             """
             )
             ]),
             
             Page([.text("The translator listens to the passable step by making a sink for its published values:"),
             .code(
             """
             init(_ step:
             PassableStep<Evaluator.Step>) {
             behavior = step.subject.sink
             { value in
             self.translate(step: value)
             }
             }
             """
             )
             ]),
                
             Page([.text("So, with the translator already set up properly, the evaluator completes its work simply by saving a new step.")])
             */
        )
    }
}
