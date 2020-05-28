//
//  Chapter_Template.swift
//  Poet
//
//  Created by Steve Cotner on 5/26/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

extension Tutorial.PageStore {
    var chapter_Template: Chapter {
        return Chapter(
            "Template",
            files: [
                "Template-Screen",
                "Template-Evaluator",
                "Template-Translator",
                "ObservableString",
                "ObservingTextView",
                "PassableStep",
            ],
            pages:
            Page([.text("If you tap the button that says “Show Template,” you'll see a screen that does almost nothing: it just shows a title and a body of text. We could accomplish this without any pattern at all, just a view. But we'll prepare ourselves to understand more complex screens by using an evaluator and translator here, too.")
                ],
                 action: .showTemplate
            ),
            
            Page([.text("The Template is created using three files:"),
                  .code(
                    """
                    Template-Screen.swift
                    Template-Evaluator.swift
                    Template-Translator.swift
                    """),
                  .text("The Screen is our top-level View. It's just like any other view, except that it knows a specific evaluator and translator concretely. Most other views don't know a translator at all, and they are decoupled from a specific evaluator, knowing it only by a protocol."),
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
        )
    }
}
