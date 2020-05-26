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
        typealias Supplement = Evaluator.Page.Supplement
        
        static let shared = PageStore()
        
        lazy var pageData: [Chapter] = [
            Chapter("Introduction", pages:
                Page([.text("You're looking at a screen made with the Poet pattern. The code behind it emphasizes clarity, certainty, flexibility, and reusability.")]),
                Page([.text("The process of writing Poet code is methodical but relatively quick. It follows the philosophy that a pattern “should be made as simple as possible, but no simpler.”")]),
                Page([.text("Poet has a rote structure but it frees you to write with confidence, without fearing that your code will get tangled up over time."),
                      .text("It achieves this through the effective decoupling of business state, display state, and view logic.")]),
                Page([.text("We'll learn about the pattern and its benefits by thinking about how some different screens were made. But first, why is it called Poet?")])
            ),
            
            Chapter("Why Poet?", pages:
                Page([.text("Poet is an acronym that stands for Passable Observable Evaluator/Translator. The evaluator and translator are a pair that work together. Passing and Observing are the two main techniques that guide their work.")]),
                Page([.text("You can think of the evaluator and translator as two different layers in the pattern, or as two different phases of reasoning that the programmer will undertake.")]),
                Page([.text("The evaluator is the business logic decision-maker. It maintains what we might call “business state.”"),
                      .text("The translator interprets the business state of the evaluator and turns it into observable “display state.”"),
                      .text("And the view layer — a screen made up of SwiftUI View structs — is the part that observes the translator's display state.")]),
                Page([.text("A given user flow requires participation from all three layers — evaluator, translator, and view. Sometimes we need to be deliberate about each layer and spell out their work step by step."),
                      .text("Other times, we already know what each layer should do, and protocol-oriented programming can bridge them all with default protocol implementations.")]),
                Page([.text("There's one more feature of the Poet pattern that's pretty fundamental: “steps.” The evaluator's business state is always encapsulated in a single step, a distinct unit of state. We'll talk a lot more about that soon.")]),
                Page([.text("That's enough of a high-level overview. We'll jump into the pattern by looking at a basic template.")])
                ),
            
            Chapter("Template",
                    files: [
                        "Template-Evaluator",
                        "Template-Translator",
                        "Template-Screen",
                        "ObservableString",
                        "ObservingTextView",
                        "PassableStep",
                ],
                    pages:
                Page([.text("If you tap the button that says “Show Template,” you'll see a screen that does almost nothing: it just shows a title and a body of text. We could accomplish this without any pattern at all, just a view. But we'll prepare ourselves to understand more complex screens by using an evaluator and translator here, too.")
                    ],
                     action: .showTemplate
                ),
                    
                Page([.text("Our goal is to show a title and some body text, so our evaluator only has one job: define some business state that contains our title and body."),
                      .text("The evaluator won't do anything without being nudged by the view layer. It begins with an empty initial state and then responds to prompts from the view layer by creating and holding onto new state. At a high level, that's all an evaluator will ever do."),
                    ],
                     action: .showTemplate
                ),
                
                Page([.text("The state of an evaluator always resides within a type called a Step. All the possible state for the Template evaluator is contained within two steps:"),
                      .code(
                      """
                      enum Step: EvaluatorStep {
                          case initial
                          case text(TextStepConfiguration)
                      }
                      """),
                      .text("You'll notice that the .initial step has no associated values, whereas the .text step knows about a configuration particular to it."),
                    ],
                     action: .showTemplate,
                     file: "Template-Evaluator"
                ),
                
                Page([.text("The TextStepConfiguration exists to contain the values we care about, our title and body. And that's all it contains:"),
                      .code(
                      """
                      struct TextStepConfiguration {
                          var title: String
                          var body: String
                      }
                      """),
                      .text("As long as our current step is .initial, we don't care about these values. It's only when we create our .text step that we set the values for its configuration."),
                    ],
                     action: .showTemplate,
                     file: "Template-Evaluator"
                ),
                
                Page([.text("Our evaluator has promised to notice the moment our view comes on screen by conforming to ViewCycleEvaluating:"),
                      .code(
                        """
                        protocol ViewCycleEvaluating {
                            func viewDidAppear()
                        }
                        """),
                      .text("That's when we'll ask to show the .text step:"),
                      .code(
                        """
                        func viewDidAppear() {
                            showTextStep()
                        }
                        """
                        ),
                    ],
                     action: .showTemplate,
                     file: "Template-Evaluator"
                ),
                
                Page([
                    .text("The implementation of showTextStep is as straightforward as you might hope. We create a configuration and assign a .text step that contains it:"),
                    .smallCode(
                        """
                        func showTextStep() {
                          let configuration = TextStepConfiguration(
                            title: "Template",
                            body: "..."
                          )
                          current.step = .text(configuration)
                        }
                        """)
                    ],
                     action: .showTemplate,
                     file: "Template-Evaluator"
                ),
                
                Page([.text("There's more to say about that assignment to current.step."),
                      .text("But what led to viewDidAppear being called in the first place? SwiftUI gives us an onAppear method for our views, so we've used that method to talk to the evaluator from the view layer:"),
                      .code(
                        """
                        .onAppear {
                            self.evaluator?.viewDidAppear()
                        }
                        """)
                    ],
                     action: .showTemplate,
                     file: "Template-Screen"
               ),
                
                Page(
                    [.text("Back to showTextStep. This syntax might have been a little unexpected:"),
                     .code("current.step = .text(configuration)"),
                     .text("It works because the evaluator wraps its step inside a special type, PassableStep:"),
                     .code("var current = PassableStep(Step.initial)"),
                     .text("The Combine framework makes it fairly easy to publish and listen to values, but PassableStep offers a helpful wrapper around that functionality."),
                    ],
                    action: .showTemplate,
                    file: "PassableStep"
                ),
                
                Page(
                    [.text("Whenever it's time to assign a new current step, we don't replace the entire PassableStep object, which we've named “current.” Instead, we assign to the value it contains:"),
                     .code("current.step = ..."),
                     .text("That way, our wrapper persists and publishes its new value.")
                    ],
                    action: .showTemplate
                ),
                
                Page(
                    [.text("Under the hood, the publishing happens because of a property observer inside PassableStep:"),
                     .code(
                        """
                        var step: S {
                            willSet {
                                subject.send(newValue)
                            }
                        }
                        """),
                    ],
                    action: .showTemplate,
                    file: "PassableStep"
                ),
                
                Page(
                    [.text("Why are we publishing the step? The evaluator isn't the only thing interested in its own state. Another layer, the translator, will respond every time a new step is assigned."),
                     .text("Its role will be to interpret the business state and turn it into display state.")
                    ],
                    action: .showTemplate
                ),
                
                Page([
                    .text("The translator can pay attention to the step because, upon its initialization, it created a “sink” (another Combine concept) that receives new values and acts on them:"),
                    .code(
                        """
                        init(_ step: PassableStep<Evaluator.Step>) {
                          behavior = step.subject.sink { value in
                            self.translate(step: value)
                          }
                        }
                        """),
                    ],
                     action: .showTemplate,
                     file: "Template-Translator"
                ),
                
                Page([
                    .text("You'll notice that the evaluator doesn't say anything to the translator directly. The translator just hears about the changes because of its sink.")
                    ],
                     action: .showTemplate
                ),
                
                Page([
                    .text("The evaluator does know the translator, though. It created it, after all, and holds onto it strongly:"),
                    .code(
                        """
                        lazy var translator: Translator = Translator(current)
                        """),
                    .text("In later examples, you'll see the evaluator talk to the translator imperatively using that property. But in illustrating the basic flow here, we need never access it.")
                    ],
                     action: .showTemplate,
                     file: "Template-Evaluator"
                ),
                
                Page([
                    .text("Once the translator receives a new step, it unwraps the step configuration and redirects into another method to translate it. Notice we don't need to translate the empty initial step:"),
                    .code(
                        """
                        func translate(step: Evaluator.Step) {
                            switch step {
                            case .initial:
                                break // no initial setup needed
                            case .text(let configuration):
                                translateTextStep(configuration)
                            }
                        }
                        """),
                    ],
                     action: .showTemplate,
                     file: "Template-Translator"
                ),
                
                Page([
                    .text("And now we face the work of creating display state. It turns out that's just a matter of assigning basic value types like strings, integers, bools, and arrays. Occasionally, we also choose an animation."),
                    .text("Our view layer will observe these values and respond according to its own logic.")
                    ],
                     action: .showTemplate
                ),
                
                Page([
                    .text("The Template translator holds onto two properties that make up its entire display state:"),
                    .code(
                        """
                        var title = ObservableString()
                        var body = ObservableString()
                        """
                    ),
                    .text("The title and body aren't simple strings. They are a special wrapping type called ObservableString."),
                    ],
                     action: .showTemplate
                ),
                
                Page([
                    .text("Observable types conform to Combine's ObservableObject protocol and contain a value that has been complemented with the @Published property wrapper, which creates a publisher. Inside ObservableString, for instance, we see:"),
                    .code(
                        """
                        @Published var string: String
                        """
                    ),
                    .text("Because our translator holds onto two ObservableStrings, our view layer will be able to respond whenever their wrapped values change."),
                    ],
                     action: .showTemplate,
                     file: "ObservableString"
                ),
                
                Page([
                    .text("We translate our step by assigning to those two observable strings:"),
                    .code(
                        """
                        func translateTextStep(_ configuration:
                          Evaluator.TextStepConfiguration) {
                            title.string = configuration.title
                            body.string = configuration.body
                        }
                        """
                    ),
                    .text("We're just mapping our step's configuration values to observable values."),
                    ],
                     action: .showTemplate,
                     file: "Template-Translator"
                ),
                
                Page([
                    .text("Because of that very slight translation effort, the view layer can now observe the title and body:"),
                    .code(
                        """
                        VStack {
                            ObservingTextView(translator.title)
                            ObservingTextView(translator.body)
                        }
                        """),
                    ],
                     action: .showTemplate,
                     file: "Template-Screen"
                ),
                
                Page([
                    .text("ObservingTextView is a view that holds onto an ObservableString as an @ObservedObject. It responds to changes automatically:"),
                    .code(
                        """
                        @ObservedObject var text: ObservableString

                        var body: some View {
                            Text(text.string)
                        }
                        """)
                    ],
                     action: .showTemplate,
                     file: "ObservingTextView"
                ),
                
                Page([
                    .text("A view like ObservingTextView contains view logic — the rules for how it should respond to changes in display state. It's aware of a general observable type (in this case ObservableString), but it's unaware of any particular business purpose. Our layers are fully decoupled, which makes this view (and potentially any other) reusable throughout the app for different purposes."),
                    ],
                     action: .showTemplate
                ),
                
                Page([
                    .text("And that's it. We've followed the whole round trip of the pattern, starting with the view's onAppear method and passing through the evaluator, the translator, and then back to the view layer.")
                    ],
                     action: .showTemplate
                ),
                
                Page([
                    .text("On a screen that only shows text, the three layers are excessive. The translator merely extracted the step's values without applying any new logic. Display state exactly mirrored business state."),
                    
                    .text("But the moment we make our display state more dynamic, or use one property of business state to modify several properties of display state (or the converse: several to one), the evaluator/translator split justifies itself.")
                    ],
                     action: .showTemplate
                ),
                
                Page([
                    .text("If you have understood the flow here, you should be able to follow the flow of more complicated screens, too. Speaking of which, let's make things a tiny bit more complicated by thinking about user interaction.")
                    ],
                     action: .showTemplate
                )
            ),
            
            Chapter("Interacting with a View",
                    files: [
                        "ButtonEvaluating",
                        "ObservingButton"
                    ],
                    pages:
                Page([.text("With few exceptions, whenever you interact with a view on screen, the view tells its evaluator about it."),
                      .text("When you tap a button, for instance, the view might say to its evaluator:"),
                      .code(
                          """
                          self.evaluator?.buttonTapped(action:
                            ButtonAction.doSomething)
                          """
                      ),
                      .text("In that case, “doSomething” is the name of a specific action.")
                ]),
                
                Page([
                    .text("To be more precise, .doSomething would be an enum case that lives on the evaluator, along with all the other button actions relevant to its screen:"),
                    .code(
                    """
                    enum ButtonAction: EvaluatorAction {
                        case doSomething
                        // etc.
                    }
                    """
                    )
                ]),
                
                Page([
                    .text("Any button that wants to evaluate a user tap can do so without knowing who its real evaluator is, only that it will conform to the protocol ButtonEvaluating:"),
                    .code(
                        """
                        protocol ButtonEvaluating: class {
                          func buttonTapped(
                            action: EvaluatorAction?)
                        }
                        """
                    )
                ],
                     file: "ButtonEvaluating"
                ),
                
                Page([
                    .text("In this way, our view layer can be fully decoupled from particular business purposes."),
                    .text("A button can be decoupled even further — not just from the evaluator that handles its action, but from the choice of which action it carries. Because ButtonEvaluating only knows actions as a general type, EvaluatorAction, we can inject a button with whatever action we like.")
                ]),
                
                Page([
                    .text("To do that, we could use an ObservingButton, for instance, which observes an EvaluatorAction:"),
                    .code(
                        """
                        @ObservedObject var action:
                          Observable<EvaluatorAction?>
                        """
                    ),
                ],
                     file: "ObservingButton"
                ),
                
                Page([
                    .text("An ObservingButton takes any label we give it, thanks to an initializer that accepts a ViewBuilder closure:"),
                    .code(
                        """
                        @ViewBuilder label: @escaping () -> Label
                        """
                    ),
                    .text("If we wanted, we could make that button's label observe a value, too, using an ObservingTextView (which we've already seen)."),
                    
                ],
                     file: "ObservingButton"
                ),
                
                Page([.text("With all of these choices available to us, a button can be decoupled in every meaningful way from the dynamic choices we might make when setting business and display state."),
                    .text("Upon receiving an action in the evaluator, we would embark on the regular flow of the pattern: the evaluator reasons about business state, the translator creates display state, and the view layer responds.")]),
                
                Page([.text("Let's see what that looks like with a real example.")])
                ),
                
            Chapter("Business State (In Progress)",
                    files: [
                        "SayHelloWorld-Evaluator"
                    ],
                pages:
                
                Page([.text("A cleanly separated business state doesn't mean much to us unless we can update it. If you tap the button that says “Show Hello World,” you'll see a screen that includes some basic user interaction and some very minimal updates to business state.")],
                     action: .showHelloWorld
                ),
                
                Page([.text("In its structure, Hello World isn't too different from the Template we've already seen. Its evaluator includes one step (besides initial) named “sayStuff” and two ButtonActions named “sayHello” and “sayNothing.”")],
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
                ], supplement: Supplement(shortTitle: "buttonTapped()", fullTitle: "", body:[
                .code(
                    """
                    extension Tutorial.Evaluator: ButtonEvaluating {
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
            ),
            
            // Hello Solar System example -- add performer
            

            
            /*
            // Translating
            Chapter("Translating", pages:
                
                Page([
                    .text("The work of the translator is straightforward. For any given state in the evaluator, the translator must turn it into display state — should I show something? What should it say? Does it animate? — in a reliable, deterministic manner."),
                ]),
                    
                Page([
                    .text("It does this by calling the translate(:) method on itself whenever it notices that the evaluator's current step has been modified:"),
                    .code("self.translate(step: value)"),
                    .text("That method expects a Step declared on the evaluator."),
                ]),
                    
                Page([
                    .text("In the translate method, the translator just gathers the step's configuration and calls a corresponding method:"),
                    .code(
                        """
                        func translate(step: Evaluator.Step) {
                          switch step {
                          case .page(let configuration):
                            translatePageStep(configuration)
                          // …
                        """
                    )
                ], supplement: Supplement(shortTitle: "translate()", fullTitle: "", body: [
                    .code(
                        """
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
                        """
                    )])
                ),
                
                Page([
                    .text("And now we face the work of creating display state. It turns out that's just a matter of assigning basic value types like strings, integers, bools, and arrays. Occasionally, we also choose an animation.")
                ]),
                
                Page([
                    .text("For instance, here are a few strings and integers we will set, which correspond to things we see on screen:"),
                    .code(
                        """
                        var mainTitle = ObservableString()
                        var chapterNumber = ObservableInt()
                        var chapterTitle = ObservableString()
                        var pageXofX = ObservableString()
                        """
                    )
                ]),
                
                Page([
                    .text("You'll notice something: they are all an “observable” type. Observable types are just convenient wrappers around published value types. They tuck away the slight complexity of publishing.")
                ]),
                
                Page([
                    .text("ObservableString, for instance, looks like this:"),
                    .smallCode(
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
                    .code(
                        """
                        var mainTitle = ObservableString()
                        var chapterNumber = ObservableInt()
                        // etc.
                        """
                    ),
                    .text("Each of these will be observed by a view on screen."),
                ]),
                
                Page([
                    .text("The job of the translator is to set all these observable properties coherently, so that the view layer can make the correct choices, according to its own view logic.")
                ]),
                
                Page([
                    .text("Fortunately, because our evaluator holds onto its state as a coherent step, the translator can think about each step independently of the others. As long as every property is set correctly for a given step, we have done our job to a T.")
                ]),
                
                
                Page([
                    .text("We have an “interlude” step, for example, in which we want everything on screen to go away. To translate that step, we just say no to everything:"),
                    .code(
                        """
                        shouldShowChapterNumber.bool = false
                        shouldShowChapterTitle.bool = false
                        shouldShowBody.bool = false
                        shouldShowTapMe.bool = false
                        """
                    )
                ], supplement: Supplement(shortTitle: "translateInterlude()", fullTitle: "", body: [
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
                ])),
                
                Page([
                    .text("When we translate the “page” step, we say yes to some of those things:"),
                    .code(
                        """
                        shouldShowChapterNumber.bool = true
                        shouldShowChapterTitle.bool = true
                        shouldShowBody.bool = true
                        """
                    )
                ]),
                
                Page([
                    .text("We're a little more clever about the “Tap Me” text:"),
                    .code(
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
                ], supplement: Supplement(shortTitle: "translatePageStep()", fullTitle: "", body: [
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
                ])),
                
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
            */
            
            // Add a performer to this example
            
            Chapter("Business State, Part 2 (In Progress)", pages:
                Page([.text("In this chapter, we build on familiar concepts and run through a quick example of an evaluator/translator/screen working together in a new scenario."),
                      .text("Tap the button that says “Show Hello Solar System” to see a new screen. Play around for a bit and come back when you're done.")
                ],
                     action: .showHelloSolarSystem),
                Page([.text("The Hello Solar System example demonstrates how a good pattern actually simplifies our logic even as the problem grows more complex. Our Evaluator does most of its thinking using two types:"),
                      .smallCode("CelestialBody\nCelestialBodyStepConfiguration")], action: .showHelloSolarSystem),
                Page([.text("In viewDidAppear(), we map instances of CelestialBody from JSON data. We then make a step configuration to store that data and select the first CelestialBody as our “currentCelestialBody.”")], action: .showHelloSolarSystem),
                Page([.text("The evaluator only thinks about three things: what are all the celestial bodies? Which one is currently showing? And which image is currently showing for that body?")], action: .showHelloSolarSystem),
                Page([.text("As our screens get more complex, display state gets more interesting. Our translator interprets the business state by doing some rote extraction (names, images), but also by creating an array of tabs to show on screen.")], action: .showHelloSolarSystem),
                
                Page([.text("Each tab is just a ButtonAction, which on this screen conforms to a protocol promising an icon and ID for each action:"),
                  .extraSmallCode(
                    """
                    tabs.array =
                     configuration.celestialBodies.map {
                      ButtonAction.showCelestialBody($0) }
                    """
                )], action: .showHelloSolarSystem),
                
                Page([.text("Whichever body is designated as the currentCelestialBody will inform which tab is selected:"),
                      .extraSmallCode(
                        """
                        currentTab.object =
                         ButtonAction.showCelestialBody(
                          configuration.currentCelestialBody)
                        """
                    )], action: .showHelloSolarSystem),
                
                Page([.text("These are only slight transformations, but they justify the translator as a separate layer. Our business and display logic are cleanly separated and we don't repeat ourselves.")], action: .showHelloSolarSystem),
                Page([.text("Such a clean division between evaluator and translator is possible because the view layer does its part, too.")], action: .showHelloSolarSystem),
                
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
                     action: .showHelloSolarSystem,
                     supplement: Supplement(shortTitle: "CircularTabBar", fullTitle: "", body: [.code(
                        
                    """
                    struct CircularTabBar: View {
                        typealias TabButtonAction = EvaluatorActionWithIconAndID
                        
                        weak var evaluator: ButtonEvaluating?
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
                            weak var evaluator: ButtonEvaluating?
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
                    """)])
                ),
                    
                Page([.text("The CircularTabBar also figures out which tab button should be highlighted, based on the currentTab it observes. It calculates the offset of the highlight to match the correct tab's location.")], action: .showHelloSolarSystem),
                
                Page([.text("So the view is smart about view logic but unopinionated about its content, which is determined by business and display state.")], action: .showHelloSolarSystem),
                
                Page([.text("This separation of concerns makes it easy for the translator to animate its changes:"),
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
                     action: .showHelloSolarSystem,
                     supplement: Supplement(shortTitle: "translateCelestialBodyStep", fullTitle: "", body: [
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
                    ])
                ),
                
                Page([.text("The end result is a well-organized screen that is flexible enough to show whatever the JSON prescribes, with clearly defined business state, display state, and view logic. Now let's move on to something more complex.")])
            ),
            
            Chapter("Asynchronous Work (Coming soon)", pages:
                Page([.text("Coming soon...")])
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
                      .code("translator.showSomething.please()")]),
                
                Page([.text("Why talk to the translator directly? We're presenting a modal, and everything on our current screen will remain unchanged underneath the modal. So it would feel superfluous to modify our own business state by changing our current step.")]),
                
                Page([.text("Inside the translator, saying “please” works because we hold onto a PassablePlease object:"),
                      .code(
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
                     .smallCode(
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
                    supplement: Supplement(shortTitle: "Presenter", fullTitle: "", body: [
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
                    ])
                ),
                
                Page([.text("The job of a Presenter is to notice when a new “please” comes through and to toggle its own isShowing property. When that property toggles to true, the sheet will present the content.")]),
                Page([.text("If we had needed to do some more translating before passing our please to the view layer, our evaluator could have called a method directly on the translator, something like this:"),
                      .code("translator.showSomethingScreen()")]),
                Page([.text("The translator then would do whatever extra translating it had in mind before calling please() on its own property.")]),
                Page([.text("And that's how we pass state imperatively. We keep a rigorous separation of our different layers, but we also link them up with minimal code that's easy to follow.")])
            ),
            
            Chapter("Passable State, Part 2 (In Progress)", pages:
                Page([.text("(Coming soon)\n\nThis chapter will cover PresenterWithString and PresenterWithPassableValue.")])
            ),
            
            // Page([.text("Speaking of minimal code, let's look at another technique that saves us from being repetitive as we bridge our different layers: protocol-oriented translating.")])
            
            Chapter("Protocol-Oriented Translating", pages:
                Page([.text("A lot of user interface elements are very predictable but still require a good amount of code to implement: alerts, action sheets, bezels, toasts.")]),
                Page([.text("iOS programmers are used to asking for these things imperatively, but in SwiftUI, we bring them about my modifying our display state.")]),
                Page([.text("That's a little painful to do, and in simple implementations developers often end up coupling specific alerts to the view layer. We can do it better by following a technique we'll call protocol-oriented translating.")]),
                Page([.text("Take this alert, for example. If you tap the button below that says “Show Alert,” you'll see it.")], action: .showAlert),
                Page([.text("Or here's another, with two styled actions. Tap “Show Another Alert” to see it.")], action: .showAnotherAlert),
                Page([.text("The challenge for us is to decouple the content of these alerts from the view layer, so the evaluator can imperatively trigger alerts with whatever content it likes.")]),
                Page([.text("We'll do that by first dividing our responsibilities correctly, then streamlining the process with protocol-oriented default implementations.")]),
                Page([.text("The view layer needs to be smart enough to show any sort of alert, and to observe the values that will inform the alert's contents. We accomplish that with AlertView:"),
                      .code(
                        """
                        struct AlertView: View { ... }
                        """
                    )
                    ],
                     supplement: Supplement(shortTitle: "AlertView", fullTitle: "", body: [
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
                    ])
                     ),
                Page([.text("Next, the translator needs to provide observable values for title, message, and so on.")]),
                Page([.text("We'll bundle those up in a separate AlertTranslator:"),
                      .smallCode(
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
                ], supplement: Supplement(shortTitle: "AlertTranslator", fullTitle: "", body: [
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
                ])),
                Page([.text("Our translator will hold onto that AlertTranslator. But that's as much thinking as we want to do on each screen we implement.")]),
                Page([.text("So we'll make our translator conform to AlertTranslating to give it default implementations of some “showAlert” methods."),
                      .extraSmallCode(
                        """
                        protocol AlertTranslating {
                          var alertTranslator: AlertTranslator { get }
                          func showAlert(title: String, message: String)
                          // ...
                        }
                        """
                    )
                ], supplement: Supplement(shortTitle: "AlertTranslating", fullTitle: "", body: [
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
                ])),
                Page([.text("That's a lot, but it's written once and we never have to think about it. To use it, the evaluator just asks the translator to show an alert:"),
                      .code(
                        """
                        translator.showAlert(
                            title: "Alert!",
                            message: "You did it."
                        )
                        """
                    )]),
                Page([.text("The only code we added to our Translator was a declaration of conformance:"),
                      .smallCode("class Translator: AlertTranslating {"),
                      .text("And a property to hold the AlertTranslator:"),
                      .smallCode("var alertTranslator = AlertTranslator()")
                ]),
                Page([.text("And we added a single line to our view layer, inside a Group nested in a top-level ZStack:"),
                      .code("AlertView(translator: translator)"),
                ]),
                Page([.text("It's never been so easy to write alerts that are responsibly decoupled from the view layer. Remember, when the evaluator asks for an alert, it can set any method it likes inside an alert action. The round trip back to the evaluator is all in one place.")]),
                Page([.text("We can also make light work of bezels, action sheets, or anything else we'd like to trigger imperatively. Tap “Show Bezel” to see a bezel with a random emoji.")],
                     action: .showBezel,
                     supplement: Supplement(shortTitle: "CharacterBezerTranslating", fullTitle: "", body: [
                    .code(
                        """
                        import Combine
                        import SwiftUI

                        protocol BezelTranslating {
                            var bezelTranslator: BezelTranslator { get }
                            func showBezel(text: String)
                        }

                        extension BezelTranslating {
                            func showBezel(text: String) {
                                BezelTranslator.character.string = character
                            }
                        }

                        struct BezelTranslator {
                            var character = PassableString()
                        }

                        struct BezelView: View {
                            
                            @State private var character: String = ""
                            @State private var opacity: Double = 0
                            
                            private var passableCharacter: PassableString
                            
                            init(translator: BezelTranslating) {
                                self.passableCharacter = translator.bezelTranslator.character
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
                ])),
                Page([.text("That's enough of that. As promised, we can move on now to some example screens, each a little more complex than the last, to illustrate the Poet pattern in full. How about a simple template to start?")])
            ),
            
            Chapter("A Note on Combine", pages:
                Page([.text("Compared to some other approaches that use the Combine framework, Poet is a conservative pattern. It favors a clear structure with properly decoupled layers, instead of chaining publishers throughout an implementation and directly assigning values at the end of publisher streams.")]),
                Page([.text("Combine's ability to apply multiple transformations to a stream, creating a single chain of logic from the start of a flow to its end in the view layer, is very powerful. But for many programmers at this early stage in Combine's history, that approach seems likely to encourage tightly coupled business and view logic and to prevent a more flexible relationship between business state and display state.")]),
                Page([.text("As programmers develop their skills at Combine, it will be worth revisiting what approaches can fit well into a fully decoupled, unidirectional pattern. The Performer layer already shows how we can use chaining to transform business state with certainty. Everywhere else, Poet uses ObservableObject and PassthroughSubject comprehensively but relies on its own structure for the transformation of business state into display state.")]),
                Page([.text("The difference in approaches isn't exactly six of one, half a dozen of the other. Often we want to apply several display state transformations in response to a single change in business state, or conversely to take into account several properties of business state in order to change a single property of display state. It's a little difficult to have it both ways unless we do all our thinking in one place.")]),
                Page([.text("Combine could accomplish this by combining several inputs into a single publisher. You could imagine a different pattern where, instead of listening for a new step, an object listens to these agglomerated publishers, which could ultimately deliver multiple values in one fell swoop — a little like a step, but smaller and built with a certain use in mind.")]),
                Page([.text("That could work well enough, but its application could be uneven and a little taxing on the reader: some publishers would promise a single property, while other publishers would deliver a combination. The layer that performs the transformations into display state would be at once dense and scattered, and individual choices would be hard to track down.")]),
                Page([.text("Poet gets ahead of that problem by choosing instead to make steps a first class member of the pattern. The programmer always considers all of a step's transformations within a single method. The cognitive overhead of considering an entire step is minimal, as it improves readability and creates a flexible structure that suits all the transformations we might apply.")]),
                Page([.text("Is there a cost? Yes, a little. Every time a Poet evaluator creates new business state, it must explicitly create a new step configuration. If it moves from one step to another, it will need to explicitly unwrap the old step's configuration and reuse any values needed in the new step's configuration.")]),
                Page([.text("Even in complicated scenarios, that's not so bad. For instance, say we want to enter a certain step from several different steps, each containing a different set of values. We don't want to inspect all those steps individually, and we don't have to. The steps could conform to a protocol which promises the same names for certain properties. Our new step could unwrap the values it needs without caring which previous step they belonged to.")]),
                Page([.text("Depending on the nature of the problem being solved, the inspection of a previous step to make a new one might seem like unnecessary overhead. On complicated screens, however, it helps. The steps create an explicit boundary around possible states, preventing us from inadvertently straddling an incoherent combination of states.")]),
                Page([.text("Whenever we define a full step, we promise to have accounted for all business state. Each time we translate it, we promise to have accounted for all of our display state. If the programmer has made a mistake, it can be easily located and fixed. Poet's steps are not the only viable solution, but they are obvious and easy to reason about.")]),
                Page([.text("In its relatively conservative approach, Poet errs on the side of readable and decoupled code, freeing the developer to think clearly and quickly. Business state is always stored in a single struct. Display state transformations always happen in a single place. The programmer gains speed, certainty, and the ability to create flexible, reusable code that is suprisingly powerful.")])
            ),
            
            Chapter("Retail Demo", pages:
                Page([.text("Imagine you work in retail and your job is to find and deliver products. If you tap “Show Retail Demo” you'll see a screen that offers such a user flow. Try it out.")], action: .showRetailDemo),
                Page([.text("You'll notice the Retail demo is getting close to production-ready code. It shows how we can have a complex, step-based user interface that also seamlessly animates its state changes.")], action: .showRetailDemo),
                Page([.text("Most importantly it shows how we can dynamically create views that observe our translator's content, and show and hide those views depending on our data and the step we're in. ")], action: .showRetailDemo),
                Page([.text("This speeds development by decoupling our layers in all the right ways. We still have fine-grained control over animated transitions, but we don't have to waste effort thinking about all the possible permutations of views on screen.")], action: .showRetailDemo),
                
                Page([.text("We just make our choices on the fly. Here's how we show the “Not Started” step:"),
                      .extraSmallCode(
                        """
                        showSections([
                            topSpace_,
                            customerTitle_,
                            instruction_,
                            divider_,
                            feedback_,
                            displayableProducts_
                        ])
                        """
                    )
                ], action: .showRetailDemo),
                
                Page([.text("This works because of ObservingPageView, a view that observes an array of ObservingPageViewSections. Whenever that array is updated, ObservingPageView creates a view for each section, using a ViewMaker it's also handed.")], action: .showRetailDemo),
                
                Page([.text("In our case the ViewMaker is Retail.ViewMaker, which knows how to make views for cases of Retail.Translator.Section, an enum that conforms to ObservingPageViewSection.")], action: .showRetailDemo),
                
                Page([.text("To allow for the greatest possible dynamism, some of our Retail.Translator.Section cases are handed observable associated types when they are created.")], action: .showRetailDemo),
                
                Page([.text("For instance, the “feedback” section knows what string it should observe:"),
                      .smallCode(
                        """
                        case feedback(
                          feedback: ObservableString)
                        """)
                ], action: .showRetailDemo),
                
                
                Page([.text("Whenever we create that case, we just assign it the “feedback” property:"),
                      .smallCode(
                        """
                        return .feedback(
                            feedback: feedback)
                        """),
                      .text("And that property is just an observable string the Translator holds onto:"),
                      .smallCode(
                        """
                        var feedback = ObservableString()
                        """),
                ], action: .showRetailDemo),
                
                Page([.text("So when we're translating a step, we just need to do two things to see feedback on screen. First, we set our observable string:"),
                      .smallCode(
                      """
                      feedback.string = "The customer
                        has been notified that their
                        order cannot be fulfilled."
                      """),
                ], action: .showRetailDemo),
                
                Page([.text("And second, we ensure that “feedback” is one of the sections we ask to show:"),
                      .smallCode(
                      """
                      showSections([
                          ...
                          feedback_,
                          ...
                      ])
                      """),
                ], action: .showRetailDemo),
        
                Page([.text("showSections(:) is just a method that assigns Section cases to the Translator's sections array, which our ObservingPageView observes."),
                      .smallCode(
                      """
                      func showSections(_ newSections:
                        [Section]) {
                          self.sections.array = newSections
                      }
                      """),
                ], action: .showRetailDemo),
                
                Page([.text("If it looks a little funny that we write “feedback_” with an underscore, that's just the name of a computed property that builds the enum with its observable data:"),
                      .smallCode(
                      """
                      var feedback_: Section {
                        return .feedback(feedback: feedback)
                      }
                      """),
                ], action: .showRetailDemo),
                
                
                Page([.text("In the “Find Products” step, we show the same sections, but we add a FindableProduct to each DisplayableProduct:"),
                      .extraSmallCode(
                        """
                        displayableProducts.array =
                          configuration.findableProducts.map({
                            return DisplayableProduct(
                                product: $0.product,
                                findableProduct: $0
                            )
                        })
                        """
                    )
                ], action: .showRetailDemo),
                
                Page([.text("DisplayableProductsView shows “Found” and ”Not Found” for the FindableProduct:"),
                      .extraSmallCode(
                        """
                        if displayableProduct.findableProduct
                          != nil {
                        FoundNotFoundButtons(findableProduct:
                          displayableProduct.findableProduct!,
                          evaluator: self.evaluator)
                        }
                        """
                    )
                ], action: .showRetailDemo)
                
                
            )
            
        ]
    }
}

/*
 Screen demos to make:
 * a list with an indeterminate number of sections, based on the data pulled down
 * text entry
 */
