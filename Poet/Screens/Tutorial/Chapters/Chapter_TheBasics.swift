//
//  Chapter_Template.swift
//  Poet
//
//  Created by Steve Cotner on 5/26/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

extension Tutorial.PageStore {
    var chapter_TheBasics: Chapter {
        return Chapter(
            "The Basics",
            files: [
                "Template-Screen",
                "Template-Evaluator",
                "Template-Translator",
                "ObservableString",
                "ObservingTextView",
                "PassableState",
                "ViewCycleEvaluating"
            ],
            pages:
            Page([
                .demo(.showTemplate),
                .text("If you tap the button that says “Template,” you'll see a screen that does very little: it just shows a title and a body of text."),
                .text("We have could created such a simple screen without using any pattern at all, just a view. It doesn't involve any business logic, really, and its display state never needs to change. But we'll prepare ourselves to understand more complex screens by using all three of the main Poet layers: evaluator, translator, and screen."),
                
                // MARK: File Structure
                
                .title("File Structure"),
                .text("As it happens, each layer gets its own file. The template's file structure looks like this:"),
                .code(
                """
                Template-Screen.swift
                Template-Evaluator.swift
                Template-Translator.swift
                """),
                .text("You might have noticed the paperclip icon in the upper right of this screen. If you tap that, you'll see a list of all the files mentioned in this chapter, including the template files."),
                
                // MARK: Naming
                
                .title("Naming"),
                .text("The three layers are each scoped under a struct named Template, just to encourage some good structure and naming conventions:"),
                .code(
                """
                struct Template {}

                extension Template {
                    struct Screen: View {
                        ...
                    }
                }

                extension Template {
                    class Evaluator {
                        ...
                    }
                }

                extension Template {
                    class Translator {
                        ...
                    }
                }
                """
                ),
                
                // MARK: Starting Out
                
                .title("Starting Out"),
                .text("The template's screen is its top-level view. It is just like any other view, except that it knows (that is, it holds onto) a specific evaluator and translator concretely."),
                .code(
                    """
                    let evaluator: Evaluator
                    let translator: Translator
                    """
                ),
                .text("We'll talk more about the implications of this choice later in the chapter, in a section called “Retention.”"),
                .text("If we were to write our template from scratch, we could start with the evaluator. Our goal is only to show a title and some body text, so our evaluator would only have one job: define some business state that contains our title and body."),
                .text("The evaluator won't actually do anything without being nudged by the view layer. It begins with an empty initial state and then responds to prompts from the view layer by creating and holding onto new state. At a high level, that's all an evaluator will ever do."),
                
                .divider,
                .text("Take a moment to glance at the evaluator file before we explain it:"),
                .file("Template-Evaluator"),
                
                // MARK: States
                
                .title("States"),
                .text("The state of an evaluator always resides within a type called a State. All the possible state for the template evaluator is contained within two States:"),
                .code(
                """
                enum State: EvaluatorState {
                  case initial
                  case placeholder(PlaceholderState)
                }
                """),
                .text("You'll notice that the initial state has no associated values, whereas the placeholder state knows about a configuration particular to it."),
                .text("The initial state only exists to ensure that we are always in a state. If states were optional, lots of work would be slightly harder to do."),
                .text("The PlaceholderState exists to contain the values we care about, our title and body. And that's all it contains:"),
                .code(
                """
                struct PlaceholderState {
                  var title: String
                  var body: String
                }
                """),
                .text("As long as our current state is initial, we don't care about these values. It's only when we create our placeholder state that we set the values for its configuration. We'll do that when our view appears."),
                
                // MARK: Responding to the view
                .title("Responding to the view"),
                .text("Our evaluator has promised to notice the moment our view comes on screen by conforming to ViewCycleEvaluating:"),
                .code(
                """
                protocol ViewCycleEvaluating {
                    func viewDidAppear()
                }
                """),
                .file("ViewCycleEvaluating"),
                .divider,
                .text("When the view layer calls the viewDidAppear method, the evaluator will ask itself to show the placeholder state:"),
                .code(
                """
                func viewDidAppear() {
                    showPlaceholderState()
                }
                """
                ),
                .text("The implementation of showPlaceholderState is as straightforward as you might hope. We create a placeholder state configuration and bundle it into a placeholder state, which we assign as our current state:"),
                .smallCode(
                  """
                  func showPlaceholderState() {
                    let state = PlaceholderState(
                      title: "Template",
                      body: "You're looking at a screen…"
                    )
                    current.state = .placeholder(state)
                  }
                  """),
                .text("There's more to say about that assignment at the end."),
                .text("But what led to viewDidAppear being called in the first place? SwiftUI gives us an onAppear method for our views, so we've used that method to talk to the evaluator from the view layer:"),
                .code(
                """
                .onAppear {
                    self.evaluator.viewDidAppear()
                }
                """),
                .file("Template-Screen"),
                .space(),
                .text("Whenever the view layer needs to delegate to our business decision-maker, it will look similar to this. The screen itself isn't opinionated about what happens when it appears. Instead, it calls a protocol method the evaluator has promised to answer, which ultimately leads to a change in state."),
                
                // MARK: Passable States
                
                .title("Passable States"),
                .text("Now let's get back to what might have been some unexpected syntax:"),
                .code("current.state = .placeholder(configuration)"),
                .text("We assign to current.state because the evaluator wraps its state inside a special type, PassableState:"),
                .code("var current = PassableState(State.initial)"),
                .text("The Combine framework makes it fairly easy to publish and listen to values, but PassableState offers a helpful wrapper around that functionality."),
                .text("Whenever it's time to assign a new current state, we don't replace the entire PassableState object, which we've named “current.” Instead, we assign to the value it contains:"),
                .code("current.state = ..."),
                .text("That way, our wrapper persists and publishes its new value."),
                .text("Under the hood, the publishing happens because of a property observer inside PassableState:"),
                .code(
                 """
                 var state: S {
                     willSet {
                         subject.send(newValue)
                     }
                 }
                 """),
                .file("PassableState"),
                .space(),
                .text("Why are we publishing the state? The evaluator isn't the only thing interested in its own state. Another layer, the translator, will respond every time a new state is assigned."),
                .text("Its role will be to interpret the business state and turn it into display state."),
                .text("The translator can pay attention to the state because, upon its initialization, it created a “sink” (another Combine concept) that receives new values and acts on them:"),
                .code(
                  """
                  init(_ state: PassableState<Evaluator.State>) {
                    stateSink = state.subject.sink { [weak self] value in
                      self?.translate(state: value)
                    }
                  }
                  """),
                .file("Template-Translator"),
                .space(),
                .text("You'll notice that the evaluator doesn't say anything to the translator directly. The translator just hears about the changes because of its sink."),
                .text("The evaluator does know the translator, though. It created it and holds onto it strongly:"),
                .code(
                  """
                  lazy var translator: Translator = Translator(current)
                  """),
                .text("In later examples, you'll see the evaluator talk to the translator using that property. We do that sometimes to imperatively trigger certain modal behavior, such as showing an alert or a sheet. But here we don't need to tell the translator to do anything. Our use of a passable state, which both the evaluator and translator know about, is all that's needed."),
                
                // MARK: Translating
                
                .title("Translating"),
                .text("Once the translator receives a new state, it unwraps the state configuration and redirects into another method to translate it. Notice we don't need to translate the empty initial state:"),
                .code(
                  """
                  func translate(state: Evaluator.State) {
                      switch state {
                      case .initial:
                          break
                      case .placeholder(let state):
                          translatePlaceholderState(state)
                      }
                  }
                  """),
                .text("And now we face the work of creating display state. It turns out that's just a matter of assigning basic value types like strings, integers, bools, and arrays. Occasionally, we also choose an animation. Our view layer will observe the values we set and will respond according to its own logic."),
                .text("The template translator holds onto two properties that make up its entire display state:"),
                .code(
                    """
                    var title = ObservableString()
                    var body = ObservableString()
                    """
                ),
                .text("Unlike on our evaluator's state, the translator's title and body aren't simple strings. They are a special wrapping type called ObservableString, and the observable aspect of that type is what makes our display state able to affect the view layer."),
                
                // MARK: Observables
                
                .title("Observables"),
                .text("Observable types conform to Combine's ObservableObject protocol and contain a value that has been complemented with the @Published property wrapper, which creates a publisher. Inside ObservableString, for instance, we see:"),
                .code(
                    """
                    @Published var string: String
                    """
                ),
                .file("ObservableString"),
                .space(),
                .text("Because our translator holds onto ObservableStrings, our view layer will be able to respond whenever their wrapped values change."),
                .text("We translate our state by assigning to those two observable strings:"),
                .code(
                    """
                    func translatePlaceholderState(_ state:
                      Evaluator.PlaceholderState) {
                        title.string = state.title
                        body.string = state.body
                    }
                    """
                ),
                .text("We're just mapping our state's configuration values to observable values."),
                .text("Because of that very slight translation effort, the view layer can now observe the title and body."),
                
                // MARK: Observing
                
                .title("Observing"),
                .text("In order for the screen to observe the translator's display state, it needs to hold onto the observable strings as @ObservedObjects. But we won't keep these properties on the screen itself. If we were to do that, the entire screen would be reinitialized every time the observed values changed. Instead, we will pass them into subsequent views which expect the observable type, like ObservingTextView:"),
                .code(
                    """
                    VStack {
                        ObservingTextView(translator.title)
                        ObservingTextView(translator.body)
                    }
                    """),
                .text("ObservingTextView is a view that holds onto an ObservableString as an @ObservedObject. In its body, it plucks the string out of its observable wrapper. And that is enough to make it respond to changes automatically:"),
                .code(
                    """
                    @ObservedObject var text: ObservableString

                    var body: some View {
                        Text(text.string)
                    }
                    """),
                .file("ObservingTextView"),
                .space(),
                .text("A view like ObservingTextView contains view logic — the rules for how it should respond to changes in display state. It's aware of a general observable type (in this case ObservableString), but it's unaware of any particular business purpose. Our layers are fully decoupled, which makes this view (and potentially any other) reusable throughout the app for different purposes."),
                .text("And that's it. We've followed the whole round trip of the pattern, starting with the screen's onAppear method and passing through the evaluator, the translator, and then back to the screen."),
                
                // MARK: Retention
                
                .title("Retention"),
                .text("It's worth making one note about the interrelation between our three layers. Remember that a screen holds onto its evaluator and translator strongly:"),
                .code(
                    """
                    let evaluator: Evaluator
                    let translator: Translator
                    """
                ),
                .text("On initialization, a screen creates its evaluator directly and then grabs its translator off the evaluator (who created it):"),
                .code(
                    """
                    init() {
                        evaluator = Evaluator()
                        translator = evaluator.translator
                    }
                    """
                ),
                .text("The evaluator creates the translator so it can pass its PassableState to its initializer."),
                .text("Within a screen, most subsequent views — the ones the screen creates — don't know a translator at all, and they are always decoupled from the concrete evaluator, knowing it only by a protocol such as ActionEvaluating (more on that in the next chapter). But they are free to hold onto it strongly."),
                .text("In fact, a screen and any of its nested views can hold onto both the evaluator and translator strongly without worrying about a retain cycle. The evaluator and translator will be deinitialized properly when the screen disappears."),
                .text("Because the evaluator and translator are both classes, though, a programmer could create a retain cycle by making the translator hold onto the evaluator. This includes in sinks that listen to publishers, where it is important to use a weak self."),
                .text("If a programmer abides by the following rules, they will avoid a problem:"),
                .bullet("A screen (and any view) can hold onto both a translator and an evaluator strongly. The screen must hold onto the evaluator strongly to keep it in memory. It holds onto the translator so it can observe its display state."),
                .bullet("An evaluator creates its translator and holds onto it strongly, which it must do to keep it in memory. When a screen assigns its own translator, it grabs it off of the evaluator."),
                .bullet("A translator never holds onto an evaluator or a screen."),
                .bullet("A translator always uses weak self when it creates a sink."),

                // MARK: Summary
                
                .title("Summary"),
                .text("On a screen that only shows text, the three layers must seem excessive. Our translator merely extracted the state's values without applying any new logic. Display state exactly mirrored business state."),
                .text("But the moment we make our display state more dynamic, or use one property of business state to modify several properties of display state (or the converse: considering several aspects of business state to inform a single aspect of display state), the evaluator/translator split justifies itself."),
                .text("If you have understood the flow here, you should be able to follow the flow of more complicated screens, too. Speaking of which, let's make things a tiny bit more complicated by thinking about user interaction.")
                ]
            )
        )
    }
}
