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
            case rewindPage
            case advanceWorldImage
            case helloWorld
            case returnToTutorial(chapterIndex: Int, pageIndex: Int)
            case showTableOfContents
            indirect case hideTableOfContents(previousStep: Step)
            case showChapter(chapterIndex: Int)
            
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
                Page("You're looking at a screen made with the Poet pattern. The code behind it emphasizes simplicity, clarity, and flexibility."),
                Page("The process of writing Poet code is methodical but quick. It follows the philosophy that a pattern “should be made as simple as possible, but no simpler.”"),
                Page("Once you get comfortable with the basic structure, Poet frees you to write quickly and confidently, without the fear that your code will get tangled up over time."),
                Page("We'll learn about the pattern, and the benefits it confers, by thinking about how this screen was made. But first, why is it called Poet?")
            ),
            
            Chapter("Why Poet?", pages:
                Page("Poet is an acronym that stands for Protocol-Oriented Evaluator/Translator. The evaluator and translator are a pair that work together."),
                Page("You can think of the evaluator and translator as two different layers in the pattern, or as two different phases of reasoning that the programmer will undertake."),
                Page("The evaluator is the business logic decision-maker. It maintains what we might call “business state.”"),
                Page("The translator interprets the intent of the evaluator and turns it into observable and passable “display state.”"),
                Page("And the view layer — a screen made up of SwiftUI View structs — is what observes or is passed the translator's display state."),
                Page("A given user flow requires participation from the evaluator, translator, and view layer. Sometimes we need to be deliberate about each layer and spell them out step by step."),
                Page("Other times, we know what each layer should do, and protocol-oriented programming can bridge them all with default protocol implementations."),
                Page("We can explore these ideas further by thinking about how this screen was made.")
                ),
            
            Chapter("Interacting with a View", pages:
                Page("In Poet, whenever you interact with a view on screen, the view tells an evaluator about it."),
                Page("When you tap this view, for instance, it says to the evaluator, buttonTapped(action: Evaluator.ButtonAction\n.advancePage)"),
                Page("That's a little wordy, but it's just spelling out an enum case the evaluator owns: “advancePage.”"),
                Page("The view layer only knows that name .advancePage, not what it does. The rest is handled by the partnership of an evaluator and translator."),
                Page("Again, the evaluator will make decisions about business state. The translator will interpret that state and create its own display state. And the view layer will respond any time display state changes."),
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
                // Over time, you might find protocol-oriented improvements that give you certain things for free.
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
        case interlude
        case mainTitle(MainTitleStepConfiguration)
        case chapterTitle(ChapterTitleStepConfiguration)
        case page(TextStepConfiguration)
        case world(WorldStepConfiguration)
        case tableOfContents(TableOfContentsConfiguration)
    }
    
    // MARK: Configurations
    
    struct MainTitleStepConfiguration {
        var title: String
    }
    
    struct ChapterTitleStepConfiguration {
        var title: String
        var chapterIndex: Int
        var chapterNumber: Int { return chapterIndex + 1 }
    }
    
    struct TextStepConfiguration {
        var title: String
        var text: String
        var chapterIndex: Int
        var chapterNumber: Int { return chapterIndex + 1 }
        var pageIndex: Int
        var pageNumber: Int { return pageIndex + 1 }
        var pageCount: Int
        var buttonAction: ButtonAction?
        var tableOfContentsAction: ButtonAction
    }
    
    struct WorldStepConfiguration {
        var image: String
        var title: String
        var buttonAction: ButtonAction
    }
    
    struct TableOfContentsConfiguration {
        var selectableChapterTitles: [NamedEvaluatorAction]
        var returnAction: ButtonAction
    }
}

// MARK: View Cycle

extension Simplest.Evaluator: ViewCycleEvaluator {
    
    func viewDidAppear() {
        
        // Opening animation
        
        showInterlude()
        afterWait(500) {
            self.showMainTitle("Why Poet?")
            afterWait(1000) {
                self.showInterlude()
                afterWait(1000) {
                    self.showChapterTitle(forChapterIndex: 0)
                    afterWait(1000) {
                        self.showPage(forChapterIndex: 0, pageIndex: 0)
                    }
                }
            }
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
            
        case .rewindPage:
            rewindPage()
            
        case .advanceWorldImage:
            advanceWorldImage()
            
        case .helloWorld:
            showWorld()
            
        case .returnToTutorial(let chapterIndex, let pageIndex):
            showInterlude()
            afterWait(200) {
                self.showPage(forChapterIndex: chapterIndex, pageIndex: pageIndex)
            }
            
        case .showTableOfContents:
            showTableOfContents()
            
        case .hideTableOfContents(let previousStep):
            current.step = previousStep
            
        case .showChapter(let chapterIndex):
            self.showPage(forChapterIndex: chapterIndex, pageIndex: 0)
        }
    }
}

// MARK: Configuring Steps

extension Simplest.Evaluator {
    
    func showInterlude() {
        current.step = .interlude
    }
    
    // MARK: Main Title
    
    func showMainTitle(_ text: String) {
        let configuration = MainTitleStepConfiguration(
            title: text
        )
        current.step = .mainTitle(configuration)
    }
    
    // MARK: Chapter Title
    
    func showChapterTitle(forChapterIndex chapterIndex: Int) {
        let configuration = ChapterTitleStepConfiguration(
            title: textData[chapterIndex].title,
            chapterIndex: chapterIndex)
        current.step = .chapterTitle(configuration)
    }
    
    // MARK: Page
    
    func showPage(forChapterIndex chapterIndex: Int, pageIndex: Int) {
        let configuration = TextStepConfiguration(
            title: textData[chapterIndex].title,
            text: textData[chapterIndex].pages[pageIndex].text,
            chapterIndex: chapterIndex,
            pageIndex: pageIndex,
            pageCount: textData[chapterIndex].pages.count,
            buttonAction: textData[chapterIndex].pages[pageIndex].action,
            tableOfContentsAction: ButtonAction.showTableOfContents
        )
        current.step = .page(configuration)
    }
    
    func advancePage() {
        // Must be in Page step
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
                self.showChapterTitle(forChapterIndex: nextChapter)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now().advanced(by: .milliseconds(1000))) {
                    self.showPage(forChapterIndex: nextChapter, pageIndex: nextPage)
                }
            }
        } else {
            showPage(forChapterIndex: nextChapter, pageIndex: nextPage)
        }
    }
    
    func rewindPage() {
        // Must be in Page step
        guard case let .page(configuration) = current.step else { return }
        
        
        let (chapter, page): (Int, Int) = {
            if configuration.pageIndex > 0 {
                return (configuration.chapterIndex, configuration.pageIndex - 1)
            } else {
                if configuration.chapterIndex > 0 {
                    let newChapter = configuration.chapterIndex - 1
                    let newPage = textData[newChapter].pages.count - 1
                    return (newChapter, newPage)
                } else {
                    return (0, 0)
                }
            }
        }()
        
        showPage(forChapterIndex: chapter, pageIndex: page)
    }
    
    // MARK: Hello World
    
    func showWorld() {
        // Must be in Page step
        if case let .page(configuration) = self.current.step {
            showInterlude()
            afterWait(500) {
                self.showWorld(rememberingChapterIndex: configuration.chapterIndex, pageIndex: configuration.pageIndex + 1)
            }
        }
    }

    func showWorld(rememberingChapterIndex chapterIndex: Int, pageIndex: Int) {
        let configuration = WorldStepConfiguration(
            image: self.worldImages[0],
            title: "Hello World!",
            buttonAction: .returnToTutorial(chapterIndex: chapterIndex, pageIndex: pageIndex)
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
    
    // MARK: Table of Contents
    
    func showTableOfContents() {
        
        var selectableChapterTitles = [NamedEvaluatorAction]()
        
        for (i, chapter) in textData.enumerated() {
            let selectableChapterTitle = NamedEvaluatorAction(
                name: "\(i + 1). \(chapter.title)",
                action: ButtonAction.showChapter(chapterIndex: i)
            )
            selectableChapterTitles.append(selectableChapterTitle)
        }
        
        let configuration = TableOfContentsConfiguration(
            selectableChapterTitles: selectableChapterTitles,
            returnAction: ButtonAction.hideTableOfContents(previousStep: current.step)
        )
        
        current.step = .tableOfContents(configuration)
    }
}

protocol ButtonEvaluator: class {
    func buttonTapped(action: EvaluatorAction?)
}
