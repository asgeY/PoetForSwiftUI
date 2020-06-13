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

    class Translator: AlertTranslating, BezelTranslating, DismissTranslating {
        
        typealias Evaluator = Retail.Evaluator
        
        // ObservingPageViewSections
        enum Section: ObservingPageViewSection {
            case canceledTitle
            case completedTitle
            case completedSummary(completedSummary: ObservableString)
            case customerTitle(title: ObservableString)
            case deliveryOptions(deliveryOptions: ObservableArray<String>, deliveryPreference: ObservableString)
            case feedback(feedback: ObservableString)
            case displayableProducts(displayableProducts: ObservableArray<DisplayableProduct>)
            case divider
            case instruction(instructionNumber: ObservableInt, instruction: ObservableString)
            case topSpace
            case space
            
            var id: String {
                switch self {
                case .canceledTitle:                    return "canceledTitle"
                case .completedTitle:                   return "completedTitle"
                case .completedSummary(let a):          return "completedSummary_\(a.string)"
                case .customerTitle(let a):             return "customerTitle_\(a.string)"
                case .deliveryOptions(let a, let b):    return "deliveryOptions_\(a.array.first ?? "") _\(b.string)"
                case .feedback(let a):                  return "feedback_\(a.string)"
                case .displayableProducts(let a):       return "displayableProducts_\(a.array.first?.id ?? "")_\(a.array.last?.id ?? "")"
                case .divider:                          return "divider"
                case .instruction(let a, let b):        return "instruction_\(String(a.int))_\(b.string)"
                case .topSpace:                         return "topSpace"
                case .space:                            return "space"
                }
            }
        }
        
        // OBSERVABLE STATE
        
        // Observable Sections for PageViewMaker
        var sections = ObservableArray<ObservingPageViewSection>([])
        var customerTitle = ObservableString()
        var feedback = ObservableString()
        var instruction = ObservableString()
        var instructionNumber = ObservableInt()
        var deliveryOptions = ObservableArray<String>([])
        var deliveryPreference = ObservableString()
        var displayableProducts: ObservableArray<DisplayableProduct> = ObservableArray<DisplayableProduct>([])
        var completedSummary = ObservableString()
        
        // Bottom Button
        var bottomButtonAction: ObservableNamedEnabledEvaluatorAction = ObservableNamedEnabledEvaluatorAction()
        
        // Composed Translating
        var alertTranslator = AlertTranslator()
        var bezelTranslator = BezelTranslator()
        var dismissTranslator = DismissTranslator()
        
        // Step Sink
        var stepSink: Sink?
        
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
            debugPrint("init Retail Translator")
            dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .long
            numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.maximumSignificantDigits = 2
            numberFormatter.minimumSignificantDigits = 0
            stepSink = step.subject.sink { [weak self] value in
                self?.translate(step: value)
            }
        }
        
        deinit {
            debugPrint("deinit Retail Translator")
        }
    }
}

// MARK: Translating Steps

extension Retail.Translator {
    func translate(step: Evaluator.Step) {
        switch step {
            
        case .initial:
            break
            
        case .notStarted(let configuration):
            translateNotStarted(configuration)
            
        case .findProducts(let configuration):
            translateFindingProducts(configuration)
            
        case .chooseDeliveryLocation(let configuration):
            translateDeliveryOptions(configuration)
            
        case .completed(let configuration):
            translateCompleted(configuration)
            
        case .canceled(let configuration):
            translateCanceled(configuration)
            
        }
    }
    
    // MARK: Not Started Step
    
    func translateNotStarted(_ configuration: Evaluator.NotStartedConfiguration) {
        
        let productCount = configuration.products.count
        
        // Assign values to our observable page data
        customerTitle.string = "Order for \n\(configuration.customer)"
        feedback.string = "\(configuration.products.count) \(pluralizedProduct(productCount)) requested"
        instruction.string = "Tap start to claim this order"
        instructionNumber.int = 1
        
        displayableProducts.array = configuration.products.map({
            return DisplayableProduct(
                product: $0,
                findableProduct: nil
            )
        })
        
        // Only these things should appear in the body
        sections.array = [
            topSpace_,
            customerTitle_,
            instruction_,
            space_,
            divider_,
            space_,
            feedback_,
            space_,
            displayableProducts_
        ]
        
        // Bottom button
        bottomButtonAction.namedEnabledAction = NamedEnabledEvaluatorAction(name: "Start", enabled: true, action: configuration.startAction)
    }
    
    // MARK: Finding Products Step
    
    func translateFindingProducts(_ configuration: Evaluator.FindProductsConfiguration) {
        
        let foundCount = configuration.findableProducts.filter {$0.status == .found}.count
        
        // Assign values to our observable page data
        customerTitle.string = "Order for \n\(configuration.customer)"
        feedback.string = "\(foundCount) \(pluralizedProduct(foundCount)) marked found"
        instruction.string = "Mark found or not found"
        instructionNumber.int = 2
        
        withAnimation(Animation.linear(duration: 0.35)) {
            displayableProducts.array = configuration.findableProducts.map({
                return DisplayableProduct(
                    product: $0.product,
                    findableProduct: $0
                )
            })
            
            // Only these things should appear in the body
            sections.array = [
                topSpace_,
                customerTitle_,
                instruction_,
                space_,
                divider_,
                space_,
                feedback_,
                space_,
                displayableProducts_
            ]
        }
        
        // Bottom button
        if let nextAction = configuration.nextAction {
            let name = {
                nextAction == .advanceToCanceledStep ? "Cancel Order" : "Next"
            }()
            bottomButtonAction.namedEnabledAction = NamedEnabledEvaluatorAction(name: name, enabled: true, action: nextAction)
        } else {
            bottomButtonAction.namedEnabledAction = nil
        }
    }
    
    // MARK: Delivering Products Step
    
    func translateDeliveryOptions(_ configuration: Evaluator.ChooseDeliveryLocationConfiguration) {
        
        // Assign values to our observable page data
        customerTitle.string = "Order for \n\(configuration.customer)"
        feedback.string = "\(configuration.products.count) of \(configuration.numberOfProductsRequested) \(pluralizedProduct(configuration.numberOfProductsRequested)) found"
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
            sections.array = [
                topSpace_,
                customerTitle_,
                instruction_,
                deliveryOptions_,
                space_,
                divider_,
                space_,
                feedback_,
                space_,
                displayableProducts_
            ]
        }
        
        // Bottom button
        if let nextAction = configuration.nextAction {
            bottomButtonAction.namedEnabledAction = NamedEnabledEvaluatorAction(name: "Deliver and Notify Customer", enabled: true, action: nextAction)
        } else {
            bottomButtonAction.namedEnabledAction = nil
        }
    }
    
    // MARK: Completed Step
    
    func translateCompleted(_ configuration: Evaluator.CompletedConfiguration) {
        
        let productCount = configuration.products.count
        
        // Assign values to our observable page data
        customerTitle.string = title(for: configuration.customer)
        instruction.string = "Deliver to \(configuration.deliveryLocation)"
        instructionNumber.int = 4
        feedback.string = "\(productCount) \(pluralizedProduct(productCount)) fulfilled"
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
            sections.array = [
                topSpace_,
                completedTitle_,
                customerTitle_,
                instruction_,
                space_,
                divider_,
                space_,
                feedback_,
                space_,
                displayableProducts_,
                completedSummary_
            ]
        }
        
        // Bottom button
        bottomButtonAction.namedEnabledAction = NamedEnabledEvaluatorAction(name: "Done", enabled: true, action: configuration.doneAction)
    }
    
    // MARK: Canceled Step
    
    func translateCanceled(_ configuration: Evaluator.CanceledConfiguration) {
        
        // Assign values to our observable page data
        customerTitle.string = title(for: configuration.customer)
        instruction.string = "You're all set!"
        instructionNumber.int = 3
        feedback.string = "The customer has been notified that their order cannot be fulfilled."
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
            sections.array = [
                topSpace_,
                canceledTitle_,
                customerTitle_,
                instruction_,
                space_,
                divider_,
                space_,
                feedback_,
                space_,
                completedSummary_
            ]
        }
        
        // Bottom button
        bottomButtonAction.namedEnabledAction = NamedEnabledEvaluatorAction(name: "Done", enabled: true, action: configuration.doneAction)
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
        return .deliveryOptions(deliveryOptions: deliveryOptions, deliveryPreference: deliveryPreference)
    }
    
    var feedback_: Section {
        return .feedback(feedback: feedback)
    }
    
    var displayableProducts_: Section {
        return .displayableProducts(displayableProducts: displayableProducts)
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
    
    var space_: Section {
        return .space
    }
    
}
