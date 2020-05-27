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
            Page([.text("Imagine you work in retail and your job is to find and deliver products. If you tap “Show Retail Demo” you'll see a screen that offers such a user flow. Try it out.")], action: .showRetailDemo),
            Page([.text("You'll notice the Retail demo is getting close to production-ready code. It shows how we can have a complex, step-based user interface that also seamlessly animates its state changes.")], action: .showRetailDemo),
            Page([.text("Most importantly it shows how we can dynamically create views that observe our translator's content, and show and hide those views depending on our data and the step we're in. ")], action: .showRetailDemo),
            Page([.text("This speeds development by decoupling our layers in all the right ways. We still have fine-grained control over animated transitions, but we don't have to waste effort thinking about all the possible permutations of views on screen.")], action: .showRetailDemo),
            
            Page([.text("We just make our choices on the fly. Here's how we show the “Not Started” step:"),
                  .extraSmallCode(
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
                )
            ], action: .showRetailDemo),
            
            Page([.text("This works because of ObservingPageView, a view that observes an array of ObservingPageViewSections. Whenever that array is updated, ObservingPageView creates a view for each section, using a ViewMaker it's also handed.")], action: .showRetailDemo),
            
            Page([.text("In our case the ViewMaker is Retail.ViewMaker, which knows how to make views for cases of Retail.Translator.Section, an enum that conforms to ObservingPageViewSection.")], action: .showRetailDemo),
            
            Page([.text("To allow for the greatest possible dynamism, some of our Retail.Translator.Section cases are handed observable associated types when they are created.")], action: .showRetailDemo),
            
            Page([.text("For instance, the “feedback” section knows what string it should observe:"),
                  .smallCode(
                    """
                        case feedback(
                          feedback: ObservableString)
                        """)
            ], action: .showRetailDemo),
            
            
            Page([.text("Whenever we create that case, we just assign it the “feedback” property:"),
                  .smallCode(
                    """
                        return .feedback(
                            feedback: feedback)
                        """),
                  .text("And that property is just an observable string the Translator holds onto:"),
                  .smallCode(
                    """
                        var feedback = ObservableString()
                        """),
            ], action: .showRetailDemo),
            
            Page([.text("So when we're translating a step, we just need to do two things to see feedback on screen. First, we set our observable string:"),
                  .smallCode(
                    """
                      feedback.string = "The customer
                        has been notified that their
                        order cannot be fulfilled."
                      """),
            ], action: .showRetailDemo),
            
            Page([.text("And second, we ensure that “feedback” is one of the sections we ask to show:"),
                  .smallCode(
                    """
                      showSections([
                          ...
                          feedback_,
                          ...
                      ])
                      """),
            ], action: .showRetailDemo),
            
            Page([.text("showSections(:) is just a method that assigns Section cases to the Translator's sections array, which our ObservingPageView observes."),
                  .smallCode(
                    """
                      func showSections(_ newSections:
                        [Section]) {
                          self.sections.array = newSections
                      }
                      """),
            ], action: .showRetailDemo),
            
            Page([.text("If it looks a little funny that we write “feedback_” with an underscore, that's just the name of a computed property that builds the enum with its observable data:"),
                  .smallCode(
                    """
                      var feedback_: Section {
                        return .feedback(feedback: feedback)
                      }
                      """),
            ], action: .showRetailDemo),
            
            
            Page([.text("In the “Find Products” step, we show the same sections, but we add a FindableProduct to each DisplayableProduct:"),
                  .extraSmallCode(
                    """
                        displayableProducts.array =
                          configuration.findableProducts.map({
                            return DisplayableProduct(
                                product: $0.product,
                                findableProduct: $0
                            )
                        })
                        """
                )
            ], action: .showRetailDemo),
            
            Page([.text("DisplayableProductsView shows “Found” and ”Not Found” for the FindableProduct:"),
                  .extraSmallCode(
                    """
                        if displayableProduct.findableProduct
                          != nil {
                        FoundNotFoundButtons(findableProduct:
                          displayableProduct.findableProduct!,
                          evaluator: self.evaluator)
                        }
                        """
                )
            ], action: .showRetailDemo)
        )
    }
}