//
//  PagingTutorial-Data.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/26/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

class PagingTutorialDataStore {
    static let shared = PagingTutorialDataStore()
    
    let pages: [Page] = [
        Page(body: [
            .title("Paging Tutorial"),
                
            .text("You're looking at a simple screen that pages left and right. In learning how it's made, you'll be introduced to several building blocks of the Poet pattern, including:"),
            
            .quote(
                """
                * Observables
                * Passables
                * Actions
                """
                ),
            
            .text("Don't get too bogged down in these pieces. They're just types and conventions, and anyone could implement them slightly differently. But in the course of learning about them, you'll learn about some of the main actors in Poet:"),
                
            .quote(
                """
                * Evaluators
                * Translators
                * Screens
                """),
            
            .text("Eventually, Poet's reusability and flexibility will emerge as you learn about approaches like protocol-oriented translators and evaluator-injected composable views. Tap the right arrow to read more.")
            ]
        ),
        
        Page(body: [
            .title("The Main Actors"),
            .text("Before we dive into particulars, here's a look at Poet's unidirectional flow:"),
            .image("poet-intro-small"),
            .subtitle("Evaluator"),
            .text("The Evaluator is the business logic decision-maker. It maintains what we might call ”business state.”"),
            .subtitle("Translator"),
            .text("The Translator interprets the intent of the Evaluator and turns it into observable and passable ”display state.”"),
            .text("Many patterns mingle business state and display state in a single object — from there, it's straight to the view layer. The Evaluator/Translator pattern is different: it offers a helpful distinction between the business and display phases of reasoning, so they may take place sequentially on two separate layers."),
            .subtitle("Screen"),
            .text("The Screen recognizes when display state has changed and remakes any nested views accordingly."),
            .text("That's good enough for now. ⃰ Next up, we'll get into some particulars by thinking about the screen you're looking at right now."),
            .footnote(" ⃰Later, we'll also talk about the Performer, which is just a helpful way to break asynchronous activity (like network calls) out of the Evaluator and into a separate object. By maintaining these distinct layers, our code becomes more composable, testable, and easier to reason about than it would be otherwise.")
        ]),
        
        Page(
             body: [
             .title("Observables"),
             .text("The left and right arrows on this screen are views that have been injected with Actions, which are just methods that belong to the screen's Evaluator. The Evaluator implements an arrow's Action by updating its own state (a Step¹) and asking the Translator to interpret it:"),
                    
             .code(
                """
                configuration.pageIndex += 1
                configuration.page = pages[configuration.pageIndex]
                current.step = .page(configuration)
                """),
                
            .text("In some cases, the Evaluator may directly ask the Translator to do something, like showing an alert.² But when we deal with Steps, the Evaluator doesn't actually have to ask anything, as the Translator is capable of noticing when the Evaluator's current step has changed. The Translator's job then is to update what you see on screen. It does this by assigning values to its Observables:"),
    
            .code(
                """
                pageBody.array = configuration.page.body

                pageXofX.string = "\\(configuration.pageNumber) / \\(configuration.pageCount)"
                """),
                
            .text("Observables are just classes that wrap around typical value types like Strings, Bools, and Arrays."),
                
            .footnote(
            """
            1. You'll read more on passing Evaluator state as a ”Step” in the upcoming section ”Steps.”
            2. Alerts, and the approach of asking the Translator to do something imperatively, will be covered more in ”AlertTranslating and AlertView.”
            """)
            ]
        ),
        
        Page(
             body: [
            .title("ObservableString"),
            .text("An ObservableString, for instance, is an ObservableObject that wraps a @Published String:"),
                
            .code(
                """
                class ObservableString: ObservableObject {
                  @Published var string: String = ""

                  init() {}

                  init(_ string: String) {
                    self.string = string
                  }
                }
                """),
                
            .text("On the screen you're looking at, an ObservableString informs the page count."),
            
            .text("When the Screen object makes its view body, it initializes views like ObservingTextView by passing in an ObservableString, which the view holds onto as an @ObservedObject. The view notices when an @ObservedObject changes and remakes itself with its new content. ⃰ "),
                
            .footnote(" ⃰Note that the Screen itself doesn't hold onto any @ObservedObjects. We don't want the whole Screen to be remade each time an object changes."),
            
            ]
        ),
        
        Page(
             body: [
                .title("ObservableBool"),
                .text("Likewise, ObservableBool wraps a @Published bool:"),
                    
                .code(
                    """
                    class ObservableBool: ObservableObject {
                      @Published var bool: Bool = false
                        
                      init() {}
                        
                      init(_ bool: Bool) {
                        self.bool = bool
                      }
                    }
                    """),
                    
                .text("ObservableBools inform whether the arrows you see are enabled or disabled."),

            ]
        ),
        
        Page(
             body: [
                .title("Passables"),
                .text("If you tap the blue title up above the text you're reading, the Evaluator asks the Translator to show a random emoji. The Screen then shows it inside a bezel. The Translator accomplishes this by updating an instance of PassableString, which is a class that wraps a PassthroughSubject:"),
                    
                .code(
                    """
                    class PassableString {
                      var subject = PassthroughSubject<String?, Never>()
                      var string: String? {
                        willSet {
                          subject.send(newValue)
                        }
                      }
                    }
                    """),
                
                .text("The passable emoji string lives on a composable ⃰ BezelTranslator that the Translator holds onto:"),
    
                .code(
                    """
                    struct BezelTranslator {
                      var character = PassableString()
                    }
                    """),
                
                .text("Unlike Observables, which only mirror current state, Passables let us imperatively trigger behavior (such as showing and then hiding a bezel), simply by setting a new value. Here's how our Translator does that:"),
                
                .code(
                    """
                    func showBezel(character: String) {
                      bezelTranslator.character.string = character
                    }
                    """),
                
                .text("There's more to say about that, but first it's worth pointing out that other Passable classes exist, too:"),
                
                .quote(
                    """
                    * PassableDouble
                    * PassablePlease
                    """),
                
                .text("The Please passable doesn't even send a value. It's just a magic word:"),
                
                .code("justDoSomething.please()"),
                
                .text("Maybe that will come in handy?"),
                
                .footnote(" ⃰Composable translators will be explained more an upcoming section, ”AlertTranslating and AlertView.”")
            ]
        ),
        
        Page(
             body: [
                .title("PassableString"),
                .text("A Screen can respond to a change in a PassableString if a view is ready for it. In our case, the Screen's body contains a CharacterBezel view which requires a Configuration to be initialized with the PassableString. During its initialization, the Configuration then creates a Behavior (just a typealiased AnyCancellable) in which it modifies observed values that reside on the Configuration. CharacterBezel wants a configuration object because, as an immutable struct, it should not modify its own values. Instead, it holds onto the configuration, which can modify its values as needed:"),
                
                .code(
                    """
                    struct CharacterBezel: View {

                      let configuration: Configuration

                      class Configuration {

                        var character = ObservableString()
                        var opacity = ObservableDouble(0.0)
                        private var behavior: AnyCancellable?

                        init(character: PassableString) {
                          self.behavior = character.subject.sink { value in
                            self.character.string = value ?? ""
                                // etc.
                          }
                        }
                      }
                    }
                    """),
                
                .text("The CharacterBezel in turn wraps another view, CharacterBezelWrapped, that observes the Configuration's Observables:"),
                
                .code(
                    """
                    var body: some View {
                      CharacterBezelWrapped(
                        character: configuration.character,
                        opacity: configuration.opacity)
                    }
                    """),
                
                .text("When those values change, CharacterBezelWrapped updates its character and shows or hides itself."),
                
                .code(
                    """
                    struct CharacterBezelWrapped: View {
                      @ObservedObject var character: ObservableString
                      @ObservedObject var opacity: ObservableDouble
                        
                      var body: some View {
                        // ...
                        Text(character.string)
                        // ...
                        .opacity(opacity.double)
                      }
                    }
                    """
                ),
                
                .text("Depending on your experience with other approaches, that may seem like a lot or a little bit of code to think about. But once it's written, it's reusable and asks very little of the programmer. As long as a Translator conforms to BezelTranslating and a Screen contains a CharacterBezel view, an Evaluator can show the bezel with a single line of code:"),
                .code("translator.showBezel(\"🐣\")"),
                .text("This can happen because of a composable, protocol-oriented approach to Translating, and we'll see how that works next.")
            ]
        ),
        
        Page(
             body: [
                .title("AlertTranslating and AlertView"),
                .text("If you tap the page number at the bottom of this screen, you'll see an alert. Alerts are made easy by protocol-oriented translating. The Evaluator can call:"),
                .code("translator.showAlert(title:message:)"),
                .text("The Translator will then do the rest for free, because it conforms to AlertTranslating, which only requires the Translator to hold onto an instance of AlertTranslator. AlertTranslator is a class that holds two ObservableStrings, two ObservableAlertActions, and an ObservableBool:"),
                .code(
                    """
                    var alertTitle = ObservableString()

                    var alertMessage = ObservableString()

                    var primaryAlertAction = ObservableAlertAction()

                    var secondaryAlertAction = ObservableAlertAction()

                    var isAlertPresented = ObservableBool(false)
                    """),
                .text("All the Screen needs to do is have an AlertView in its body and assign it the Observables, which can be found on the Translator's instance of the AlertTranslator:"),
                .code(
                    """
                    AlertView(
                      title: translator.alertTranslator.alertTitle,
                      message: translator.alertTranslator.alertMessage,
                      isPresented: translator.alertTranslator.isAlertPresented)
                    """),
                .text("The AlertView takes care of the rest. Now the Evaluator can trigger any alert it wants, without additional implementation on the Translator or Screen."),
                .text("If we find ourselves solving for similar common behavior in the future (say, Action Sheets, Toasts), we can imagine creating a single wrapper view that we could apply to any Screen's body, which would provide all the additional views for free.")
            ]
        ),
        
        Page(
            body: [
            .title("Steps"),
            
            .text("We've seen that things like Alerts and Bezels can be triggered imperatively, but we'll want to handle most updates in a completely declarative manner. We do that by setting state on the Evaluator. But more specifically, we do it by setting a ”Step”:"),
            
            .code("current.step = .page(configuration)"),
            
            .text("Whenever the Evaluator needs to make changes to its current state, it saves a new configuration for a ”Step.” A step is a collection of state that represents all the choices necessary to render the screen correctly. A step is deterministic and should always be interpreted the same way by the Translator, based on data in the step's configuration. ”Step” is a slightly less nebulous term than ”state,” as it entails that a screen can only occupy one step — one collection of state — at a time. On some screens, steps also represent the progressive disclosure of interface options, so they are a useful concept that holds up well. All of this screen's state is captured in this code:"),
            
            .code(
                """
                enum Step: EvaluatorStep {
                  case loading
                  case page(PageConfiguration)
                }

                struct PageConfiguration {
                  var page: Page
                  var pageIndex: Int
                  var pageNumber: Int { return pageIndex + 1}
                  var pageCount: Int
                }
                """),
            
            .text("And that is saved to a single passable property:"),
            
            .code("var current = PassableStep(Step.loading)"),
            
            .text("The Translator will know when the Evaluator's state has changed because, like some strings we've seen, it's passable, too. Whenever the ”current” property is assigned a new configuration, the Translator notices and remakes its own state according to the behavior it has defined for itself.")
            ]
        ),
        
        Page(
             body: [
                .title("Actions and Evaluators"),
                .text("When a Screen hands an Action to one of its nested views, it does so by referring to a weakly held Evaluator:"),
                
                .code(
                    """
                    leftAction: self.evaluator?.leftAction
                    """),
                
                
                .text("This ensures that nested views don't retain the Evaluator within the Action's closure. Action is just a typealias for an optional closure:"),
                
                .code("typealias Action = (() -> Void)?"),
                .text("When a SwiftUI view such as Button requires a callable closure, it can be handed ”action.evaluate,” which is implemented by soft-unwrapping the optional closure and calling it. This is what ButtonActionView does:"),
                .code("struct ButtonActionView: View {\n    let action: Action\n    let content: AnyView\n    var body: some View {\n        Button(action: action.evaluate) {\n            self.content\n        }\n    }\n}"),
                
                .text("The page title at the top of the screen is implemented using both a ButtonActionView and an ObservingTextView:"),
                
                .code(
                    """
                    ButtonActionView(
                      action: evaluator?.titleAction,
                      content:
                        AnyView(
                        ObservingTextView(
                          text: translator.pageTitle,
                          font: Font.headline.monospacedDigit(),
                          alignment: .center)
                        )
                    )
                    """)
            ]
        ),
        
        Page(
             body: [
                .title("Avoiding Translator Retain Cycles"),
                .text("It's not clear (to me) yet whether or not it's worth fretting over retain cycles on the Translator. The Translator holds onto its Observable and Passable values as structs. These structs then contain instances of ObservableObjects and PassableSubjects. Whenever a Translator holds onto other Translators, like AlertTranslator, these are structs too. So far so good.")
            ]
        ),
        
        Page(
             body: [
                .title("More to come soon..."),
                .text("I hope this has been interesting so far. Things I'll cover soon:"),
                .quote(
                """
                * Testing
                * Performers
                * More protocol-oriented translating
                * Composable views that are injected with a protocol-defined evaluator
                * Complex screens where more reusability and flexibility emerges
                """)
            ]
        )
    ]
}
