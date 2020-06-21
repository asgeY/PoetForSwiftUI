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

    class Translator {
        
        typealias Evaluator = Retail.Evaluator
        typealias Action = Evaluator.Action
        typealias Section = Retail.ViewMaker.Section
        
        // OBSERVABLE STATE
        
        // Observable Sections for PageViewMaker
        var sections = ObservableArray<Section>([])
        var customerTitle = ObservableString()
        var feedback = ObservableString()
        var instructions = ObservableArray<String>([])
        var focusedInstructionIndex = Observable<Int?>()
        var allowsCollapsingAndExpanding = ObservableBool()
        var deliveryOptions = ObservableArray<String>([])
        var deliveryPreference = ObservableString()
        var displayableProducts: ObservableArray<DisplayableProduct> = ObservableArray<DisplayableProduct>([])
        var completedSummary = ObservableString()
        
        // Bottom Button
        var bottomButtonAction: Observable<NamedEnabledEvaluatorAction<Action>?> = Observable<NamedEnabledEvaluatorAction<Action>?>(nil)
        
        // Passable
        var dismiss = PassablePlease()
        
        // State Sink
        var stateSink: Sink?
        
        // Formatter
        var dateFormatter: DateFormatter
        var numberFormatter: NumberFormatter
        
        init(_ state: PassableState<Evaluator.State>) {
            debugPrint("init Retail Translator")
            dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .long
            numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.maximumSignificantDigits = 2
            numberFormatter.minimumSignificantDigits = 0
            stateSink = state.subject.sink { [weak self] value in
                self?.translate(state: value)
            }
        }
        
        deinit {
            debugPrint("deinit Retail Translator")
        }
    }
}

// Display Type
struct DisplayableProduct {
    var product: Product
    var findableProduct: FindableProduct?
    var id: String { return product.upc }
}

// MARK: Translating States

extension Retail.Translator {
    func translate(state: Evaluator.State) {
        switch state {
            
        case .initial:
            break
            
        case .notStarted(let state):
            translateNotStarted(state)
            
        case .findProducts(let state):
            translateFindingProducts(state)
            
        case .chooseDeliveryLocation(let state):
            translateDeliveryOptions(state)
            
        case .completed(let state):
            translateCompleted(state)
            
        case .canceled(let state):
            translateCanceled(state)
            
        }
    }
    
    // MARK: Not Started
    
    func translateNotStarted(_ state: Evaluator.NotStartedState) {
        
        let productCount = state.products.count
        
        // Assign values to our observable page data
        customerTitle.string = "Order for \n\(state.customer)"
        feedback.string = "\(state.products.count) \(pluralizedProduct(productCount)) requested"
        instructions.array = state.instructions
        focusedInstructionIndex.value = nil
        allowsCollapsingAndExpanding.bool = false
        
        displayableProducts.array = state.products.map({
            return DisplayableProduct(
                product: $0,
                findableProduct: nil
            )
        })
        
        // Only these things should appear in the body
        sections.array = [
            topSpace_,
            customerTitle_,
            __,
            instructions_,
            divider_,
            feedback_,
            __,
            displayableProducts_
        ]
        
        // Bottom button
        bottomButtonAction.value = NamedEnabledEvaluatorAction(name: "Start", enabled: true, action: state.startAction)
    }
    
    // MARK: Finding Products
    
    func translateFindingProducts(_ state: Evaluator.FindProductsState) {
        
        let foundCount = state.findableProducts.filter {$0.status == .found}.count
        
        // Assign values to our observable page data
        customerTitle.string = "Order for \n\(state.customer)"
        feedback.string = "\(foundCount) \(pluralizedProduct(foundCount)) marked found"
        
        withAnimation(Animation.linear(duration: 0.35)) {
            instructions.array = state.instructions
            focusedInstructionIndex.value = state.focusedInstructionIndex
            allowsCollapsingAndExpanding.bool = true
            
            displayableProducts.array = state.findableProducts.map({
                return DisplayableProduct(
                    product: $0.product,
                    findableProduct: $0
                )
            })
            
            // Only these things should appear in the body
            sections.array = [
                topSpace_,
                customerTitle_,
                __,
                instructions_,
                divider_,
                feedback_,
                __,
                displayableProducts_
            ]
        }
        
        // Bottom button
        if let nextAction = state.nextAction {
            let name = {
                nextAction == .advanceToCanceled ? "Cancel Order" : "Next"
            }()
            bottomButtonAction.value = NamedEnabledEvaluatorAction(name: name, enabled: true, action: nextAction)
        } else {
            bottomButtonAction.value = nil
        }
    }
    
    // MARK: Delivering Products
    
    func translateDeliveryOptions(_ state: Evaluator.ChooseDeliveryLocationState) {
        
        // Assign values to our observable page data
        customerTitle.string = "Order for \n\(state.customer)"
        feedback.string = "\(state.products.count) of \(state.numberOfProductsRequested) \(pluralizedProduct(state.numberOfProductsRequested)) found"
        deliveryOptions.array = state.deliveryLocationChoices
        deliveryPreference.string = state.deliveryLocationPreference ?? ""
        
        withAnimation(.linear) {
            instructions.array = state.instructions
            focusedInstructionIndex.value = state.focusedInstructionIndex
            allowsCollapsingAndExpanding.bool = true

            displayableProducts.array = state.products.map({
                return DisplayableProduct(
                    product: $0,
                    findableProduct: nil
                )
            })
        
            // Only these things should appear in the body
            sections.array = [
                topSpace_,
                customerTitle_,
                __,
                instructions_,
                deliveryOptions_,
                divider_,
                feedback_,
                __,
                displayableProducts_
            ]
        }
        
        // Bottom button
        if let nextAction = state.nextAction {
            bottomButtonAction.value = NamedEnabledEvaluatorAction(name: "Deliver and Notify Customer", enabled: true, action: nextAction)
        } else {
            bottomButtonAction.value = nil
        }
    }
    
    // MARK: Completed
    
    func translateCompleted(_ state: Evaluator.CompletedState) {
        
        let productCount = state.products.count
        
        // Assign values to our observable page data
        customerTitle.string = title(for: state.customer)
        feedback.string = "\(productCount) \(pluralizedProduct(productCount)) fulfilled"
        let timeNumber = NSNumber(floatLiteral: state.elapsedTime)
        let timeString = numberFormatter.string(from: timeNumber)
        
        completedSummary.string =
        """
        Order completed on \(dateFormatter.string(from: state.timeCompleted)).
        \(productCount) of \(state.numberOfProductsRequested) \(pluralizedProduct(state.numberOfProductsRequested)) found.
        Time to complete: \(timeString ?? String(state.elapsedTime)) seconds.
        """
        
        withAnimation(.linear) {
            instructions.array = state.instructions
            focusedInstructionIndex.value = state.focusedInstructionIndex
            allowsCollapsingAndExpanding.bool = true
            
            displayableProducts.array = state.products.map({
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
                __,
                instructions_,
                divider_,
                feedback_,
                __,
                displayableProducts_,
                divider_,
                completedSummary_
            ]
        }
        
        // Bottom button
        bottomButtonAction.value = NamedEnabledEvaluatorAction(name: "Done", enabled: true, action: state.doneAction)
    }
    
    // MARK: Canceled
    
    func translateCanceled(_ state: Evaluator.CanceledState) {
        
        // Assign values to our observable page data
        customerTitle.string = title(for: state.customer)
        feedback.string = "The customer has been notified that their order cannot be fulfilled."
        let timeNumber = NSNumber(floatLiteral: state.elapsedTime)
        let timeString = numberFormatter.string(from: timeNumber)
        
        completedSummary.string =
        """
        Order canceled on \(dateFormatter.string(from: state.timeCompleted)).
        0 products found.
        Time to complete: \(timeString ?? String(state.elapsedTime)) seconds.
        """
        
        // Say that only these things should appear in the body
        withAnimation(.linear) {
            instructions.array = state.instructions
            focusedInstructionIndex.value = state.focusedInstructionIndex
            allowsCollapsingAndExpanding.bool = true
            
            sections.array = [
                topSpace_,
                canceledTitle_,
                customerTitle_,
                __,
                instructions_,
                divider_,
                feedback_,
                __,
                divider_,
                completedSummary_
            ]
        }
        
        // Bottom button
        bottomButtonAction.value = NamedEnabledEvaluatorAction(name: "Done", enabled: true, action: state.doneAction)
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
        return .options(options: deliveryOptions, preference: deliveryPreference)
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
    
    var instructions_: Section {
        return Section.instructions(instructions: instructions, focusableInstructionIndex: focusedInstructionIndex, allowsCollapsingAndExpanding: allowsCollapsingAndExpanding)
    }
    
    var topSpace_: Section {
        return .topSpace
    }
    
    var __: Section {
        return .space
    }
    
}
