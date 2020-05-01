//
//  RetailTutorial-Translator.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/29/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

extension RetailTutorial {

    class Translator: AlertTranslating, BezelTranslating {
        
        typealias Evaluator = RetailTutorial.Evaluator
        
        // OBSERVABLE STATE
        
        // Page
        var sections = ObservableArray<ObservingPageSection>([])
        var title = ObservableString()
        var details = ObservableString()
        var instruction = ObservableString()
        var instructionNumber = ObservableInt()
        var deliveryOptions = ObservableArray<String>([])
        var deliveryPreference = ObservableString()
        var products: ObservableArray<Product> = ObservableArray<Product>([])
        var findableProducts: ObservableArray<FindableProduct> = ObservableArray<FindableProduct>([])
        var completedSummary = ObservableString()
        
        // Bottom Button
        var bottomButtonAction: ObservableNamedEvaluatorAction = ObservableNamedEvaluatorAction()
        
        // Composed Translating
        var alertTranslator = AlertTranslator()
        var bezelTranslator = BezelTranslator()
        
        // Behavior
        var behavior: Behavior?
        
        init(_ step: PassableStep<Evaluator.Step>) {
            behavior = step.subject.sink { value in
                self.translate(step: value)
            }
        }
    }
}

extension RetailTutorial.Translator {
    func translate(step: Evaluator.Step) {
        switch step {
            
        case .loading:
            showLoading()
            
        case .notStarted(let configuration):
            showNotStarted(configuration)
            
        case .findProducts(let configuration):
            showFindingProducts(configuration)
            
        case .chooseDeliveryLocation(let configuration):
            showDeliveryOptions(configuration)
            
        case .completed(let configuration):
            showCompleted(configuration)
            
        case .canceled(let configuration):
            showCanceled(configuration)
            
        }
    }
    
    // MARK: Loading Step
    
    func showLoading() {
        sections.array = []
    }
    
    // MARK: Not Started Step
    
    func showNotStarted(_ configuration: Evaluator.NotStartedConfiguration) {
        
        let pluralizedProduct = configuration.products.count == 1 ? "product" : "products"
        
        // Assign values to our observable page data
        title.string = "Order for \(configuration.customer)"
        details.string = "\(configuration.products.count) \(pluralizedProduct) requested"
        instruction.string = "Tap start to claim this order"
        instructionNumber.int = 1
        products.array = configuration.products
        
        // Say that only these things should appear in the body
        displaySections([.title, .instruction, .details, .products])
        
        // Bottom button
        bottomButtonAction.action = NamedEvaluatorAction(name: "Start", action: configuration.startAction)
    }
    
    // MARK: Finding Products Step
    
    func showFindingProducts(_ configuration: Evaluator.FindProductsConfiguration) {
        
        // Assign values to our observable page data
        title.string = "Order for \(configuration.customer)"
        details.string = "\(configuration.findableProducts.filter {$0.status == .found}.count) marked as found"
        instruction.string = "Find products for this order"
        instructionNumber.int = 2
        findableProducts.array = configuration.findableProducts
        
        // Say that only these things should appear in the body
        displaySections([.title, .instruction, .details, .findableProducts])
        
        // Bottom button
        if let nextAction = configuration.nextAction {
            let name = {
                nextAction == .advanceToCanceledStep ? "Cancel Order" : "Next"
            }()
            bottomButtonAction.action = NamedEvaluatorAction(name: name, action: nextAction)
        } else {
            bottomButtonAction.action = nil
        }
    }
    
    // MARK: Delivering Products Step
    
    func showDeliveryOptions(_ configuration: Evaluator.ChooseDeliveryLocationConfiguration) {
        
        // Assign values to our observable page data
        title.string = "Order for \(configuration.customer)"
        details.string = "\(configuration.products.count) of \(configuration.numberOfProductsRequested) \(pluralizedProduct(configuration.numberOfProductsRequested)) found"
        instruction.string = "Choose a Delivery Location"
        instructionNumber.int = 3
        deliveryOptions.array = configuration.deliveryLocationChoices
        deliveryPreference.string = configuration.deliveryLocationPreference ?? ""
        products.array = configuration.products
        
        // Say that only these things should appear in the body
        displaySections([.title, .instruction, .deliveryOptions, .details, .products])
        
        // Bottom button
        if let nextAction = configuration.nextAction {
            bottomButtonAction.action = NamedEvaluatorAction(name: "Deliver and Notify Customer", action: nextAction)
        } else {
            bottomButtonAction.action = nil
        }
    }
    
    // MARK: Completed Step
    
    func showCompleted(_ configuration: Evaluator.CompletedConfiguration) {
        
        // Assign values to our observable page data
        title.string = "Completed order for \(configuration.customer)"
        instruction.string = "Customer will be waiting at: \n\(configuration.deliveryLocation)"
        instructionNumber.int = 4
        products.array = configuration.products
        
        completedSummary.string =
        """
        Order completed at \(configuration.timeCompleted).
        \(configuration.products.count) \(pluralizedProduct(configuration.products.count)) found.
        Time to complete: \(configuration.elapsedTime) seconds.
        """
        
        // Say that only these things should appear in the body
        displaySections([.title, .instruction, .products, .completedSummary])
        
        // Bottom button
        bottomButtonAction.action = NamedEvaluatorAction(name: "Done", action: configuration.doneAction)
    }
    
    // MARK: Canceled Step
    
    func showCanceled(_ configuration: Evaluator.CanceledConfiguration) {
        // Assign values to our observable page data
        title.string = "Canceled order for \(configuration.customer)"
        instruction.string = "You're all set"
        instructionNumber.int = 3
        completedSummary.string =
        """
        Order canceled at \(configuration.timeCompleted).
        0 products found.
        Time to complete: \(configuration.elapsedTime) seconds.
        """
        
        // Say that only these things should appear in the body
        displaySections([.title, .instruction, .completedSummary])
        
        // Bottom button
        bottomButtonAction.action = NamedEvaluatorAction(name: "Done", action: configuration.doneAction)
    }
    
    func pluralizedProduct(_ count: Int) -> String {
        return (count == 1) ? "product" : "products"
    }
    
    // MARK: Sections
    func displaySections(_ newSections: [RetailTutorial.Page.Section]) {
        if let existingSections = self.sections.array as? [RetailTutorial.Page.Section] {
            if existingSections != newSections {
                self.sections.array = newSections
            }
        }
    }
    
}
