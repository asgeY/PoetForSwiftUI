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
                "ObservingButton"
            ],
            pages:
            Page([
                .text("With few exceptions, whenever you interact with a view on screen, the view tells its evaluator about it."),
                .text("When you tap a button, for instance, the view might say to its evaluator:"),
                .code(
                    """
                    self.evaluator?.evaluate(Action.doSomething)
                    """
                ),
                .text("In that case, “doSomething” is the name of a specific action.")
            ]),
            
            Page([
                .text("To be more precise, .doSomething would be an enum case that lives on the evaluator, along with all the other user-initiated actions relevant to its screen:"),
                .code(
                    """
                    enum Action: EvaluatorAction {
                        case doSomething
                        // etc.
                    }
                    """
                )
            ]),
            
            Page([
                .text("An evaluator's Action type should conform to an empty protocol named EvaluatorAction:"),
                .code("protocol EvaluatorAction {}"),
                .text("The empty protocol allows us to use actions throughout a screen's views without tying them to a specific evaluator (and therefore a specific business purpose).")
            ]),
            
            Page([
                .text("Any button that wants to evaluate a user tap can do so without knowing who its real evaluator is, only that it will conform to the protocol ActionEvaluating:"),
                .smallCode(
                    """
                    protocol ActionEvaluating: class {
                        func evaluate(_ action: EvaluatorAction?)
                    }
                    """
                )
            ],
                 file: "ActionEvaluating"
            ),
            
            Page([
                .text("In this way, our view layer can be fully decoupled from particular business purposes."),
                .text("A button can be decoupled even further — not just from the evaluator that handles its action, but from the choice of which action it carries. Because ActionEvaluating only knows actions as a general type, EvaluatorAction, we can inject a button with whatever action we like.")
            ]),
            
            Page([
                .text("To do that, we could use an ObservingButton, for instance, which observes an EvaluatorAction:"),
                .code(
                    """
                    @ObservedObject var action:
                      ObservableEvaluatorAction
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
        )
    }
}
