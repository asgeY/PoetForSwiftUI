//
//  Simplest-Evaluator.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/2/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

extension Simplest {
    class Evaluator {
        
        // Translator
        lazy var translator: Translator = Translator(current)
        
        // Step       
        var current = PassableStep(Step.loading)
        
        // Button Actions
        enum ButtonAction: EvaluatorAction {
            case advancePage
            case advanceWorldImage
            case helloWorld
            case returnToTutorial(chapterIndex: Int, pageIndex: Int)
            
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
            let text: String
            let action: ButtonAction?
            
            init(_ text: String, action: ButtonAction? = nil) {
                self.text = text
                self.action = action
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
        
        var textData: [Chapter] = [
            Chapter("Introduction", pages:
                Page("You're looking at a simple screen made with the Poet pattern. Tap this text to keep reading about it."),
                Page("In Poet, whenever you interact with a view on screen, the view tells an “evaluator” about it — that's the “E” in Poet."),
                Page("When you tap this view, for instance, it says to the evaluator, buttonTapped(action: Evaluator.ButtonAction\n.advancePage)"),
                Page("That's a little wordy, but it's just spelling out an enum case the evaluator owns: “advancePage.”"),
                Page("The view layer only knows that name .advancePage, not what it does. The rest is handled by a couple of partners, the evaluator and the “translator” — the “T” in Poet."),
                Page("First, the evaluator makes decisions about “business state.” Then the translator interprets that state and creates its own “display state.” The view layer responds any time display state changes."),
                Page("The evaluator and translator are two different stops along an assembly line that rolls toward the view layer."),
                Page("Soon we'll talk about why it's handy to have these two different types of state, business and display, after a brief discussion of state in general.")
            ),
            
            // State
            Chapter("State", pages:
                Page("Everything we do in an app creates state. State is the answer to the question, “what is true at this moment?”"),
                Page("On this screen, we can intuit that our state includes the text we're reading and the actions available to us."),
                Page("It also entails that we're reading text and not, say, spinning a globe. But you can do that, too. Tap the “Hello World” button below.", action: .helloWorld),
                Page("Cool, huh? It looks like this screen has at least two different modes, or collections of state, that it must keep track of: showing this tutorial, and showing the globe."),
                Page("We have another, too: every time we start a new chapter, that cool title animation is a distinct step."),
                Page("Modes are tough to reason about, because people tend to not notice them. Programmers often fail to distinguish which states are incompatible, so they never properly separate them into distinct data structures."),
                Page("Poet doesn't use the word “mode,” by the way. It calls these different collections of state “steps.” Naming is hard."),
                Page("The challenge in making apps is to never create the conditions in which conflicting state can arise, because keeping track of everything will place an undue burden on the programmer."),
                Page("When we're showing text and we tap on it, we don't want to have to ask, “am I showing the globe or the text or the title right now?” before making a decision. We should just know."),
                Page("Accounting for all possible combinations of mutually incompatible state is tough without a good plan. When handled badly, it leads to something called a combinatorial explosion."),
                Page("If you've ever seen a long chain of bools — if this and not this and not that — you've seen someone suppressing a tiny combinatorial explosion."),
                Page("As choices like these build up over time, a screen's code becomes dense with conditions and exceptions. These make it nearly impossible to debug, maintain and modify."),
                Page("Programming can be more straightforward, though, if you make the right distinctions. One such distinction is between business state and display state.")
            ),
            
            // Display State
            Chapter("Display State", pages:
                Page("Display state entails all the choices that determine what happens on screen. What should the text say? The title? Should a button be visible?"),
                Page("When we say display state, it's important to note that we don't mean the view layer. The view layer can respond to changes in display state, and we'll call that response “view logic.”"),
                Page("But before we ever get to the view layer, something has to save the state that the view layer responds to."),
                Page("Poet gives that job to a layer called the translator. On this screen, for instance, the translator answers true or false to “shouldShowText” and “shouldShowButton.” It offers strings for “title” and “text.” And so on."),
                Page("There's one special thing about how it does that: the text, strings, bools, and so on are all “observable,” meaning someone else can watch them for changes."),
                Page("The view layer observes those bools and other types, and hides or remakes its views accordingly."),
                Page(
                    """
                    The translator says things like this:

                    shouldShowTitle.bool = true
                    shouldShowImage.bool = false
                    """),
                Page(
                    """
                    and this:

                    title.string = configuration.title
                    text.string = configuration.text
                    """),
                Page("But if setting values to show, hide or modify on-screen elements is all a matter of display state, then what is left for business state?")
            ),
            
            // Business State
            Chapter("Business State", pages:
                Page("The evaluator/translator divide allows the evaluator to make higher-level decisions about what should happen, without worrying about setting a precise display state."),
                Page("It's the evaluator who decides what we really want to do. The evaluator hears that a user action has taken place, thinks about the current business state, and then saves a new state."),
                Page("The last thing an evaluator will do is always to say, “show a certain ‘step’ with a certain ‘configuration,’” at which point the translator will interpret the new step into new display state."),
                Page("When you tap this text, for instance, the evaluator handles the .advancePage action by checking its current step, which it expects to be a .page step and not some other kind (like .world or .interlude)."),
                Page("That .page step contains a configuration which knows everything we need to know about our current state: chapterIndex, pageIndex, etc. The evaluator can reason about these values whenever a new user action arrives."),
                Page("The configuration also contains values which are there to serve the translator: title and text are strings that are plucked off a data store using chapterIndex and pageIndex. They're added to the configuration so the translator won't have to figure them out later. Title and text are therefore first-class members of business state."),
//                Page("So evaluator's steps serve two masters, but only "),
                Page("If we want to go to the next page, we start with our current “page” step, modify its configuration, and save it as a new step."),
                Page("To go to the next chapter, we cycle through a few steps with a slight delay: first an “interlude” step where everything fades away, then a “title” step where we just see the title, and then back to a new page."),
                Page("The translator and the view layer will handle all the details like opacity and spring animations, letting the evaluator stay high above the action.")
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
                
                Page("."),
                Page("")
                
                // Protocol-oriented translating -- alert, bezel
            ),
            
            // Decoupling the View Layer
            Chapter("Decoupling the View Layer", pages:
                // translator.buttonAction... button action injected into button. evaluator only known by protocol.
                Page("."),
                Page("")
            ),
            
            // Imperative, Protocol-Oriented Translating
            Chapter("Protocol-Oriented Translating", pages:
                // Protocol-oriented translating -- alert, bezel, action sheets. because we're writing in swift, we can take advantage of protoocol-oriented programming — the “P.O.” in P.O.E.T. — to make certain flows easy to implement. this gives us a pattern that speeds us up, instead of forcing us to reinvent or re-implement certain common solutions every time we make a new screen. The translator and view layer can each one require one or two lines of boilerplate to fully implement alerts, action sheets, and other common UI elements.
                Page("."),
                Page("")
            ),
            
            // Decoupling the View Layer
            Chapter("Helper Types", pages:
                // evaluator known by protocol. buttonTapped(...)
                Page("Observables"),
                Page("Passables")
            ),

            // the right division, the right abstraction between the two layers.
            // there's a hinge where translator behavior is reusable. we eliminate a source of combinatorial explosions.
            
            // Interpreting Business State
            
            // in terms of business state, incompatible
            // in display state, we're either showing things or not. but any given thing should only know about the state it cares about.
            
            
        ]
        
        
    }
}

// MARK: Steps and Step Configurations

extension Simplest.Evaluator {
    
    // MARK: Steps
    
    enum Step: EvaluatorStep {
        case loading
        case title(TitleStepConfiguration)
        case page(TextStepConfiguration)
        case world(WorldStepConfiguration)
        case interlude
    }
    
    // MARK: Configurations
    
    struct TextStepConfiguration {
        var title: String
        var text: String
        var chapterIndex: Int
        var chapterNumber: Int { return chapterIndex + 1 }
        var pageIndex: Int
        var pageNumber: Int { return pageIndex + 1 }
        var pageCount: Int
        var action: ButtonAction?
    }
    
    struct TitleStepConfiguration {
        var title: String
        var chapterIndex: Int
        var chapterNumber: Int { return chapterIndex + 1 }
    }
    
    struct WorldStepConfiguration {
        var image: String
        var title: String
        var action: ButtonAction
    }
}

// MARK: View Cycle

extension Simplest.Evaluator: ViewCycleEvaluator {
    
    func viewDidAppear() {
        showInterlude()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now().advanced(by: .milliseconds(500))) {
            self.showPage(forChapterIndex: 0, pageIndex: 0)
        }
    }
}

// MARK: Button Actions

extension Simplest.Evaluator: ButtonEvaluator {
    func buttonTapped(action: EvaluatorAction?) {
        guard let action = action as? ButtonAction else { return }
        switch action {
            
        case .advancePage:
            advancePage()
            
        case .advanceWorldImage:
            advanceWorldImage()
            
        case .helloWorld:
            showWorld()
            
        case .returnToTutorial(let chapterIndex, let pageIndex):
            showPage(forChapterIndex: chapterIndex, pageIndex: pageIndex)
        }
    }
}

// MARK: Configuring Steps

extension Simplest.Evaluator {
    
    func showInterlude() {
        current.step = .interlude
    }
    
    // MARK: Title
    
    func showTitle(forChapterIndex chapterIndex: Int) {
        let configuration = TitleStepConfiguration(
            title: textData[chapterIndex].title,
            chapterIndex: chapterIndex)
        current.step = .title(configuration)
    }
    
    // MARK: Page
    
    func showPage(forChapterIndex chapterIndex: Int, pageIndex: Int) {
        let configuration = TextStepConfiguration(
            title: textData[chapterIndex].title,
            text: textData[chapterIndex].pages[pageIndex].text,
            chapterIndex: chapterIndex,
            pageIndex: pageIndex,
            pageCount: textData[chapterIndex].pages.count,
            action: textData[chapterIndex].pages[pageIndex].action
        )
        current.step = .page(configuration)
    }
    
    func advancePage() {
        // Must be in Text step
        guard case let .page(configuration) = current.step else { return }
        
        var isNewChapter = false
        
        let (nextChapter, nextPage): (Int, Int) = {
            if configuration.pageIndex < textData[configuration.chapterIndex].pages.count - 1 {
                return (configuration.chapterIndex, configuration.pageIndex + 1)
            } else {
                isNewChapter = true
                if configuration.chapterIndex < textData.count - 1 {
                    return (configuration.chapterIndex + 1, 0)
                } else {
                    return (0, 0)
                }
            }
        }()
        
        if isNewChapter {
            showInterlude()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now().advanced(by: .milliseconds(500))) {
                self.showTitle(forChapterIndex: nextChapter)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now().advanced(by: .milliseconds(1000))) {
                    self.showPage(forChapterIndex: nextChapter, pageIndex: nextPage)
                }
            }
        } else {
            showPage(forChapterIndex: nextChapter, pageIndex: nextPage)
        }
    }
    
    func showWorld(rememberingChapterIndex chapterIndex: Int, pageIndex: Int) {
        let configuration = WorldStepConfiguration(
            image: self.worldImages[0],
            title: "Hello World!",
            action: .returnToTutorial(chapterIndex: chapterIndex, pageIndex: pageIndex)
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

    func showWorld() {
        // Must be in Text step
        if case let .page(configuration) = self.current.step {
            showInterlude()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now().advanced(by: .milliseconds(500))) {
                self.showWorld(rememberingChapterIndex: configuration.chapterIndex, pageIndex: configuration.pageIndex + 1)
            }
        }
    }
}

protocol ButtonEvaluator: class {
    func buttonTapped(action: EvaluatorAction?)
}
