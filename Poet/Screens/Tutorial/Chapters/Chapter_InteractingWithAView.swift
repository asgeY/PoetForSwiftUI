//
//  Chapter_InteractingWithAView.swift
//  Poet
//
//  Created by Steve Cotner on 5/26/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

extension Tutorial.PageStore {
    var chapter_InteractingWithAView: Chapter {
        return Chapter(
            "Interacting with a View",
            files: [
                "ActionEvaluating",
                "ObservableEvaluatorAction",
                "ObservingButton",
            ],
            pages:
            Page([
                .text("With few exceptions, whenever you interact with a view on screen, the view tells its evaluator about it."),
                .text("When you tap a button, for instance, the view might say to its evaluator:"),
                .code(
                    """
                    evaluator.evaluate(Action.doSomething)
                    """
                ),
                .text("In that case, “doSomething” is the name of a specific action."),
                .text("To be more precise, doSomething would be an enum case that lives on the evaluator, along with all the other user-initiated actions relevant to its screen:"),
                .code(
                    """
                    enum Action: EvaluatorAction {
                        case doSomething
                        case stopSomething
                        // etc.
                    }
                    """
                ),
                .text("An evaluator's Action type conforms to an empty protocol named EvaluatorAction:"),
                .code("protocol EvaluatorAction {}"),
                
                // MARK: Decoupling
                
                .title("Decoupling"),
                .text("The empty protocol allows us to use actions throughout a screen's views without tying them to a specific evaluator (and therefore a specific business purpose)."),
                .text("Any button that wants to evaluate a user's tap (or rather, wants to ask an evaluator to evaluate it) can do so without knowing who its real evaluator is, only that it's an object that conforms to the protocol ActionEvaluating:"),
                .code(
                    """
                    protocol ActionEvaluating: class {
                      func evaluate(_ action: EvaluatorAction?)
                    }
                    """
                ),
                .file("ActionEvaluating"),
                .space(),
                .text("In this way, our view layer can be fully decoupled from particular business purposes. On a simple screen, it may not feel like a crime to couple the view layer closely to business logic, but as a screen grows in complexity we see emergent benefits from a rigorous decoupling."),
                
                // MARK: Injection
                .title("Injection"),
                .text("A button can be decoupled even further — not just from the evaluator that handles its action, but from the choice of which action it carries. Because ActionEvaluating only knows actions as a general type, EvaluatorAction, we can “inject” a button with whatever action we like."),
                .text("SwiftUI isn't like UIKit, though. We aren't able to dynamically create a view at the same moment we make a business decision about its purpose. We also aren't able to hold onto a reference to the view, to later modify one of its properties."),
                .text("Without these modes of programming available to us, it can be difficult at first for a programmer to see how they might inject a button with a particular purpose. The answer turns out to be something we've already seen: Swift's observable types."),
                .text("We could use an ObservingButton, for instance, which holds onto an evaluator (as ActionEvaluating) and observes an EvaluatorAction:"),
                .codeScrolling(
                    """
                    struct ObservingButton<Label>: View where Label : View {
                      @ObservedObject var action: ObservableEvaluatorAction
                      let evaluator: ActionEvaluating
                      var label: () -> Label

                      // ...
                    }
                    """
                ),
                .file("ObservingButton"),
                .space(),
                .text("ObservableEvaluatorAction is, like any of our observing types, a simple wrapper:"),
                .codeScrolling(
                    """
                    class ObservableEvaluatorAction: ObservableObject {
                        @Published var action: EvaluatorAction?
                        
                        init(_ action: EvaluatorAction? = nil) {
                            self.action = action
                        }
                    }
                    """
                ),
                .file("ObservableEvaluatorAction"),
                .space(),
                .text("Whenever the action wrapped inside ObservableEvaluatorAction changes, the purpose of the ObservingButton changes."),
                .text("Similarly, because an ObservingButton takes any label we give it, we could make that button's label observe a value, too, using an ObservingTextView (which we've already seen). So we can easily imagine changing both a button's action and its label on the fly, by setting observable properties in a translator."),
                .text("We are able to pass ObservingButton any label we want thanks to an initializer that expects a view-making closure dressed up with the ViewBuilder attribute:"),
                .code(
                    """
                    @ViewBuilder label: @escaping () -> Label
                    """
                ),
                .text("With all of these tactics available to us, we can see how view elements in general can be decoupled both from business and display state — upstream of the element's appearance — as well as from business logic, which is invoked by interacting with the element."),
                
                // MARK: Evaluating an Action
                
                .title("Evaluating an Action"),
                .text("Suppose a button does call “evaluate” on its evaluator, sending along a particular action."),
                .text("Upon receiving the action in the evaluator, we would embark on the regular flow we already know: the evaluator reasons about business state, the translator creates display state, and the view layer responds."),
                .text("Let's see what that looks like with some real examples.")
            ])
        )
    }
}
