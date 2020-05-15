//
//  Tutorial-PageStore.swift
//  Poet
//
//  Created by Stephen E Cotner on 5/9/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

extension Tutorial {
    class PageStore {
        
        typealias Chapter = Evaluator.Chapter
        typealias Page = Evaluator.Page
        
        static let shared = PageStore()
        
        let pageData: [Chapter] = [
            Chapter("Introduction", pages:
                Page([.text("You're looking at a screen made with the Poet pattern. The code behind it emphasizes clarity, certainty, and flexibility.")]),
                Page([.text("The process of writing Poet code is methodical but relatively quick. It follows the philosophy that a pattern “should be made as simple as possible, but no simpler.”")]),
                Page([.text("Poet has a rote structure but it frees you to write quickly and confidently, without the fear that your code will get tangled up over time.")]),
                Page([.text("We'll learn about the pattern, and the benefits it confers, by thinking about how this screen was made. But first, why is it called Poet?")])
            ),
            
            Chapter("Why Poet?", pages:
                Page([.text("Poet is an acronym that stands for Protocol-Oriented Evaluator/Translator. The evaluator and translator are a pair that work together.")]),
                Page([.text("You can think of the evaluator and translator as two different layers in the pattern, or as two different phases of reasoning that the programmer will undertake.")]),
                Page([.text("The evaluator is the business logic decision-maker. It maintains what we might call “business state.”")]),
                Page([.text("The translator interprets the intent of the evaluator and turns it into observable and passable “display state.”")]),
                Page([.text("And the view layer — a screen made up of SwiftUI View structs — is the part that observes or is passed the translator's display state.")]),
                Page([.text("A given user flow requires participation from all three layers — evaluator, translator, and view. Sometimes we need to be deliberate about each layer and spell out their work step by step.")]),
                Page([.text("Other times, we already know what each layer should do, and protocol-oriented programming can bridge them all with default protocol implementations.")]),
                Page([.text("There's one more feature of the Poet pattern that's pretty fundamental: “steps.” The evaluator's business state is always encapsulated in a single step, a distinct unit of state. We'll talk a lot more about that soon.")]),
                Page([.text("That's enough of a high-level overview. Back to this screen and how it was made.")])
                ),
            
            Chapter("Interacting with a View", pages:
                Page([.text("In Poet, whenever you interact with a view on screen, the view tells its evaluator about it.")]),
                
                Page([
                    .text("When you tap this text, for instance, it says to the evaluator:"),
                    .code(
                        """
                        buttonTapped(action:
                          ButtonAction.pageForward)
                        """
                    )]),
                
                Page([
                    .text(".pageForward belongs to an enum that is declared on our evaluator and which contains all the button actions relevant to this screen:"),
                    .smallCode(
                    """
                    enum ButtonAction: EvaluatorAction {
                      case pageForward
                      case pageBackward
                      // etc.
                    """
                    )
                    
                ], supplement: [
                    .code(
                    """
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
                    """
                    )
                ]),
                
                Page([
                    .text("The evaluator's ButtonAction type conforms to a more general type EvaluatorAction, so the view layer can be fully decoupled from the business layer.")
                ]),
                
                Page([.text("But in our case, our view is a little opinionated and does know our action by its specific type:"),
                      .smallCode(
                        """
                        Tutorial.Evaluator.ButtonAction
                        .pageForward
                        """
                    )
                ]),
                
                Page([
                    .text("Even an opinionated view doesn't know what a button action really does, though. That's up to the evaluator, who conforms to ButtonEvaluator:"),
                    .smallCode(
                        """
                        protocol ButtonEvaluator: class {
                          func buttonTapped(
                            action: EvaluatorAction?)
                        }
                        """
                    )
                ]),
                
                Page([.text("Upon receiving an action, the evaluator will make decisions about business state. Then the translator will interpret that state and create its own display state. And the view layer will respond any time display state changes.")]),
                
                Page([.text("The evaluator and translator are two different stops along a route that rolls toward the view layer.")])
                ),
                
            Chapter("Updating Business State", pages:
                Page([
                    .text("In the evaluator, our buttonTapped(:) method is where we first hear that a button was tapped."),
                    .smallCode(
                        """
                        func buttonTapped(action: EvaluatorAction?) {
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
                ], supplement: [
                .code(
                    """
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
                    """
                )
                ]),
                
                Page([
                    .text("Now the evaluator begins the work of reflecting on its current state and then updating it. It starts by looking at our current “step.”"),
                ]),
                
                Page([
                    .text("The evaluator always has one and only one current step. A step is a simple enum case that represents a coherent unit of business state."),
                ]),
                
                Page([
                    .text("Our evaluator has a few different steps it could be in, including a .page step:"),
                    .smallCode(
                        """
                        case page(PageStepConfiguration)
                        """)
                ], supplement: [
                    .code(
                    """
                    enum Step: EvaluatorStep {
                      case loading
                      case interlude
                      case mainTitle(MainTitleStepConfiguration)
                      case chapterTitle(ChapterTitleStepConfiguration)
                      case page(PageStepConfiguration)
                      case world(WorldStepConfiguration)
                    }
                    """)
                ]),
        
                Page([
                    .text("We should currently be in the page step. We'll check just to make sure:"),
                    .extraSmallCode(
                        """
                        func pageForward() {
                          guard case let .page(configuration)
                            = current.step
                          else {
                            return
                          }
                        """)
                ]),
                
                Page([
                    .text("Now we know our current step's state, stored as a PageStepConfiguration. That configuration has lots of data stored on it:"),
                    .smallCode(
                        """
                        struct PageStepConfiguration {
                          var chapterIndex: Int
                          var pageIndex: Int
                          var pageData: [Chapter]
                          // etc.
                        """)
                ], supplement: [
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
                ]),
                
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
                    .text("Notice that all the data we need is on the configuration itself. We haven't looked anywhere else. In strict implementations of the Poet pattern, the configuration is always the entire source of truth for the evaluator's state.")
                ]),
                
                Page([
                    .text("Why be so exacting? By making the step the source of truth, we can avoid ambiguous or mismatched state. There is no global state, on the evaluator or beyond, to mismanage. There is only what is defined on the current step.")
                ]),
                
                Page([
                    .text("If we determine that we are in the middle of a chapter, we'll figure out the next page index and ask to show it:"),
                    .extraSmallCode(
                        """
                        showPageStep(
                          forChapterIndex: nextChapter,
                          pageIndex: nextPage,
                          pageData: configuration.pageData)
                        """)
                ]),
                
                
                Page([
                .text("We'll do a little extra if we're at the end of a chapter:"),
                .extraSmallCode(
                    """
                    showInterludeStep()
                      afterWait(500) {
                        self.showChapterTitleStep( ... )
                        afterWait(1000) {
                          self.showPageStep( ... )
                    """)
                ], supplement: [
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
                ]),
                
                Page([
                    .text("What does it mean to “show” a step? We just make a new configuration and save it:"),
                    .smallCode(
                        """
                        let configuration =
                          PageStepConfiguration(
                            chapterIndex: chapterIndex,
                            pageIndex: pageIndex,
                            pageData: pageData
                        )
                        current.step =
                          .page(configuration)
                        """
                    )
                ], supplement: [
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
                ]),
                
                Page([
                    .text("When we save the step, our Translator will hear about it. That's because the step is a “Passable” type that publishes its changes:"),
                    .smallCode("var current = PassableStep(Step.loading)")
                ]),
                
                Page([.text("PassableStep is just a helpful wrapper:"),
                      .extraSmallCode(
                        """
                        class PassableStep<S: EvaluatorStep> {
                          var subject =
                            PassthroughSubject<S, Never>()
                            
                          var step: S {
                            willSet { subject.send(newValue) }
                          }
                                
                          init(_ step: S) { self.step = step }
                        }
                        """
                    )
                ]),
                
                Page([.text("The translator listens to the passable step by making a sink for its published values:"),
                      .extraSmallCode(
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
                
//                Page([.text("Soon we'll talk about why it's handy to have these two different types of state, business and display, after a brief discussion of state in general.")])
            ),
            
            // Translating
            Chapter("Translating", pages:
                
                Page([
                    .text("The work of the translator is straightforward. For any given state in the evaluator, the translator must turn it into display state — should I show something? What should it say? Does it animate? — in a reliable, deterministic manner."),
                ]),
                    
                Page([
                    .text("It does this by calling the translate(:) method on itself whenever it notices that the evaluator's current step has been modified:"),
                    .smallCode("self.translate(step: value)"),
                    .text("That method expects a Step declared on the evaluator."),
                ]),
                    
                Page([
                    .text("In the translate method, the translator just gathers the step's configuration and calls a corresponding method:"),
                    .smallCode(
                        """
                        func translate(step: Evaluator.Step) {
                          switch step {
                          case .page(let configuration):
                          translatePageStep(configuration)
                        """
                    )
                ], supplement: [
                    .code(
                        """
                        func translate(step: Evaluator.Step) {
                            switch step {
                                
                            case .loading:
                                translateLoading()
                                
                            case .mainTitle(let configuration):
                                translateMainTitleStep(configuration)
                                
                            case .chapterTitle(let configuration):
                                translateChapterTitleStep(configuration)

                            case .page(let configuration):
                                translatePageStep(configuration)
                                
                            case .world(let configuration):
                                translateWorldStep(configuration)
                                
                            case .interlude:
                                translateInterlude()
                            }
                        }
                        """
                    )]
                ),
                
                Page([
                    .text("And now we face the work of creating display state. It turns out that's just a matter of assigning basic value types like strings, integers, bools, and arrays. Occasionally, we also choose an animation.")
                ]),
                
                Page([
                    .text("For instance, here are a few strings and integers we will set, which correspond to things we see on screen:"),
                    .smallCode(
                        """
                        var mainTitle = ObservableString()
                        var chapterNumber = ObservableInt()
                        var chapterTitle =
                          ObservableString()
                        var pageXofX = ObservableString()
                        """
                    )
                ]),
                
                Page([
                    .text("You'll notice something: they are all an “observable” type. Observable types are just convenient wrappers around published value types. They tuck away the slight complexity of publishing.")
                ]),
                
                Page([
                    .text("ObservableString, for instance, looks like this:"),
                    .extraSmallCode(
                    """
                    class ObservableString: ObservableObject {
                      @Published var string: String
                        
                      init(_ string: String = "") {
                        self.string = string
                      }
                    }
                    """
                    )
                ]),
                
                Page([
                    .text("Any view in the view layer can observe an ObservableString by holding onto it as an @ObservedObject. Every time the wrapped string value changes, the view will update.")
                ]),
                
                Page([
                    .text("There's another benefit to these observable wrappers. Imagine we kept all of our published values on the translator itself, instead of on these separate objects. Every view would have to hold onto the translator as an @ObservedObject.")
                ]),
                
                Page([
                    .text("If we did that, our entire view hierarchy would remake itself whenever a value on the translator changes, even values a particular view isn't interested in.")
                ]),
                
                Page([
                    .text("This is inefficient, and it could also lead to unexpected outcomes — if views exhibit certain behavior whenever they appear, for instance.")
                ]),
                
                Page([
                    .text("Now we're familiar with our observable properties:"),
                    .smallCode(
                        """
                        var mainTitle = ObservableString()
                        var chapterNumber = ObservableInt()
                        // etc.
                        """
                    ),
                    .text("Each of these will be observed by a a view on screen."),
                ]),
                
                Page([
                    .text("The job of the translator is to set all these observable properties coherently, so that the view layer can make the correct choices, according to its own view logic.")
                ]),
                
                Page([
                    .text("Fortunately, because our evaluator holds onto its state as a coherent step, the translator can think about each step independently of the others. As long as every property is set correctly for a given step, we have done our job to a T.")
                ]),
                
                
                Page([
                    .text("We have an “interlude” step, for example, in which we want everything on screen to go away. To translate that step, we just say no to everything:"),
                    .extraSmallCode(
                        """
                        shouldShowChapterNumber.bool = false
                        shouldShowChapterTitle.bool = false
                        shouldShowBody.bool = false
                        shouldShowTapMe.bool = false
                        """
                    )
                ], supplement: [
                    .code(
                        """
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
                            shouldShowExtraButton.bool = false
                          }
                        }
                        """
                    )
                ]),
                
                Page([
                    .text("When we translate the “page” step, we say yes to some of those things:"),
                    .extraSmallCode(
                        """
                        shouldShowChapterNumber.bool = true
                        shouldShowChapterTitle.bool = true
                        shouldShowBody.bool = true
                        """
                    )
                ]),
                
                Page([
                    .text("We're a little more clever about the “Tap Me” text:"),
                    .extraSmallCode(
                        """
                        if firstPage {
                          withAnimation( ... ) {
                            self.shouldShowTapMe.bool = true
                          }
                        } else {
                          withAnimation( ... ) {
                            self.shouldShowTapMe.bool = false
                          }
                        }
                        """
                    )
                ], supplement: [
                    .code(
                    """
                    func translatePageStep(_ configuration: Evaluator.PageStepConfiguration) {
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
                      if configuration.supplement != nil {
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
                      supplementBody.array = configuration.supplement ?? []
                      pageXofX.string = "\\(configuration.pageNumber) / \\(configuration.pageCountWithinChapter)"
                      buttonAction.object = configuration.buttonAction
                      selectableChapterTitles.array = configuration.selectableChapterTitles
                        
                      if let actionName = configuration.buttonAction?.name {
                        buttonName.string = actionName
                      }
                    }
                    """
                    )
                ]),
                
                Page([
                    .text("Some steps will be simple to translate, while others will account for animations and involve what we might call display reasoning — say, formatting a string, or choosing whether or not to show a thing based on the presence of a certain value.")
                ]),
                
                Page([
                    .text("So we have formalized two distinct phases of reasoning for the programmer. Business decisions, like manipulating data and deciding what to do next, occur in the evaluator. Display decisions about how to present the data, or how to animate a transition, happen in the translator.")
                ]),
                
                Page([
                    .text("In a simple enough user flow, we could get by without all these distinctions. The evaluator/translator split isn't strictly necessary. Neither is the division of state into distinct steps.")
                ]),
                
                Page([
                    .text("But as screens get more complicated, these distinctions allow us to divide our work into manageable pieces that won't get tangled up over time. The programmer's cognitive load is lessened.")
                ]),
                                
                Page([
                    .text("Some user flows will be complicated enough that we'll really appreciate the clarity of a step-based approach. We'll look at such an example soon. But first, let's take a brief detour and think about another sort of translating involving passable state.")
                ])
            ),
            
            Chapter("Passable State", pages:
                Page([.text("If you tap the “Show Something” button below, you'll see a new screen pop up. Try it and come back when you're done (pull down to dismiss the screen).")], action: .showSomething),
                
                Page([.text("How did our evaluator, translator, and view layer work together to present that?"),
                      .text("They relied on what we can call passable state. More specifically, they made use of a PassthroughSubject to publish (and receive) our intent to show the screen.")]),
                
                Page([.text("PassthroughSubjects are a tiny bit demanding to think about, so we've wrapped one inside a type we call PassablePlease:"),
                      .extraSmallCode(
                        """
                        class PassablePlease {
                          var subject =
                            PassthroughSubject<Any?, Never>()
                          func please() {
                            subject.send(nil)
                          }
                        }
                        """
                    )
                ]),
                
                Page([.text("When our evaluator hears that we've triggered a ButtonAction named “showSomething,” it says to the translator directly:"),
                      .smallCode("translator.showSomething.please()")]),
                
                Page([.text("Why talk to the translator directly? We're presenting a modal, and everything on our current screen will remain unchanged underneath the modal. So it would feel superfluous to modify our own business state by assigning a new step.")]),
                
                Page([.text("Inside the translator, this works because we hold onto a PassablePlease object:"),
                      .extraSmallCode(
                    """
                    var showSomething = PassablePlease()
                    """
                )]),
                
                Page([.text("The view layer is listening for that please. Whenever it hears please, it shows the screen by toggling a @State property that a sheet (or modal) holds onto as a binding. But we've made that something that's easy to think about, too.")]),
                
                Page([.text("In the view layer, the entire code for presenting the Something screen looks like this:"),
                  .extraSmallCode(
                    """
                    ViewPresenter(self.translator.showSomething) {
                        Text("Something")
                    }
                    """
                )]),
                
                Page([.text("You could add a whole bunch of modals to a screen, each listening for a different please, by using that ViewPresenter type. How simple. So what does ViewPresenter do under the hood?")]),
                
                Page(
                    [.text("ViewPresenter is a view takes a PassablePlease and some view content as arguments. Here's its body:"),
                     .extraSmallCode(
                        """
                        var body: some View {
                          Spacer()
                            .sheet(
                              isPresented: self.$isShowing)
                              { self.content() }
                            .onReceive(passablePlease.subject)
                              { _ in self.isShowing.toggle() }
                        }
                        """
                        )
                    ],
                    supplement: [
                    .code(
                        """
                        struct ViewPresenter<Content>: View where Content : View {
                            let passablePlease: PassablePlease
                            var content: () -> Content
                            @State var isShowing: Bool = false
                               
                            init(_ passablePlease: PassablePlease, @ViewBuilder content: @escaping () -> Content) {
                                self.passablePlease = passablePlease
                                self.content = content
                            }
                            
                            var body: some View {
                                Spacer()
                                    .sheet(isPresented: self.$isShowing) {
                                        self.content()
                                    }
                                    .onReceive(passablePlease.subject) { _ in
                                        self.isShowing.toggle()
                                    }
                            }
                        }
                        """
                        )
                    ]
                ),
                
                Page([.text("The job of a ViewPresenter is to notice when a new “please” comes through and to toggle its own isShowing property. When that property toggles to true, the sheet will present the content.")]),
                Page([.text("If we had needed to do some more translating before passing our please to the view layer, our evaluator could have called a method on the translator:"),
                      .smallCode("translator.showSomethingScreen()")]),
                Page([.text("The translator then would do whatever extra translating it had in mind before calling please() on its own property.")]),
                Page([.text("And that's how we pass state imperatively, keeping a rigorous separation of our different layers but also linking them up with minimal code that's easy to follow.")]),
                Page([.text("Now, as promised, we can look at some examples, each a little more complex than the last, to better illustrate the Poet pattern. How about a simple template to start?")])
            ),
            
            Chapter("Template", pages:
                Page([.text("If you tap “Show Template,” you'll see a very simple screen made with the Poet pattern. We'll look at the code for each layer.")], action: .showTemplate),
                Page([.text("The evaluator has only two steps:"),
                      .extraSmallCode(
                        """
                        case loading
                        case title(TitleStepConfiguration)
                        """),
                      .text("Loading is just an empty step before the view has appeared.")]),
                Page([.text("When the view appears, the evaluator shows the title step:"),
                .extraSmallCode(
                    """
                    func showTitleStep() {
                      let configuration = TitleStepConfiguration(
                        title: "..."
                      )
                      current.step = .title(configuration)
                    }
                    """),
                ], supplement: [
                    .code(
                    """
                    import Foundation

                    extension Template {
                        class Evaluator {
                            
                            // Translator
                            lazy var translator: Translator = Translator(current)
                            
                            // Current Step
                            var current = PassableStep(Step.loading)
                            
                        }
                    }

                    // Steps and Step Configurations
                    extension Template.Evaluator {
                        
                        // Steps
                        enum Step: EvaluatorStep {
                            case loading
                            case title(TitleStepConfiguration)
                        }
                        
                        // Configurations
                        struct TitleStepConfiguration {
                            var title: String
                        }
                    }

                    // View Cycle
                    extension Template.Evaluator: ViewCycleEvaluator {
                        
                        func viewDidAppear() {
                            showTitleStep()
                        }
                    }

                    // Advancing Between Steps
                    extension Template.Evaluator {
                        func showTitleStep() {
                            let configuration = TitleStepConfiguration(
                                title: "You're looking at the Poet Template, located in Template-Screen.swift.\n\nLook at the code to see an example of very minimal screen that still follows the Poet pattern."
                            )
                            current.step = .title(configuration)
                        }
                    }

                    """
                )]),
                
                Page([.text("The translator translates by setting an observable title:"),
                .extraSmallCode(
                    """
                    func translateTitleStep( _ configuration:
                      Evaluator.TitleStepConfiguration) {
                        title.string = configuration.title
                    }
                  """
                )], supplement: [
                    .code(
                        """
                        import Foundation

                        extension Template {

                            class Translator {
                                
                                typealias Evaluator = Template.Evaluator
                                
                                // Observable Display State
                                var title = ObservableString()
                                
                                // Passthrough Behavior
                                private var behavior: Behavior?
                                
                                init(_ step: PassableStep<Evaluator.Step>) {
                                    behavior = step.subject.sink { value in
                                        self.translate(step: value)
                                    }
                                }
                            }
                        }

                        extension Template.Translator {
                            func translate(step: Evaluator.Step) {
                                switch step {
                                    
                                case .loading:
                                    translateLoadingStep()
                                    
                                case .title(let configuration):
                                    translateTitleStep(configuration)
                                }
                            }
                            
                            func translateLoadingStep() {
                                // nothing to see here
                            }
                            
                            func translateTitleStep(_ configuration: Evaluator.TitleStepConfiguration) {
                                // Set observable display state
                                title.string = configuration.title
                            }
                        }
                        """
                    )
                ]),
                
                Page([
                    .text("And the view layer observes the title:"),
                    .smallCode(
                        """
                        VStack {
                          ObservingTextView(translator.title)
                          .padding(36)
                        }
                        """
                    )
                ], supplement: [
                    .code(
                        """
                        import SwiftUI

                        struct Template {}

                        extension Template {
                            struct Screen: View {
                                
                                let _evaluator: Evaluator
                                weak var evaluator: Evaluator?
                                let translator: Translator
                                
                                init() {
                                    _evaluator = Evaluator()
                                    evaluator = _evaluator
                                    translator = _evaluator.translator
                                }
                                
                                @State var navBarHidden: Bool = true
                                
                                var body: some View {
                                    ZStack {
                                        
                                        VStack {
                                            ObservingTextView(translator.title)
                                            .padding(36)
                                        }
                                        
                                        VStack {
                                            DismissButton()
                                            Spacer()
                                        }
                                    }.onAppear {
                                        self.evaluator?.viewDidAppear()
                                        self.navBarHidden = true
                                    }
                                        
                                    // MARK: Hide Navigation Bar
                                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                                        self.navBarHidden = true
                                    }
                                    .navigationBarTitle("", displayMode: .inline)
                                    .navigationBarHidden(self.navBarHidden)
                                }
                            }
                        }
                        """
                    )
                ]),
                
                Page([.text("That's it. You can use the Template whenever you start a new screen. If you understand its flow, you should be able to follow the flow of more complicated screens, too. Let's look at one we'll call Hello World.")])
            ),
            
            Chapter("Hello World", pages:
                Page([.text("...")], action: .showHelloWorld)
            ),
            
            Chapter("Retail Demo", pages:
                Page([.text("...")])
            )
            
            /*
             
            // State
            Chapter("State", pages:
                
                Page([.text("Everything we do in an app creates state. State is the answer to the question, “what is true at this moment?”")]),
                    
                Page([.text("On this screen, we can guess that our state includes the text we're reading and the actions available to us.")]),
                
                Page([.text("It also entails that we're reading text and not, say, spinning a globe. But you can do that, too. Tap the “Hello World” button below.")], action: .helloWorld),
                
                Page([.text("Cool, huh? It looks like this screen has at least two different modes, or collections of state, that it must keep track of: showing this page, and showing that globe.")]),
                
                Page([.text("We have another, too, every time we start a new chapter and animate its title.")]),
                
                Page([.text("Modes are tough to reason about, because people tend not to notice them. Programmers often fail to distinguish which states are incompatible, so they never properly separate them into distinct data structures.")]),
                
                Page([.text("The challenge in making apps is to never create the conditions in which conflicting state can arise, because keeping track of everything will place an undue burden on the programmer.")]),
                
                Page([.text("When we think about what's on screen, for example, there are many elements which all dynamically respond to different observable properties. With each new property we add, we create a combinatorial explosion of possible states.")]),
                
                Page([.text("In our business logic, too, we inevitably multiply the number of potential states every time we add another bool to consider.")]),
                
                Page([.text("Some bools will be harmless when not properly set, while others will create an incoherent overall state if we're not careful.")]),
                
                Page([.text("Accounting for all possible combinations of mutually incompatible state is tough without a good plan. Bad choices build up over time, and the code becomes difficult to debug, maintain and modify.")]),
                
                Page([.text("Things will go better if you keep two things in mind. First, a screen's business state doesn't need to be one flat list that collapses different types of state onto a single object. It can be collected into coherent structures. And second, we can make a useful distinction between business state and display state.")]),
                
                Page([.text("One flat list of state — especially business state — is dangerous, because it places incompatible concepts alongside each other as if they might mingle without a problem.")]),
                
                Page([.text("If I want to show a page on screen, for instance, I know I will have to set several things: the chapter title, the page text, the page number. If I want to show an image, I will need to set an image. What happens if I set both an image and text at the same time?")]),
                
                Page([.text("In the simplest SwiftUI patterns, with a view layer tied directly to our business state, we might end up showing text and an image at the same time. That's a contrived example and easy to avoid, but on a more complex screen with more potential states, it's easy to imagine losing track of things.")]),
                
                Page([.text("Imagine a screen with four sequential steps, for instance, each of which both transforms data and stores the data for future transformations. How will you name all those properties in a way you can reason about? In a single, flat list it would be easy to lose track of the purpose of individual properties.")]),
                
                Page([.text("In such a scenario, it only makes sense that we separate our data into structures that represent the steps, each of which contains only the state needed to show that particular step correctly.")]),
                
                Page([.text("And along with that decision to group a page's state into a coherent structure, we can notice it's possible to further distinguish between business decisions (what is the page text? what is the chapter title?) and display decisions (how should the chapter title animate on screen?")]),
                
                Page([.text("In making these distinctions, we slow ourselves down once, the first time we create a “step.” Once, and only once, translator will have to interpret the step by setting every relevant property correctly. But from then on, we speed ourselves up every time we want to use that step.")]),
                
                Page([.text("By structuring our state coherently up front, we'll be able to mutate the current step's data or swap one step for another without fearing that we have missed something and created incompatible state.")]),
                
                Page([.text("Most patterns don't make these choices explicit, but they also don't protect you from creating incoherent state. They speed you up at first and then slow you down over time.")]),
                
                Page([.text("Next, we'll think more about the distinction between business state and display state.")])
            ),
            
            // Display State
            Chapter("Display State", pages:
                Page([.text("Display state entails all the choices that determine what happens on screen. What should the text say? The title? Should a button be visible?")]),
                Page([.text("When we say display state, it's important to note that we don't mean the view layer. The view layer can respond to changes in display state, and we'll call that response “view logic.”")]),
                Page([.text("But before we ever get to the view layer, something has to save the state that the view layer responds to.")]),
                Page([.text("Poet gives that job to a layer called the translator. On this screen, for instance, the translator answers true or false to “shouldShowBody” and “shouldShowButton.” It offers strings for “title” and “text.” And so on.")]),
                Page([.text("There's one special thing about how it does that: the text, strings, bools, and so on are all “observable,” meaning someone else can watch them for changes.")]),
                Page([.text("The view layer observes those bools and other types and hides or remakes its views accordingly.")]),
                Page([.text(
                    "The translator says things like this:"),
                    .code(
                    """
                    shouldShowChapterTitle.bool = true

                    shouldShowChapterNumber.bool = true
                    """)]),
                
                Page([.text("And this:"),
                    .code(
                    """
                    chapterNumber.int = configuration.chapterNumber

                    chapterTitle.string = configuration.title
                    """)]),
                Page([.text("But if setting values to show, hide or modify on-screen elements is all a matter of display state, then what is left for business state?")])
            ),
            
            // Business State
            Chapter("Business State", pages:
                Page([.text("The evaluator/translator divide allows the evaluator to make higher-level decisions about what should happen, without worrying about setting a precise display state.")]),
                Page([.text("It's the evaluator who decides what we really want to do. The evaluator hears that a user action has taken place, thinks about the current business state, and then saves a new state.")]),
                Page([.text("The last thing an evaluator will do is always to say, “show a certain ‘step’ with a certain ‘configuration,’” at which point the translator will interpret the new step into new display state.")]),
                Page([.text("When you tap this text, for instance, the evaluator handles the .pageForward action by checking its current step, which it expects to be a .page step and not some other kind (like .world or .interlude).")]),
                Page([.text("That .page step contains a configuration which knows everything we need to know about our current state: chapterIndex, pageIndex, etc. The evaluator can reason about these values whenever a new user action arrives.")]),
                Page([.text("The configuration also contains values which are there to serve the translator: title and text are strings that are plucked off a data store using chapterIndex and pageIndex. They're added to the configuration so the translator won't have to figure them out later. Title and text are therefore first-class members of business state.")]),
//                Page("So evaluator's steps serve two masters, but only "),
                Page([.text("If we want to go to the next page, we start with our current “page” step, modify its configuration, and save it as a new step.")]),
                Page([.text("To go to the next chapter, we cycle through a few steps with a slight delay: first an “interlude” step where everything fades away, then a “title” step where we just see the title, and then back to a new page.")]),
                Page([.text("The translator and the view layer will handle all the details like opacity and spring animations, letting the evaluator stay high above the action.")])
            ),
            
            // Interpreting
            Chapter("Interpreting", pages:
                // after a configuration is set, a translator takes some of those values and applies additional reasoning.
                // could you accomplish this all on one layer? technically, yes. but it aids the devlopment process to handle them separately.
                // the two-step process lets us first modify our business state with certainty by thinking in large categories — what step are we in? what data do we care about for that step?
                // then we modify our view state with certainty by taking the step as our starting point — what configuration do we have for our step? how should we change our view state in a way that will be correct for any possible values in our configuration?
                // a translator might want to style a title a certain way in one step, and a different way in another step. but an evaluator can have two different steps, each configured with a title, and leave it at that.
                // this separation of concerns not only decouples business logic from the view layer, it decouples it from the display state that informs the view layer.
                // as a result, you can refactor either layer, the evaluator or the translator, confident that you won't introduce unexpected behavior.
                // composable state. e.g. use interludes at various places
                
                Page([.text("")]),
                Page([.text("")])
                
                // Protocol-oriented translating -- alert, bezel
            ),
            
            // Decoupling the View Layer
            Chapter("Decoupling the View Layer", pages:
                // translator.buttonAction... button action injected into button. evaluator only known by protocol.
                Page([.text("")]),
                Page([.text("")])
            ),
            
            // Imperative, Protocol-Oriented Translating
            Chapter("Protocol-Oriented Translating", pages:
                // Protocol-oriented translating -- alert, bezel, action sheets. because we're writing in swift, we can take advantage of protoocol-oriented programming — the “P.O.” in P.O.E.T. — to make certain flows easy to implement. this gives us a pattern that speeds us up, instead of forcing us to reinvent or re-implement certain common solutions every time we make a new screen. The translator and view layer can each one require one or two lines of boilerplate to fully implement alerts, action sheets, and other common UI elements.
                // Over time, you might find protocol-oriented improvements that give you certain things for free.
                Page([.text("")]),
                Page([.text("")])
            ),
            
            // Decoupling the View Layer
            Chapter("Helper Types", pages:
                // evaluator known by protocol. buttonTapped(...)
                Page([.text("Observables")]),
                Page([.text("Passables")])
            ),
            
            */

            // the right division, the right abstraction between the two layers.
            // there's a hinge where translator behavior is reusable. we eliminate a source of combinatorial explosions.
            
            // Interpreting Business State
            
            // in terms of business state, incompatible
            // in display state, we're either showing things or not. but any given thing should only know about the state it cares about.
            
        ]
    }
}
