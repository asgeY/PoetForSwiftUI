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
                    .text("Some user flows will be complicated enough that we'll really appreciate the clarity of a step-based approach. We'll look at such an example soon.")]),
                
                Page([.text("But first, let's take a brief detour and think about another sort of translating involving passable state.")])
            ),
            
            Chapter("Passable State", pages:
                Page([.text("If you tap the button that says “Show Something,” you'll see a very simple screen pop up. Try it and come back when you're done (pull down to dismiss the screen).")], action: .showSomething),
                
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
                
                Page([.text("Why talk to the translator directly? We're presenting a modal, and everything on our current screen will remain unchanged underneath the modal. So it would feel superfluous to modify our own business state by changing our current step.")]),
                
                Page([.text("Inside the translator, saying “please” works because we hold onto a PassablePlease object:"),
                      .extraSmallCode(
                    """
                    var showSomething = PassablePlease()
                    """
                )]),
                
                Page([.text("The view layer is listening for that word. Whenever it hears please, it shows the screen by toggling a @State property that a sheet (or modal) holds onto as a binding. But we've made that something that's easy to think about, too.")]),
                
                Page([.text("In the view layer, the entire code for presenting the Something screen looks like this:"),
                  .extraSmallCode(
                    """
                    Presenter(self.translator.showSomething) {
                        Text("Something")
                    }
                    """
                )]),
                
                Page([.text("You could add a whole bunch of modals to a screen, each listening for a different please, by using that Presenter type. And in fact that's what this Tutorial does. So what does Presenter do under the hood?")]),
                
                Page(
                    [.text("Presenter is a view takes a PassablePlease and some view content as arguments. Here's its body:"),
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
                        struct Presenter<Content>: View where Content : View {
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
                
                Page([.text("The job of a Presenter is to notice when a new “please” comes through and to toggle its own isShowing property. When that property toggles to true, the sheet will present the content.")]),
                Page([.text("If we had needed to do some more translating before passing our please to the view layer, our evaluator could have called a method directly on the translator, something like this:"),
                      .smallCode("translator.showSomethingScreen()")]),
                Page([.text("The translator then would do whatever extra translating it had in mind before calling please() on its own property.")]),
                Page([.text("And that's how we pass state imperatively. We keep a rigorous separation of our different layers, but we also link them up with minimal code that's easy to follow.")]),
                Page([.text("Speaking of minimal code, let's look at another technique that saves us from being repetitive as we bridge our different layers: protocol-oriented translating.")])
            ),
            
            Chapter("Protocol-Oriented Translating", pages:
                Page([.text("A lot of user interface elements are very predictable but still require a good amount of code to implement: alerts, action sheets, bezels, toasts.")]),
                Page([.text("iOS programmers are used to asking for these things imperatively, but in SwiftUI, we bring them about my modifying our display state.")]),
                Page([.text("That's a little painful to do, and in simple implementations we end up coupling specific alerts to our view layer. But we can do it better by following a technique we'll call protocol-oriented translating.")]),
                Page([.text("Take this alert, for example. If you tap the button below that says “Show Alert,” you'll see it.")], action: .showAlert),
                Page([.text("Or here's another, with two styled actions. Tap “Show Another Alert” to see it.")], action: .showAnotherAlert),
                Page([.text("The challenge for us is to decouple the content of these alerts from the view layer, so the evaluator can imperatively trigger alerts with whatever content it likes.")]),
                Page([.text("We'll do that by first dividing our responsibilities correctly, then streamlining the process with protocol-oriented default implementations.")]),
                Page([.text("The view layer needs to be smart enough to show any sort of alert, and to observe the values that will inform the alert's contents. We accomplish that with AlertView:"),
                      .smallCode(
                        """
                        struct AlertView: View { ... }
                        """
                    )
                    ],
                     supplement: [
                    .code(
                        """
                        import Combine
                        import SwiftUI

                        struct AlertView: View {
                            @ObservedObject private var title: ObservableString
                            @ObservedObject private var message: ObservableString
                            @ObservedObject private var primaryAlertAction: ObservableAlertAction
                            @ObservedObject private var secondaryAlertAction: ObservableAlertAction
                            @ObservedObject private var isPresented: ObservableBool
                            
                            init(translator: AlertTranslating) {
                                title = translator.alertTranslator.alertTitle
                                message = translator.alertTranslator.alertMessage
                                primaryAlertAction = translator.alertTranslator.primaryAlertAction
                                secondaryAlertAction = translator.alertTranslator.secondaryAlertAction
                                isPresented = translator.alertTranslator.isAlertPresented
                            }
                            
                            var body: some View {
                                VStack {
                                    EmptyView()
                                }
                                .alert(isPresented: $isPresented.bool) {
                                    if let primaryAlertAction = primaryAlertAction.alertAction, let secondaryAlertAction = secondaryAlertAction.alertAction {
                                        let primaryButton: Alert.Button = button(for: primaryAlertAction)
                                        let secondaryButton: Alert.Button = button(for: secondaryAlertAction)
                                        return Alert(title: Text(title.string), message: Text(message.string), primaryButton: primaryButton, secondaryButton: secondaryButton)
                                    } else if let primaryAlertAction = primaryAlertAction.alertAction {
                                        let primaryButton: Alert.Button = button(for: primaryAlertAction)
                                        return Alert(title: Text(title.string), message: Text(message.string), dismissButton: primaryButton)
                                    } else {
                                        let primaryButton = Alert.Button.default(Text("OK"))
                                        return Alert(title: Text(title.string), message: Text(message.string), dismissButton: primaryButton)
                                    }
                                }
                            }
                            
                            func button(for alertAction: AlertAction) -> Alert.Button {
                                switch alertAction.style {
                                case .regular:
                                    return Alert.Button.default(Text(alertAction.title), action: {
                                        DispatchQueue.main.async {
                                            alertAction.action?()
                                        }
                                    })
                                case .cancel:
                                    return Alert.Button.cancel(Text(alertAction.title), action: {
                                        DispatchQueue.main.async {
                                            alertAction.action?()
                                        }
                                    })
                                case .destructive:
                                    return Alert.Button.destructive(Text(alertAction.title), action: {
                                        DispatchQueue.main.async {
                                            alertAction.action?()
                                        }
                                    })
                                }
                            }
                        }
                        """
                        )
                    ]
                     ),
                Page([.text("Next, the translator needs to provide observable values for title, message, and so on.")]),
                Page([.text("We'll bundle those up in a separate AlertTranslator:"),
                      .extraSmallCode(
                        """
                        struct AlertTranslator {
                          var title = ObservableString()
                          var message = ObservableString()
                          var primaryAlertAction =
                            ObservableAlertAction()
                          var secondaryAlertAction =
                            ObservableAlertAction()
                          var isAlertPresented =
                            ObservableBool(false)
                        }
                        """
                    )
                ], supplement: [
                    .code(
                    """
                    struct AlertTranslator {
                        var title = ObservableString()
                        var message = ObservableString()
                        var primaryAlertAction = ObservableAlertAction()
                        var secondaryAlertAction = ObservableAlertAction()
                        var isAlertPresented = ObservableBool(false)
                    }

                    struct AlertAction {
                        let title: String
                        let style: AlertStyle
                        let action: (() -> Void)?
                        
                        enum AlertStyle {
                            case regular
                            case cancel
                            case destructive
                        }
                    }
                    """
                    )
                ]),
                Page([.text("Our translator will hold onto that AlertTranslator. But that's as much thinking as we want to do on each screen we implement.")]),
                Page([.text("So we'll make our translator conform to AlertTranslating to give it default implementations of some “showAlert” methods."),
                      .extraSmallCode(
                        """
                        protocol AlertTranslating {
                          var alertTranslator:
                            AlertTranslator { get }
                          func showAlert(title: String,
                            message: String)
                          // ...
                        }
                        """
                    )
                ], supplement: [
                    .code(
                        """
                        protocol AlertTranslating {
                            var alertTranslator: AlertTranslator { get }
                            func showAlert(title: String, message: String)
                            func showAlert(title: String, message: String, alertAction: AlertAction)
                            func showAlert(title: String, message: String, primaryAlertAction: AlertAction, secondaryAlertAction: AlertAction)
                        }

                        extension AlertTranslating {
                            func showAlert(title: String, message: String) {
                                alertTranslator.alertTitle.string = title
                                alertTranslator.alertMessage.string = message
                                alertTranslator.isAlertPresented.bool = true
                                alertTranslator.primaryAlertAction.alertAction = nil
                                alertTranslator.secondaryAlertAction.alertAction = nil
                            }
                            
                            func showAlert(title: String, message: String, alertAction: AlertAction) {
                                alertTranslator.alertTitle.string = title
                                alertTranslator.alertMessage.string = message
                                alertTranslator.primaryAlertAction.alertAction = alertAction
                                alertTranslator.secondaryAlertAction.alertAction = nil
                                alertTranslator.isAlertPresented.bool = true
                            }
                            
                            func showAlert(title: String, message: String, primaryAlertAction: AlertAction, secondaryAlertAction: AlertAction) {
                                alertTranslator.alertTitle.string = title
                                alertTranslator.alertMessage.string = message
                                alertTranslator.primaryAlertAction.alertAction = primaryAlertAction
                                alertTranslator.secondaryAlertAction.alertAction = secondaryAlertAction
                                alertTranslator.isAlertPresented.bool = true
                            }
                        }
                        """
                    )
                ]),
                Page([.text("That's a lot, but it's written once and we never have to think about it. To use it, the evaluator just asks the translator to show an alert:"),
                      .extraSmallCode(
                        """
                        translator.showAlert(
                            title: "Alert!",
                            message: "You did it."
                        )
                        """
                    )]),
                Page([.text("The only code we added to our Translator was a declaration of conformance:"),
                      .extraSmallCode("class Translator: AlertTranslating {"),
                      .text("And a property to hold the AlertTranslator:"),
                      .extraSmallCode("var alertTranslator = AlertTranslator()")
                ]),
                Page([.text("And we added a single line to our view layer, inside a Group nested in a top-level ZStack:"),
                      .extraSmallCode("AlertView(translator: translator)"),
                ]),
                Page([.text("It's never been so easy to write alerts that are responsibly decoupled from the view layer. Remember, when the evaluator asks for an alert, it can set any method it likes inside an alert action. The round trip back to the evaluator is all in one place.")]),
                Page([.text("We can also make light work of bezels, action sheets, or anything else we'd like to trigger imperatively. Tap “Show Bezel” to see a bezel with a random emoji.")],
                     action: .showBezel,
                     supplement: [
                    .code(
                        """
                        import Combine
                        import SwiftUI

                        protocol CharacterBezelTranslating {
                            var characterBezelTranslator: CharacterBezelTranslator { get }
                            func showBezel(character: String)
                        }

                        extension CharacterBezelTranslating {
                            func showBezel(character: String) {
                                characterBezelTranslator.character.string = character
                            }
                        }

                        struct CharacterBezelTranslator {
                            var character = PassableString()
                        }

                        struct CharacterBezelView: View {
                            
                            @State private var character: String = ""
                            @State private var opacity: Double = 0
                            
                            private var passableCharacter: PassableString
                            
                            init(translator: CharacterBezelTranslating) {
                                self.passableCharacter = translator.characterBezelTranslator.character
                            }
                            
                            enum Layout {
                                static var fullOpacity = 1.0
                                static var zeroOpacity = 0.0
                                static var fadeInDuration = 0.125
                                static var fadeOutWaitInMilliseconds = Int(fadeInDuration * 1000.0) + 500
                                static var fadeOutDuration = 0.7
                                
                                static var verticalPadding: CGFloat = 30
                                static var horizontalPadding: CGFloat = 38
                                static var characterFontSize: CGFloat = 128
                                static var bezelCornerRadius: CGFloat = 10
                                static var bezelBlurRadius: CGFloat = 12
                            }
                            
                            var body: some View {
                                VStack {
                                    VStack {
                                        Text(character)
                                            .font(Font.system(size: Layout.characterFontSize))
                                            .padding(EdgeInsets(
                                                top: Layout.verticalPadding,
                                                leading: Layout.horizontalPadding,
                                                bottom: Layout.verticalPadding,
                                                trailing: Layout.horizontalPadding))
                                    }
                                    .background(
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                .fill(Color(UIColor.systemBackground).opacity(0.95))
                                                .padding(10)
                                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                .fill(Color.primary.opacity(0.12))
                                                .padding(10)
                                            .mask(
                                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                    .padding(10)
                                                    .opacity(0.95)
                                            )
                                        }
                                        
                                    )
                                }
                                .opacity(opacity)
                                    .onReceive(passableCharacter.subject) { (newValue) in
                                        if let newValue = newValue {
                                            self.character = newValue
                                            withAnimation(.linear(duration: Layout.fadeInDuration)) {
                                                self.opacity = Layout.fullOpacity
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now().advanced(by: .milliseconds(Layout.fadeOutWaitInMilliseconds))) {
                                                withAnimation(.linear(duration: Layout.fadeOutDuration)) {
                                                    self.opacity = Layout.zeroOpacity
                                                }
                                            }
                                        }
                                }
                                .allowsHitTesting(false)
                            }
                        }
                        """
                        )
                ]),
                Page([.text("That's enough of that. As promised, we can move on now to some example screens, each a little more complex than the last, to illustrate the Poet pattern in full. How about a simple template to start?")])
            ),
            
            Chapter("Template", pages:
                Page([.text("If you tap “Show Template,” you'll see a screen that does almost nothing: it just shows some text set by an evaluator. Let's quickly look at the code for each layer.")], action: .showTemplate),
                Page([.text("The evaluator has only two steps:"),
                      .extraSmallCode(
                        """
                        case loading
                        case text(TextStepConfiguration)
                        """),
                      .text("Loading is just an empty step before the view has appeared.")], action: .showTemplate),
                Page([.text("When the view appears, the evaluator shows the text step:"),
                .extraSmallCode(
                    """
                    func viewDidAppear() {
                        showTextStep()
                    }

                    func showTextStep() {
                      let configuration =
                      TextStepConfiguration(title: ...)
                      current.step = .text(configuration)
                    }
                    """),
                ], action: .showTemplate,
                   supplement: [
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
                            case text(TextStepConfiguration)
                        }
                        
                        // Configurations
                        struct TextStepConfiguration {
                            var title: String
                            var body: String
                        }
                    }

                    // View Cycle
                    extension Template.Evaluator: ViewCycleEvaluator {
                        
                        func viewDidAppear() {
                            showTextStep()
                        }
                    }

                    // Advancing Between Steps
                    extension Template.Evaluator {
                        func showTextStep() {
                            let configuration = TextStepConfiguration(
                                title: "Template",
                                body: "You're looking at a screen made with a simple template, located in Template-Screen.swift.\\n\\nUse this template as the basis for new screens, or read through its code to get a better sense of the Poet pattern."
                            )
                            current.step = .text(configuration)
                        }
                    }
                    """
                )]),
                
                Page([.text("The translator then sets an observable title and body:"),
                .extraSmallCode(
                    """
                    func translateTextStep(
                      _ configuration:
                      Evaluator.TextStepConfiguration) {
                        title.string = configuration.title
                        body.string = configuration.body
                    }
                    """
                )], action: .showTemplate,
                    supplement: [
                    .code(
                        """
                        import Foundation

                        extension Template {

                            class Translator {
                                
                                typealias Evaluator = Template.Evaluator
                                
                                // Observable Display State
                                var title = ObservableString()
                                var body = ObservableString()
                                
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
                                    
                                case .text(let configuration):
                                    translateTextStep(configuration)
                                }
                            }
                            
                            func translateLoadingStep() {
                                // nothing to see here
                            }
                            
                            func translateTextStep(_ configuration: Evaluator.TextStepConfiguration) {
                                // Set observable display state
                                title.string = configuration.title
                                body.string = configuration.body
                            }
                        }
                        """
                    )
                ]),
                
                Page([
                    .text("And the view layer observes the title and body:"),
                    .extraSmallCode(
                        """
                        VStack {
                          ObservingTextView(translator.title)
                          ObservingTextView(translator.body)
                        }
                        """
                    )
                ], action: .showTemplate,
                   supplement: [
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
                                                .font(Font.headline)
                                                .fixedSize(horizontal: false, vertical: true)

                                            ObservingTextView(translator.body)
                                                .font(Font.body)
                                                .fixedSize(horizontal: false, vertical: true)
                                                .padding(EdgeInsets(top: 30, leading: 50, bottom: 50, trailing: 50))
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
                
                Page([.text("That's it. You can use the template whenever you start a new screen. If you understand its flow, you should be able to follow the flow of more complicated screens, too. Let's look at one we'll call Hello World.")])
            ),
            
            Chapter("Hello World", pages:
                Page([.text("Tap the button that says “Show Hello World” to see another new screen. Play around for a bit and come back when you're done.")], action: .showHelloWorld),
                Page([.text("The Hello World example demonstrates how a good pattern actually simplifies our logic even as the problem grows more complex. Our Evaluator does most of its thinking using two types:"),
                      .smallCode("CelestialBody\nCelestialBodyStepConfiguration")], action: .showHelloWorld),
                Page([.text("In viewDidAppear(), we map instances of CelestialBody from JSON data. We then make a step configuration to store that data and select the first CelestialBody as our “currentCelestialBody.”")], action: .showHelloWorld),
                Page([.text("The evaluator only thinks about three things: what are all the celestial bodies? Which one is currently showing? And which image is currently showing for that body?")], action: .showHelloWorld),
                Page([.text("As our screens get more complex, display state gets more interesting. Our translator interprets the business state by doing some rote extraction (names, images), but also by creating an array of tabs to show on screen.")], action: .showHelloWorld),
                
                Page([.text("Each tab is just a ButtonAction, which on this screen conforms to a protocol promising an icon and ID for each action:"),
                  .extraSmallCode(
                    """
                    tabs.array =
                     configuration.celestialBodies.map {
                      ButtonAction.showCelestialBody($0) }
                    """
                )], action: .showHelloWorld),
                
                Page([.text("Whichever body is designated as the currentCelestialBody will inform which tab is selected:"),
                      .extraSmallCode(
                        """
                        currentTab.object =
                         ButtonAction.showCelestialBody(
                          configuration.currentCelestialBody)
                        """
                    )], action: .showHelloWorld),
                
                Page([.text("These are only slight transformations, but they justify the translator as a separate layer. Our business and display logic are cleanly separated and we don't repeat ourselves.")], action: .showHelloWorld),
                Page([.text("Such a clean division between evaluator and translator is possible because the view layer does its part, too.")], action: .showHelloWorld),
                
                Page([.text("The screen features a custom view that observes the translator's tabs and creates a CircularTabButton for each one:"),
                      .extraSmallCode(
                        """
                        ForEach(self.tabs.array, id: \\.id) {
                          tab in
                          CircularTabButton(
                            evaluator:self.evaluator, tab: tab
                          )
                        }
                        """
                    )],
                     action: .showHelloWorld,
                     supplement: [.code(
                        
                    """
                    struct CircularTabBar: View {
                        typealias TabButtonAction = EvaluatorActionWithIconAndID
                        
                        weak var evaluator: ButtonEvaluator?
                        @ObservedObject var tabs: ObservableArray<TabButtonAction>
                        @ObservedObject var currentTab: Observable<TabButtonAction?>
                        let spacing: CGFloat = 30
                        
                        var body: some View {
                            ZStack {
                                HStack(spacing: spacing) {
                                    // MARK: World Button
                                    ForEach(self.tabs.array, id: \\.id) { tab in
                                        CircularTabButton(evaluator: self.evaluator, tab: tab)
                                    }
                                }.overlay(
                                    GeometryReader() { geometry in
                                        Capsule()
                                            .fill(Color.primary.opacity(0.06))
                                            .frame(width: geometry.size.width / CGFloat(self.tabs.array.count), height: 48)
                                            .opacity(self.indexOfCurrentTab() != nil ? 1 : 0)
                                            .offset(x: {
                                                let divided = CGFloat((geometry.size.width + self.spacing) / CGFloat(self.tabs.array.count))
                                                return divided * CGFloat(self.indexOfCurrentTab() ?? 0) + (self.spacing / 2.0) - (geometry.size.width / 2.0)
                                            }(), y: 0)
                                            .allowsHitTesting(false)
                                    }
                                )
                            }
                        }
                        
                        func indexOfCurrentTab() -> Int? {
                            if let currentTabObject = currentTab.object {
                                return self.tabs.array.firstIndex { tab in
                                    tab.id == currentTabObject.id
                                }
                            }
                            return nil
                        }
                        
                        struct CircularTabButton: View {
                            weak var evaluator: ButtonEvaluator?
                            let tab: TabButtonAction
                            var body: some View {
                                Button(action: { self.evaluator?.buttonTapped(action: self.tab) }) {
                                    Image(self.tab.icon)
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                }
                            }
                        }
                    }
                    """)]
                ),
                    
                Page([.text("The CircularTabBar also figures out which tab button should be highlighted, based on the currentTab it observes. It calculates the offset of the highlight to match the correct tab's location.")], action: .showHelloWorld),
                
                Page([.text("So the view is smart about view logic but unopinionated about its content, which is determined by display state.")], action: .showHelloWorld),
                
                Page([.text("This makes it easy for the translator to animate its changes:"),
                      .extraSmallCode(
                        """
                        withAnimation(
                        .spring(response: 0.45,
                                dampingFraction: 0.65,
                                blendDuration: 0)) {
                          currentTab.object =
                           ButtonAction.showCelestialBody(
                           configuration.currentCelestialBody)
                        }
                        """
                    )],
                     action: .showHelloWorld,
                     supplement: [
                        .code(
                            """
                            func translateCelestialBodyStep(_ configuration: Evaluator.CelestialBodyStepConfiguration) {
                                // Set observable display state
                                title.string = "Hello \\(configuration.currentCelestialBody.name)!"
                                imageName.string = configuration.currentCelestialBody.images[configuration.currentImageIndex]
                                foregroundColor.object = configuration.currentCelestialBody.foreground.color
                                backgroundColor.object = configuration.currentCelestialBody.background.color
                                tapAction.object = configuration.tapAction
                                tabs.array = configuration.celestialBodies.map { ButtonAction.showCelestialBody($0) }
                                withAnimation(.linear) {
                                    shouldShowTapMe.bool = configuration.tapAction != nil
                                }
                                withAnimation(.spring(response: 0.45, dampingFraction: 0.65, blendDuration: 0)) {
                                    currentTab.object = ButtonAction.showCelestialBody(configuration.currentCelestialBody)
                                }
                            }
                            """
                        )
                    ]
                ),
                
                Page([.text("The end result is a well-organized screen that is flexible enough to show whatever the JSON prescribes, with clearly defined state to manage the user interaction. Now let's move on to something more complex.")])
            ),
            
            Chapter("Retail Demo", pages:
                Page([.text("")], action: .showRetailDemo)
            )
            
        ]
    }
}
