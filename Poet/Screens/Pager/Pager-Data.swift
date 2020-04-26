//
//  Pager-Data.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/26/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

class PagerDataStore {
    static let shared = PagerDataStore()
    
    let pages: [Page] = [
        Page(title: "Paging Tutorial",
             body: [
                
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
        
        Page(title: "The Main Actors",
        body: [
            .text("Before we start, a quick high-level overview:"),
            .image("poet-intro-small"),
            .subtitle("Evaluator"),
            .text("The Evaluator is the business logic decision-maker. It maintains what we might call ”business state.”"),
            .subtitle("Translator"),
            .text("The Translator interprets the intent of the Evaluator and turns it into observable and passable ”display state.”"),
            .subtitle("Screen"),
            .text("The Screen recognizes when display state has changed and remakes any nested views accordingly."),
            .text("That's good enough for now. ⃰ Let's get into some particulars by thinking about the screen you're looking at right now. Tap the right arrow to continue."),
            .footnote(" ⃰Later, we'll also talk about the Performer, which is just a helpful way to break asynchronous activity (like network calls) out of the Evaluator and into a separate object. By maintaining these distinct layers, our code becomes more composable and testable than it would be otherwise.")
        ]),
        
        Page(title: "Observables",
             body: [
                
             .text("The left and right arrows on this screen are views that have been injected with Actions, which are just methods that reside on the screen's Evaluator. The Evaluator handles an arrow's Action by updating its private state and then asking the Translator to show the current page:"),
                    
             .code(
                """
                translator.show(
                    page: currentPage,
                    number: pageIndex + 1,
                    of: pages.count)
                """),
                
                
            .text("The Translator's job is to update what you see on screen. It does this by assigning values to its Observables:"),
    
            .code(
                """
                observable.pageTitle.string = page.title
                observable.pageBody.array = page.body
                """),
                
            .text("Observables are just classes that wrap around typical value types like Strings, Bools, and Arrays.")
            ]
        ),
        Page(title: "ObservableString",
             body: [
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
                
            .text("On the screen you're looking at, ObservableStrings inform the page title and page count."),
            
            .text("When the Screen object makes its body, it initializes views like ObservingTextView by passing in an ObservableString, which the view holds onto as an @ObservedObject. The view notices when an @ObservedObject changes and remakes itself with its new content. ⃰ "),
                
            .footnote(" ⃰Note that the Screen itself doesn't hold onto any @ObservedObjects. If it did, the whole Screen would be remade each time the object changes. Instead, only nested views hold onto @ObservedObjects."),
            
            ]
        ),
        Page(title: "ObservableBool",
             body: [
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
                    
                .text("ObservableBools inform whether the arrows are enabled or disabled."),

            ]
        ),
        Page(title: "Passables",
             body: [
                
                .text("If you tap the title “Passables,” up above the text you're reading, the Evaluator asks the Translator to show a random emoji. The Screen then shows it inside a bezel. The Translator accomplishes this by updating an instance of PassableString, which is a class that wraps a PassthroughSubject:"),
                    
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
                
                .text("The passable emoji string lives on the Translator, inside a struct called Passable:"),
    
                .code(
                    """
                    struct Passable {
                        var emoji = PassableString()
                    }
                    """),
                
                .text("Unlike Observables, which only mirror current state, Passables let us imperatively trigger behavior (such as showing and then hiding a bezel), simply by setting a new value:"),
                
                .code(
                    """
                    passable.emoji.string = emojis.randomElement()!
                    """),
            ]
        ),
        Page(title: "PassableString",
             body: [
                .text("A Screen can respond to a change in a PassableString if a view is ready for it. In our case, the Screen's body contains a CharacterBezel view which requires a Configuration to be initialized with the PassableString. During its initialization, the Configuration then creates a Behavior (just a typealiased AnyCancellable) in which it modifies observed values that reside on the Configuration."),
                
                .code(
                    """
                    init(character: PassableString) {
                        self.behavior = character.subject.sink { value in
                            self.observable.character.string = value ?? ""
                            // etc.
                        }
                    }
                    """),
                
                .text("The CharacterBezel in turn wraps another view, CharacterBezelWrapped, that observes the Configuration's Observables:"),
                
                .code(
                    """
                    CharacterBezelWrapped(
                        character: configuration.observable.character,
                        opacity: configuration.observable.opacity)
                    """),
                
                .text("When those values change, CharacterBezelWrapped updates its character and shows or hides itself."),
                .text("Other Passable classes exist, too:"),
                
                .quote(
                    """
                    * PassableDouble
                    * PassablePlease
                    """),
                
                .text("The Please passable doesn't even send a value. It's just a magic word:"),
                .code("justDoSomething.please()"),
            ]
        ),
        Page(title: "AlertTranslating and AlertView",
             body: [
                .text("If you tap the page number at the bottom of this screen, you'll see an alert. Alerts are made easy by protocol-oriented translating. The Evaluator can call:"),
                .code("translator.showAlert(title:message:)"),
                .text("The Translator will then do the rest for free, because it conforms to AlertTranslating, which only requires the Translator to hold onto an instance of AlertTranslator. AlertTranslator is a class that holds two ObservableStrings and an ObservableBool:"),
                .code(
                    """
                    var alertTitle = ObservableString()
                    var alertMessage = ObservableString()
                    var isAlertPresented = ObservableBool(false)
                    """),
                .text("All the Screen needs to do is have an AlertView in its body and assign it the Observables, which can be found directly on the Translator thanks to some sleight of hand by the AlertTranslating protocol:"),
                .code(
                    """
                    AlertView(
                        title: translator.alertTitle,
                        message: translator.alertMessage,
                        isPresented: translator.isAlertPresented)
                    """),
                .text("The AlertView takes care of the rest. Now the Evaluator can trigger any alert it wants, without additional implementation on the Translator or Screen."),
                .text("If we find ourselves solving for similar common behavior in the future (say, Action Sheets, Bezels, Toasts), we can imagine creating a single wrapper view that we could apply to any Screen's body, which would provide all the additional views for free.")
            ]
        ),
        Page(title: "Actions and Evaluators\nAvoiding Retain Cycles",
             body: [
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
                                text: translator.observable.pageTitle,
                                font: Font.headline.monospacedDigit(),
                                alignment: .center)
                            )
                    )
                    """)
            ]
        ),
        
        Page(title: "Avoiding Translator Retain Cycles",
             body: [
                .text("It's not clear (to me) yet whether or not it's worth fretting over retain cycles on the Translator. The Translator holds onto its Observable and Passable values as structs. These structs then contain instances of ObservableObjects and PassableSubjects. Whenever a Translator holds onto other Translators, like AlertTranslator, these are structs too. So far so good.")
            ]
        ),
        
        Page(title: "More to come soon...",
             body: [
                .text("I hope this has been interesting so far. Things I'll cover soon:"),
                .quote(
                """
                * Testing
                * Performers
                * More protocol-oriented translating
                * Composable views that are injected with an protocl-defined evaluator
                * Complex screens where Poet's reusability and flexibility emerges
                """)
            ]
        )
    ]
}
