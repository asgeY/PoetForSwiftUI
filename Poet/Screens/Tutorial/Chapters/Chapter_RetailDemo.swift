//
//  Chapter_RetailDemo.swift
//  Poet
//
//  Created by Steve Cotner on 5/26/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

extension Tutorial.PageStore {
    var chapter_RetailDemo: Chapter {
        return Chapter(
            "Retail Demo",
            pages:
            Page([
                .demo(.showRetailDemo),
                .text("Imagine you work in retail and your job is to find and deliver products. If you tap “Show Retail Demo” you'll see a screen that offers such a user flow. Try it out."),
                .text("You'll notice the Retail demo is getting close to production-ready code. It shows how we can have a complex, step-based user interface that also seamlessly animates its state changes."),
                .text("Most importantly it shows how we can dynamically create views that observe our translator's content, and show and hide those views depending on our data and the step we're in. "),
                .text("This speeds development by decoupling our layers in all the right ways. We still have fine-grained control over animated transitions, but we don't have to waste effort thinking about all the possible permutations of views on screen."),
                .text("We just make our choices on the fly. Here's how we show the “Not Started” step:"),
                .code(
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
                ),
                .file("Retail-Evaluator"),
                .text("This works because of ObservingPageView, a view that observes an array of ObservingPageViewSections. Whenever that array is updated, ObservingPageView creates a view for each section, using a ViewMaker it's also handed."),
                .text("In our case the ViewMaker is Retail.ViewMaker, which knows how to make views for cases of Retail.Translator.Section, an enum that conforms to ObservingPageViewSection."),
                .text("To allow for the greatest possible dynamism, some of our Retail.Translator.Section cases are handed observable associated types when they are created."),
                .text("For instance, the “feedback” section knows what string it should observe:"),
                .code(
                    """
                    case feedback(feedback: ObservableString)
                    """
                ),
                .text("Whenever we create that case, we just assign it the “feedback” property:"),
                .code("return .feedback(feedback: feedback)"),
                .text("And that property is just an observable string the Translator holds onto:"),
                .code("var feedback = ObservableString()"),
            
            
                .text("So when we're translating a step, we just need to do two things to see feedback on screen. First, we set our observable string:"),
                .code(
                    """
                    feedback.string = "The customer
                        has been notified that their
                        order cannot be fulfilled."
                    """),
            
            
                .text("And second, we ensure that “feedback” is one of the sections we ask to show:"),
                .code(
                    """
                    showSections([
                        ...
                        feedback_,
                        ...
                    ])
                    """
                ),
            
            
                .text("showSections(:) is just a method that assigns Section cases to the Translator's sections array, which our ObservingPageView observes."),
                .code(
                    """
                    func showSections(_ newSections:
                      [Section]) {
                        self.sections.array = newSections
                    }
                    """
                ),
            
            
                .text("If it looks a little funny that we write “feedback_” with an underscore, that's just the name of a computed property that builds the enum with its observable data:"),
                .code(
                    """
                    var feedback_: Section {
                      return .feedback(feedback: feedback)
                    }
                    """
                ),
            
            
            
                .text("In the “Find Products” step, we show the same sections, but we add a FindableProduct to each DisplayableProduct:"),
                .code(
                    """
                    displayableProducts.array =
                      configuration.findableProducts.map({
                        return DisplayableProduct(
                            product: $0.product,
                            findableProduct: $0
                        )
                    })
                    """
                ),
            
                .text("DisplayableProductsView shows “Found” and ”Not Found” for the FindableProduct:"),
                .code(
                    """
                    if displayableProduct.findableProduct
                      != nil {
                      FoundNotFoundButtons(findableProduct:
                        displayableProduct.findableProduct!,
                        evaluator: self.evaluator)
                    }
                    """
                )
            ])
        )
    }
}
