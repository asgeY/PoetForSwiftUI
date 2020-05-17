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
        weak var evaluator: Evaluator?
        
        // ObservingPageViewSections
        enum Section: ObservingPageViewSection {
            case canceledTitle
            case completedTitle
            case completedSummary(completedSummary: ObservableString)
            case customerTitle(title: ObservableString)
            case deliveryOptions(deliveryOptions: ObservableArray<String>, deliveryPreference: ObservableString, optionsEvaluator: OptionsEvaluator?)
            case details(details: ObservableString)
            case displayableProducts(displayableProducts: ObservableArray<DisplayableProduct>, findingProductsEvaluator: FindingProductsEvaluator?)
            case divider
            case instruction(instructionNumber: ObservableInt, instruction: ObservableString)
            case topSpace
            
            var id: String {
                switch self {
                case .canceledTitle:        return "canceledTitle"
                case .completedTitle:       return "completedTitle"
                case .completedSummary:     return "completedSummary"
                case .customerTitle:        return "customerTitle"
                case .deliveryOptions:      return "deliveryOptions"
                case .details:              return "details"
                case .displayableProducts:  return "displayableProducts"
                case .divider:              return "divider"
                case .instruction:          return "instruction"
                case .topSpace:             return "topSpace"
                }
            }
        }
        
        // OBSERVABLE STATE
        
        // Observable Sections for PageViewMaker
        var sections = ObservableArray<ObservingPageViewSection>([])
        var customerTitle = ObservableString()
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
        
        init(_ step: PassableStep<Evaluator.Step>, evaluator: Evaluator) {
            self.evaluator = evaluator
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

// MARK: Translating Steps

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
        customerTitle.string = "Order for \n\(configuration.customer)"
        details.string = "\(configuration.products.count) \(pluralizedProduct(productCount)) requested"
        instruction.string = "Tap start to claim this order"
        instructionNumber.int = 1
        
        displayableProducts.array = configuration.products.map({
            return DisplayableProduct(
                product: $0,
                findableProduct: nil
            )
        })
        
        // Only these things should appear in the body
        showSections([
            topSpace_,
            customerTitle_,
            instruction_,
            divider_,
            details_,
            displayableProducts_
        ])
        
        // Bottom button
        bottomButtonAction.action = NamedEvaluatorAction(name: "Start", action: configuration.startAction)
    }
    
    // MARK: Finding Products Step
    
    func showFindingProducts(_ configuration: Evaluator.FindProductsConfiguration) {
        
        let foundCount = configuration.findableProducts.filter {$0.status == .found}.count
        
        // Assign values to our observable page data
        customerTitle.string = "Order for \n\(configuration.customer)"
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
            
            // Only these things should appear in the body
            showSections([
                topSpace_,
                customerTitle_,
                instruction_,
                divider_,
                details_,
                displayableProducts_
            ])
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
        customerTitle.string = "Order for \n\(configuration.customer)"
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
        
            // Only these things should appear in the body
            showSections([
                topSpace_,
                customerTitle_,
                instruction_,
                deliveryOptions_,
                divider_,
                details_,
                displayableProducts_
            ])
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
        customerTitle.string = title(for: configuration.customer)
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
            showSections([
                topSpace_,
                completedTitle_,
                customerTitle_,
                instruction_,
                divider_,
                details_,
                displayableProducts_,
                completedSummary_
            ])
        }
        
        // Bottom button
        bottomButtonAction.action = NamedEvaluatorAction(name: "Done", action: configuration.doneAction)
    }
    
    // MARK: Canceled Step
    
    func showCanceled(_ configuration: Evaluator.CanceledConfiguration) {
        
        // Assign values to our observable page data
        customerTitle.string = title(for: configuration.customer)
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
            showSections([
                topSpace_,
                canceledTitle_,
                customerTitle_,
                instruction_,
                divider_,
                details_,
                completedSummary_
            ])
        }
        
        // Bottom button
        bottomButtonAction.action = NamedEvaluatorAction(name: "Done", action: configuration.doneAction)
    }
}

// MARK: Text and Styling
 
extension Retail.Translator {
    func pluralizedProduct(_ count: Int) -> String {
        return (count == 1) ? "product" : "products"
    }
    
    func title(for customer: String) -> String {
        return "Order for \n\(customer)"
    }
}
    
// MARK: Sections

extension Retail.Translator {
    func showSections(_ newSections: [Section]) {
        self.sections.array = newSections
    }
    
    var canceledTitle_: Section {
        return .canceledTitle
    }
    
    var completedSummary_: Section {
        return .completedSummary(completedSummary: completedSummary)
    }
    
    var completedTitle_: Section {
        return .completedTitle
    }
    
    var customerTitle_: Section {
        return .customerTitle(title: customerTitle)
    }
    
    var deliveryOptions_: Section {
        return .deliveryOptions(deliveryOptions: deliveryOptions, deliveryPreference: deliveryPreference, optionsEvaluator: evaluator)
    }
    
    var details_: Section {
        return .details(details: details)
    }
    
    var displayableProducts_: Section {
        return .displayableProducts(displayableProducts: displayableProducts, findingProductsEvaluator: evaluator)
    }
    
    var divider_: Section {
        return .divider
    }
    
    var instruction_: Section {
        return .instruction(instructionNumber: instructionNumber, instruction: instruction)
    }
    
    var topSpace_: Section {
        return .topSpace
    }
    
}
