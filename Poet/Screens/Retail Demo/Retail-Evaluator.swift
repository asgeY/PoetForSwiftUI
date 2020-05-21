//
//  Retail-Evaluator.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/29/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine
import SwiftUI

extension Retail {
    class Evaluator {
        
        // Translator
        
        lazy var translator: Translator = Translator(current, evaluator: self)
        
        // Step
        
        var current = PassableStep(Step.loading)
        
        // ButtonAction
        
        enum ButtonAction: EvaluatorAction {
            case startOrder
            case advanceToDeliveryStep
            case advanceToCompletedStep
            case advanceToCanceledStep
            case done
        }
        
        // Data
        var order: Order = Order(
            id: "6398327",
            products: [
            Product(
                title: "MacBook Pro 13” 1TB",
                upc: "885909918161",
                image: "macbookpro13",
                location: "Bin 1A"),
            
            Product(
                title: "iPad Pro 11” 128gb",
                upc: "888462533391",
                image: "ipadpro11",
                location: "Bin 2B"),
            
            Product(
                title: "Magic Keyboard for iPad Pro 11”",
                upc: "888462153501",
                image: "magickeyboard11",
                location: "Bin 3A"),

            Product(
                title: "Airpods Pro",
                upc: "190199246850",
                image: "airpodspro",
                location: "Bin 2C"),
            ]
        )
    }
}

// MARK: Data Types

struct Order {
    var id: String
    var products: [Product]
}

struct Product {
    var title: String
    var upc: String
    var image: String
    var location: String
}

struct FindableProduct {
    var product: Product
    var status: FoundStatus
    
    enum FoundStatus {
        case unknown
        case found
        case notFound
    }
}

extension Retail.Evaluator {
    
    enum Step: EvaluatorStep {
        case loading
        case notStarted(NotStartedConfiguration)
        case findProducts(FindProductsConfiguration)
        case chooseDeliveryLocation(ChooseDeliveryLocationConfiguration)
        case completed(CompletedConfiguration)
        case canceled(CanceledConfiguration)
    }
    
    // Configurations
    
    struct NotStartedConfiguration {
        var customer: String
        var orderID: String
        var products: [Product]
        var startAction: ButtonAction
    }
    
    struct FindProductsConfiguration {
        var customer: String
        var orderID: String
        var findableProducts: [FindableProduct]
        var startTime: Date
        var nextAction: ButtonAction?
    }
    
    struct ChooseDeliveryLocationConfiguration {
        var customer: String
        var orderID: String
        var products: [Product]
        var numberOfProductsRequested: Int
        var deliveryLocationChoices: [String]
        var deliveryLocationPreference: String?
        var startTime: Date
        var nextAction: ButtonAction?
    }
    
    struct CompletedConfiguration {
        var customer: String
        var orderID: String
        var deliveryLocation: String
        var products: [Product]
        var numberOfProductsRequested: Int
        var timeCompleted: Date
        var elapsedTime: TimeInterval
        var doneAction: ButtonAction
    }
    
    struct CanceledConfiguration {
        var customer: String
        var orderID: String
        var timeCompleted: Date
        var elapsedTime: TimeInterval
        var doneAction: ButtonAction
    }
}

// View Cycle

extension Retail.Evaluator: ViewCycleEvaluator {
    func viewDidAppear() {
        if case .loading = current.step {
            current.step = .notStarted(
                NotStartedConfiguration(
                    customer: "Bob Dobalina",
                    orderID: order.id,
                    products: order.products,
                    startAction: ButtonAction.startOrder)
            )
        }
    }
}

// Actions

extension Retail.Evaluator: ButtonEvaluating {
    
    func buttonTapped(action: EvaluatorAction?) {
        guard let action = action as? ButtonAction else { return }
        
        switch action {
        case .startOrder:
            startOrder()
            
        case .advanceToDeliveryStep:
            advanceToDeliveryStep()
            
        case .advanceToCompletedStep:
            advanceToCompletedStep()
            
        case .advanceToCanceledStep:
            advanceToCanceledStep()
            
        case .done:
            translator.dismissTranslator.dismiss.please()
        }
    }
    
    // MARK: Advancing Between Steps
    
    func startOrder() {
        if case let .notStarted(configuration) = current.step {
            
            // not implemented yet -- asynchronous network call
            // performer.claim(configuration.orderID) // handle success and failure
            
            let newConfiguration = FindProductsConfiguration(
                customer: configuration.customer,
                orderID: configuration.orderID,
                findableProducts: configuration.products.map {
                    return FindableProduct(
                        product: $0,
                        status: .unknown)
                },
                startTime: Date(),
                nextAction: nil
            )
            
            current.step = .findProducts(newConfiguration)
        }
    }
    
    func advanceToDeliveryStep() {
        guard case let .findProducts(configuration) = current.step else { return }
        
        let newConfiguration = ChooseDeliveryLocationConfiguration(
            customer: configuration.customer,
            orderID: configuration.orderID,
            products: configuration.findableProducts.compactMap {
                if $0.status == .found {
                    return $0.product
                } else {
                    return nil
                }
            },
            numberOfProductsRequested: configuration.findableProducts.count,
            deliveryLocationChoices: ["Cash Register", "Front Door"],
            deliveryLocationPreference: nil,
            startTime: configuration.startTime,
            nextAction: nil)
        
        current.step = .chooseDeliveryLocation(newConfiguration)
    }
    
    func advanceToCompletedStep() {
        guard case let .chooseDeliveryLocation(configuration) = current.step else { return }
        
        let newConfiguration = CompletedConfiguration(
            customer: configuration.customer,
            orderID: configuration.orderID,
            deliveryLocation: configuration.deliveryLocationPreference ?? "Unknown Location",
            products: configuration.products,
            numberOfProductsRequested: configuration.numberOfProductsRequested,
            timeCompleted: Date(),
            elapsedTime: abs(configuration.startTime.timeIntervalSinceNow),
            doneAction: .done
            )
        
        current.step = .completed(newConfiguration)
    }
    
    func advanceToCanceledStep() {
        guard case let .findProducts(configuration) = current.step else { return }
        
        let newConfiguration = CanceledConfiguration(
            customer: configuration.customer,
            orderID: configuration.orderID,
            timeCompleted: Date(),
            elapsedTime: abs(configuration.startTime.timeIntervalSinceNow),
            doneAction: .done
            )
        
        current.step = .canceled(newConfiguration)
    }
}

// MARK: Finding Products Evaluator

extension Retail.Evaluator: FindingProductsEvaluator {
    func toggleProductFound(_ product: FindableProduct) {
        guard case let Step.findProducts(configuration) = current.step else { return }
        
        // Toggle status
        
        var modifiedProduct = product
        modifiedProduct.status = {
            switch modifiedProduct.status {
            case .found:
                return .unknown
            case .notFound, .unknown:
                return .found
            }
        }()
        
        updateFindableProduct(modifiedProduct, on: configuration)
        updateNextActionForFindableProducts()
    }
    
    func toggleProductNotFound(_ product: FindableProduct) {
        guard case let Step.findProducts(configuration) = current.step else { return }
        
        // Toggle status
        
        var modifiedProduct = product
        modifiedProduct.status = {
            switch modifiedProduct.status {
            case .notFound:
                return .unknown
            case .found, .unknown:
                return .notFound
            }
        }()
        
        updateFindableProduct(modifiedProduct, on: configuration)
        updateNextActionForFindableProducts()
    }
    
    private func updateFindableProduct(_ modifiedProduct: FindableProduct, on configuration: FindProductsConfiguration) {
        var modifiedConfiguration = configuration
        let findableProducts: [FindableProduct] = configuration.findableProducts.map {
            if $0.product.upc == modifiedProduct.product.upc {
                return modifiedProduct
            }
            return $0
        }
        
        modifiedConfiguration.findableProducts = findableProducts
        
        current.step = .findProducts(modifiedConfiguration)
    }
    
    private func updateNextActionForFindableProducts() {
        guard case var Step.findProducts(configuration) = current.step else { return }
        
        let ready = configuration.findableProducts.allSatisfy { (findableProduct) -> Bool in
            findableProduct.status != .unknown
        }
        
        if ready {
            let noneFound = configuration.findableProducts.allSatisfy { (findableProduct) -> Bool in
                findableProduct.status == .notFound
            }
            if noneFound {
                configuration.nextAction = .advanceToCanceledStep
            } else {
                configuration.nextAction = .advanceToDeliveryStep
            }
        } else {
            configuration.nextAction = nil
        }
        
        current.step = .findProducts(configuration)
    }
}

// MARK: Options Evaluator

extension Retail.Evaluator: OptionsEvaluator {
    func toggleOption(_ option: String) {
        guard case var Step.chooseDeliveryLocation(configuration) = current.step else { return }
        
        if option == configuration.deliveryLocationPreference {
            configuration.deliveryLocationPreference = nil
            configuration.nextAction = nil
        } else {
            configuration.deliveryLocationPreference = option
            configuration.nextAction = .advanceToCompletedStep
        }
        
        current.step = .chooseDeliveryLocation(configuration)
    }
}
