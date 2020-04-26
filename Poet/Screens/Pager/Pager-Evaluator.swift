//
//  Pager-Evaluator.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/24/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

struct Page {
    let title: String
    let body: [Element]
    
    struct Element: Identifiable, Equatable {

        var id: String {
            return self.text
        }
        
        let text: String
        let type: TextType
        
        enum TextType {
            case text
            case code
            case quote
            case footnote
        }
    }
}

extension Pager {
    class Evaluator {
        
        // Translator
        
        let translator: Translator = Translator()
        
        // Data
        
        private var pages: [Page] = [
            Page(title: "Paging Tutorial",
                 body: [
                    Page.Element(
                        text:"You're looking at a simple screen that pages left and right. In learning how it's made, you'll be introduced to several building blocks of the Poet pattern, including:",
                        type: .text),
                    Page.Element(
                        text:
                        """
                        * Observables
                        * Passables
                        * Actions
                        """,
                        type: .quote),
                    Page.Element(
                        text:"Don't get too bogged down in these pieces. They're just types and conventions. But in the course of learning about them, you'll learn about some of the main actors in Poet:",
                        type: .text),
                    Page.Element(
                        text:
                        """
                        * Evaluators
                        * Translators
                        * Screens
                        * Views
                        """,
                        type: .quote),
                    Page.Element(
                        text:"Eventually, Poet's reusability and flexibility will emerge as you learn about approaches like protocol-oriented translators and evaluator-injected composable views. Tap the right arrow to read more.",
                        type: .text),
                ]
            ),
            Page(title: "Observables",
                 body: [
                    Page.Element(
                        text: "The left and right arrows on this screen are views that have been injected with Actions, which are just methods that reside on the screen's Evaluator. The Evaluator handles an arrow's Action by updating its private state and then asking the Translator to show the current page:",
                        type: .text),
                    
                    Page.Element(
                    text:
                    """
                    translator.show(
                        page: currentPage,
                        number: pageIndex + 1,
                        of: pages.count)
                    """,
                    type: .code),
                    
                    Page.Element(
                        text: "The Translator's job is to update what you see on screen. It does this by assigning values to its Observables:",
                        type: .text),
        
                    Page.Element(
                        text:
                        """
                        observable.pageTitle.string = page.title
                        observable.pageBody.array = page.body
                        """,
                        type: .code),
                    
                    Page.Element(
                        text: "Observables are just classes that wrap around typical value types like Strings, Bools, and Arrays.",
                        type: .text)
                ]
            ),
            Page(title: "ObservableString",
            body: [
                Page.Element(
                    text: "An ObservableString, for instance, is an ObservableObject that wraps a @Published String:",
                    type: .text),
                Page.Element(
                    text:
                    """
                    class ObservableString: ObservableObject {
                        @Published var string: String = ""

                        init() {}

                        init(_ string: String) {
                            self.string = string
                        }
                    }
                    """,
                    type: .code),
                Page.Element(
                    text: "On the screen you're looking at, ObservableStrings inform the page title and page count.",
                    type: .text),
                
                Page.Element(
                    text: "When the Screen makes its body, it initializes views like ObservingTextView by passing in an ObservableString, which the view holds onto as an @ObservedObject. The view notices when an @ObservedObject changes and remakes itself with its new content. ⃰ ",
                    type: .text),
                Page.Element(
                text: " ⃰Note that the Screen itself doesn't hold onto any @ObservedObjects. If it did, the whole Screen would be remade each time the object changes. Instead, only nested views hold onto @ObservedObjects.",
                type: .footnote)
                ]),
            Page(title: "ObservableBool",
                 body: [
                    Page.Element(
                        text: "Likewise, ObservableBool wraps a @Published bool:",
                        type: .text),
                    Page.Element(
                        text:
                        """
                        class ObservableBool: ObservableObject {
                            @Published var bool: Bool = false
                            
                            init() {}
                            
                            init(_ bool: Bool) {
                                self.bool = bool
                            }
                        }
                        """,
                        type: .code),
                    Page.Element(
                        text: "ObservableBools inform whether the arrows are enabled or disabled.",
                        type: .text)
                ]
            ),
            Page(title: "Passables",
                 body: [
                    Page.Element(
                        text:"If you tap the title “Passables,” up above the text you're reading, the Evaluator asks the Translator to show a random emoji. The Screen then shows it inside a bezel. The Translator accomplishes this by updating an instance of PassableString, which is a class that wraps a PassthroughSubject:",
                        type: .text),
                    Page.Element(
                        text:
                        """
                        class PassableString {
                            var subject = PassthroughSubject<String?, Never>()
                            var string: String? {
                                willSet {
                                    subject.send(newValue)
                                }
                            }
                        }
                        """,
                        type: .code),
                    
                    Page.Element(
                        text:"The passable emoji string lives on the Translator, inside a struct called Passable:",
                        type: .text),
        
                    Page.Element(
                        text:
                        """
                        struct Passable {
                            var emoji = PassableString()
                        }
                        """,
                        type: .code),
                    
                    Page.Element(
                        text:"Unlike Observables, which only mirror current state, Passables let us imperatively trigger behavior (such as showing and then hiding a bezel), simply by setting a new value:",
                        type: .text),
                    
                    Page.Element(
                        text:
                        """
                        passable.emoji.string = emojis.randomElement()!
                        """,
                        type: .code)
                ]
            ),
            Page(title: "PassableString",
                 body: [
                    Page.Element(text:"A Screen can respond to a change in a PassableString if a view is ready for it. In our case, the Screen's body contains a CharacterBezel view which requires a Configuration to be initialized with the PassableString. During its initialization, the Configuration then creates a Behavior (just a typealiased AnyCancellable) in which it modifies observed values that reside on the Configuration.", type: .text),
                    
                    Page.Element(text:
                        """
                        init(character: PassableString) {
                            self.behavior = character.subject.sink { value in
                                self.observable.character.string = value ?? ""
                                // etc.
                            }
                        }
                        """, type: .code),
                    
                    Page.Element(
                        text: "The CharacterBezel in turn wraps another view, CharacterBezelWrapped, that observes the Configuration's Observables:",
                        type: .text),
                    
                    Page.Element(
                        text:
                        """
                        CharacterBezelWrapped(
                            character: configuration.observable.character,
                            opacity: configuration.observable.opacity)
                        """, type: .code),
                    
                    Page.Element(
                        text: "When those values change, CharacterBezelWrapped updates its character and shows or hides itself.",
                        type: .text),
                    
                    Page.Element(
                    text: "Other Passable classes exist, too:",
                    type: .text),
                    
                    Page.Element(text:
                        """
                        * PassableDouble
                        * PassablePlease
                        """, type: .quote),
                    Page.Element(text:"The Please passable doesn't even send a value. It's just a magic word:", type: .text),
                    Page.Element(text:"justDoSomething.please()", type: .code),
                ]
            ),
            Page(title: "AlertTranslating and AlertView",
                 body: [
                    Page.Element(text:"Alerts are made easy by protocol-oriented translating. The Evaluator can call:", type: .text),
                    Page.Element(text:"translator.showAlert(title:message:)", type: .code),
                    Page.Element(text:"The Translator will then do the rest for free, because it conforms to AlertTranslating, which only requires the Translator to hold onto an instance of AlertTranslator. AlertTranslator is a class that holds two ObservableStrings, \'alertTitle\' and \'alertMessage\', and an ObservableBool, \'isPresented\'. All the Screen needs to do is have an AlertView in its body, to which the observable values are assigned.", type: .text),
                    Page.Element(text:"If we find ourselves solving for similar common behavior in the future (say, Action Sheets, Bezels, Toasts), we can imagine creating a single wrapper we could apply to any Screen's body, which would provide all the additional views for free.", type: .text)
                ]
            ),
            Page(title: "Avoiding Evaluator Retain Cycles",
                 body: [
                    Page.Element(text:"When a Screen hands an Action to one of its nested views, it does so by referring to a weakly held Evaluator. This ensures that inner views don't retain the Evaluator within the Action's closure. Action is a typealias:", type: .text),
                    Page.Element(text:"typealias Action = (() -> Void)?", type: .code),
                    Page.Element(text:"When a SwiftUI View like a Button requires a callable closure, it can be given ”action.evaluate”, which is implemented by soft-unwrapping the optional closure and calling it:", type: .text),
                    Page.Element(text:"struct ButtonView: View {\n    let action: Action\n    let content: AnyView\n    var body: some View {\n        Button(action: action.evaluate) {\n            self.content\n        }\n    }\n}", type: .code)
                ]
            ),
            Page(title: "Avoiding Translator Retain Cycles",
                 body: [
                    Page.Element(text:"This part isn't for sure yet, but I think it's solid. The Translator holds onto its Observable and Passable values as structs. These structs then contain instances of ObservableObjects and PassableSubjects. Whenever a Translator holds onto other Translators, like AlertTranslator, these are structs too.", type: .text)
                ]
            )
        ]
        
        // State
        
        private var pageIndex: Int = 0
        private var currentPage: Page { pages[pageIndex] }
    }
}

// MARK: Private methods for manipulating state

extension Pager.Evaluator {
    func decrementPage() {
        if pageIndex > 0 {
            pageIndex -= 1
        }
    }
    
    func incrementPage() {
        if pageIndex < pages.count - 1 {
            pageIndex += 1
        }
    }
}

// MARK: Button Handling

extension Pager.Evaluator {
    func leftAction() {
        decrementPage()
        showCurrentPage()
    }
    
    func rightAction() {
        incrementPage()
        showCurrentPage()
    }
    
    func pageNumberAction() {
        translator.showAlert(title: "Hello.", message: "You're on page \(pageIndex + 1) of \(pages.count)")
    }
    
    func showCurrentPage() {
        translator.show(
            page: currentPage,
            number: pageIndex + 1,
            of: pages.count)
    }
    
    func titleAction() {
        translator.showRandomEmoji()
    }
}

// MARK: View Cycle

extension Pager.Evaluator: ViewCycleEvaluator {
    func viewDidAppear() {
        showCurrentPage()
    }
}
