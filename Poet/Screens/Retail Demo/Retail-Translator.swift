//
//  Retail-Translator.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/29/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation
import SwiftUI

extension Retail {

    class Translator: AlertTranslating, CharacterBezelTranslating, DismissTranslating {
        
        typealias Evaluator = Retail.Evaluator
        
        // ObservingPageViewSections
        enum Section: String, ObservingPageViewSection {
            case canceledTitle
            case completedTitle
            case completedSummary
            case customerTitle
            case deliveryOptions
            case details
            case displayableProducts
            case divider
            case instruction
            case space
            case topSpace
            
            var id: String {
                return rawValue
            }
        }
        
        // OBSERVABLE STATE
        
        // Observable Sections for PageViewMaker
        var sections = ObservableArray<ObservingPageViewSection>([])
        var title = ObservableString()
        var details = ObservableString()
        var instruction = ObservableString()
        var instructionNumber = ObservableInt()
        var deliveryOptions = ObservableArray<String>([])
        var deliveryPreference = ObservableString()
        var displayableProducts: ObservableArray<DisplayableProduct> = ObservableArray<DisplayableProduct>([])
        var products: ObservableArray<Product> = ObservableArray<Product>([])
        var findableProducts: ObservableArray<FindableProduct> = ObservableArray<FindableProduct>([])
        var completedSummary = ObservableString()
        
        // Bottom Button
        var bottomButtonAction: ObservableNamedEvaluatorAction = ObservableNamedEvaluatorAction()
        
        // Composed Translating
        var alertTranslator = AlertTranslator()
        var characterBezelTranslator = CharacterBezelTranslator()
        var dismissTranslator = DismissTranslator()
        
        // Passthrough Behavior
        var behavior: Behavior?
        
        // Formatter
        var dateFormatter: DateFormatter
        var numberFormatter: NumberFormatter
        
        // Display Type
        struct DisplayableProduct {
            var product: Product
            var findableProduct: FindableProduct?
            var id: String { return product.upc }
        }
        
        init(_ step: PassableStep<Evaluator.Step>) {
            dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .long
            numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.maximumSignificantDigits = 2
            numberFormatter.minimumSignificantDigits = 0
            behavior = step.subject.sink { value in
                self.translate(step: value)
            }
        }
    }
}

extension Retail.Translator {
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
        
        let productCount = configuration.products.count
        
        // Assign values to our observable page data
        title.string = "Order for \n\(configuration.customer)"
        details.string = "\(configuration.products.count) \(pluralizedProduct(productCount)) requested"
        instruction.string = "Tap start to claim this order"
        instructionNumber.int = 1
        
        displayableProducts.array = configuration.products.map({
            return DisplayableProduct(
                product: $0,
                findableProduct: nil
            )
        })
        
        // Say that only these things should appear in the body
        displaySections([.topSpace, .customerTitle, .instruction, .divider, .details, .displayableProducts])
        
        // Bottom button
        bottomButtonAction.action = NamedEvaluatorAction(name: "Start", action: configuration.startAction)
    }
    
    // MARK: Finding Products Step
    
    func showFindingProducts(_ configuration: Evaluator.FindProductsConfiguration) {
        
        let foundCount = configuration.findableProducts.filter {$0.status == .found}.count
        
        // Assign values to our observable page data
        title.string = "Order for \n\(configuration.customer)"
        details.string = "\(foundCount) \(pluralizedProduct(foundCount)) marked found"
        instruction.string = "Mark found or not found"
        instructionNumber.int = 2
        
        withAnimation(Animation.linear(duration: 0.3)) {
            displayableProducts.array = configuration.findableProducts.map({
                return DisplayableProduct(
                    product: $0.product,
                    findableProduct: $0
                )
            })
            
            // Say that only these things should appear in the body
            displaySections([.topSpace, .customerTitle, .instruction, .divider, .details, .displayableProducts])
        }
        
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
        title.string = "Order for \n\(configuration.customer)"
        details.string = "\(configuration.products.count) of \(configuration.numberOfProductsRequested) \(pluralizedProduct(configuration.numberOfProductsRequested)) found"
        instruction.string = "Choose a Delivery Location"
        instructionNumber.int = 3
        deliveryOptions.array = configuration.deliveryLocationChoices
        deliveryPreference.string = configuration.deliveryLocationPreference ?? ""
        
        withAnimation(.linear) {
            displayableProducts.array = configuration.products.map({
                return DisplayableProduct(
                    product: $0,
                    findableProduct: nil
                )
            })
        }
        
        // Say that only these things should appear in the body
        withAnimation(.linear) {
            displaySections([.topSpace, .customerTitle, .instruction, .deliveryOptions, .divider, .details, .displayableProducts])
        }
        
        // Bottom button
        if let nextAction = configuration.nextAction {
            bottomButtonAction.action = NamedEvaluatorAction(name: "Deliver and Notify Customer", action: nextAction)
        } else {
            bottomButtonAction.action = nil
        }
    }
    
    // MARK: Completed Step
    
    func showCompleted(_ configuration: Evaluator.CompletedConfiguration) {
        
        let productCount = configuration.products.count
        
        // Assign values to our observable page data
        title.string = title(for: configuration.customer)
        instruction.string = "Deliver to \(configuration.deliveryLocation)"
        instructionNumber.int = 4
        details.string = "\(productCount) \(pluralizedProduct(productCount)) fulfilled"
        let timeNumber = NSNumber(floatLiteral: configuration.elapsedTime)
        let timeString = numberFormatter.string(from: timeNumber)
        
        completedSummary.string =
        """
        Order completed on \(dateFormatter.string(from: configuration.timeCompleted)).
        \(productCount) of \(configuration.numberOfProductsRequested) \(pluralizedProduct(configuration.numberOfProductsRequested)) found.
        Time to complete: \(timeString ?? String(configuration.elapsedTime)) seconds.
        """
        
        withAnimation(.linear) {
            displayableProducts.array = configuration.products.map({
                return DisplayableProduct(
                    product: $0,
                    findableProduct: nil
                )
            })
        
            // Say that only these things should appear in the body
            displaySections([.topSpace, .completedTitle, .customerTitle, .instruction, .divider, .details, .displayableProducts, .completedSummary])
        }
        
        // Bottom button
        bottomButtonAction.action = NamedEvaluatorAction(name: "Done", action: configuration.doneAction)
    }
    
    // MARK: Canceled Step
    
    func showCanceled(_ configuration: Evaluator.CanceledConfiguration) {
        
        // Assign values to our observable page data
        title.string = title(for: configuration.customer)
        instruction.string = "You're all set!"
        instructionNumber.int = 3
        details.string = "The customer has been notified that their order cannot be fulfilled."
        let timeNumber = NSNumber(floatLiteral: configuration.elapsedTime)
        let timeString = numberFormatter.string(from: timeNumber)
        
        completedSummary.string =
        """
        Order canceled on \(dateFormatter.string(from: configuration.timeCompleted)).
        0 products found.
        Time to complete: \(timeString ?? String(configuration.elapsedTime)) seconds.
        """
        
        // Say that only these things should appear in the body
        withAnimation(.linear) {
            displaySections([.topSpace, .canceledTitle, .customerTitle, .instruction, .divider, .details, .completedSummary])
        }
        
        // Bottom button
        bottomButtonAction.action = NamedEvaluatorAction(name: "Done", action: configuration.doneAction)
    }
    
    // Text and Styling
    
    func pluralizedProduct(_ count: Int) -> String {
        return (count == 1) ? "product" : "products"
    }
    
    func title(for customer: String) -> String {
        return "Order for \n\(customer)"
    }
    
    // MARK: Sections
    func displaySections(_ newSections: [Section]) {
        self.sections.array = newSections
    }
    
}
