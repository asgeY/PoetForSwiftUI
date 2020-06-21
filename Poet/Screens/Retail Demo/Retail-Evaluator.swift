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
        
        lazy var translator: Translator = Translator(current)
        
        // State
        
        var current = PassableState(State.initial)
        
        // Actions
        
        enum Action: EvaluatorAction {
            case startOrder
            case advanceToDelivery
            case advanceToCompleted
            case advanceToCanceled
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
        
        init() {
            debugPrint("init Retail Evaluator")
        }
        
        deinit {
            debugPrint("deinit Retail Evaluator")
        }
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
    
    enum State: EvaluatorState {
        case initial
        case notStarted(NotStartedState)
        case findProducts(FindProductsState)
        case chooseDeliveryLocation(ChooseDeliveryLocationState)
        case completed(CompletedState)
        case canceled(CanceledState)
    }
    
    // Configurations
    
    struct NotStartedState {
        var customer: String
        var instructions: [String]
        var orderID: String
        var products: [Product]
        var startAction: Action
    }
    
    struct FindProductsState {
        var customer: String
        var instructions: [String]
        var focusedInstructionIndex: Int
        var orderID: String
        var findableProducts: [FindableProduct]
        var startTime: Date
        var nextAction: Action?
    }
    
    struct ChooseDeliveryLocationState {
        var customer: String
        var instructions: [String]
        var focusedInstructionIndex: Int
        var orderID: String
        var products: [Product]
        var numberOfProductsRequested: Int
        var deliveryLocationChoices: [String]
        var deliveryLocationPreference: String?
        var startTime: Date
        var nextAction: Action?
    }
    
    struct CompletedState {
        var customer: String
        var instructions: [String]
        var focusedInstructionIndex: Int
        var orderID: String
        var deliveryLocation: String
        var products: [Product]
        var numberOfProductsRequested: Int
        var timeCompleted: Date
        var elapsedTime: TimeInterval
        var doneAction: Action
    }
    
    struct CanceledState {
        var customer: String
        var instructions: [String]
        var focusedInstructionIndex: Int
        var orderID: String
        var timeCompleted: Date
        var elapsedTime: TimeInterval
        var doneAction: Action
    }
}

// View Cycle

extension Retail.Evaluator: ViewCycleEvaluating {
    func viewDidAppear() {
        if case .initial = current.state {
            current.state = .notStarted(
                NotStartedState(
                    customer: "Bob Dobalina",
                    instructions: [
                        "Tap start to claim this order",
                        "Mark items found or not found",
                        "Choose a Delivery Location"
                    ],
                    orderID: order.id,
                    products: order.products,
                    startAction: Action.startOrder)
            )
        }
    }
}

// Actions

extension Retail.Evaluator: ActionEvaluating {
    
    func _evaluate(_ action: Action) {
        switch action {
        case .startOrder:
            startOrder()
            
        case .advanceToDelivery:
            advanceToDelivery()
            
        case .advanceToCompleted:
            advanceToCompleted()
            
        case .advanceToCanceled:
            advanceToCanceled()
            
        case .done:
            translator.dismiss.please()
        }
    }
    
    // MARK: Advancing Between States
    
    func startOrder() {
        guard case let .notStarted(currentState) = current.state else { return }
        
        // not implemented yet -- asynchronous network call
        // performer.claim(configuration.orderID) // handle success and failure
        
        let state = FindProductsState(
            customer: currentState.customer,
            instructions: currentState.instructions,
            focusedInstructionIndex: 1,
            orderID: currentState.orderID,
            findableProducts: currentState.products.map {
                return FindableProduct(
                    product: $0,
                    status: .unknown)
            },
            startTime: Date(),
            nextAction: nil
        )
        
        current.state = .findProducts(state)
    }
    
    func advanceToDelivery() {
        guard case let .findProducts(currentState) = current.state else { return }
        
        let state = ChooseDeliveryLocationState(
            customer: currentState.customer,
            instructions: currentState.instructions,
            focusedInstructionIndex: 2,
            orderID: currentState.orderID,
            products: currentState.findableProducts.compactMap {
                if $0.status == .found {
                    return $0.product
                } else {
                    return nil
                }
            },
            numberOfProductsRequested: currentState.findableProducts.count,
            deliveryLocationChoices: ["Cash Register", "Front Door"],
            deliveryLocationPreference: nil,
            startTime: currentState.startTime,
            nextAction: nil)
        
        current.state = .chooseDeliveryLocation(state)
    }
    
    func advanceToCompleted() {
        guard case let .chooseDeliveryLocation(currentState) = current.state else { return }
        
        let deliveryLocation = currentState.deliveryLocationPreference ?? "Unknown Location"
        let instructions = currentState.instructions + ["Deliver to \(deliveryLocation)"]
        
        let state = CompletedState(
            customer: currentState.customer,
            instructions: instructions,
            focusedInstructionIndex: 3,
            orderID: currentState.orderID,
            deliveryLocation: currentState.deliveryLocationPreference ?? "Unknown Location",
            products: currentState.products,
            numberOfProductsRequested: currentState.numberOfProductsRequested,
            timeCompleted: Date(),
            elapsedTime: abs(currentState.startTime.timeIntervalSinceNow),
            doneAction: .done
            )
        
        current.state = .completed(state)
    }
    
    func advanceToCanceled() {
        guard case let .findProducts(currentState) = current.state else { return }
        
        let instructions = currentState.instructions + ["You're all set!"]
        
        let state = CanceledState(
            customer: currentState.customer,
            instructions: instructions,
            focusedInstructionIndex: 3,
            orderID: currentState.orderID,
            timeCompleted: Date(),
            elapsedTime: abs(currentState.startTime.timeIntervalSinceNow),
            doneAction: .done
            )
        
        current.state = .canceled(state)
    }
}

// MARK: Finding Products Evaluator

extension Retail.Evaluator: FindingProductsEvaluating {
    func _toggleProductFound(_ product: FindableProduct) {
        guard case let .findProducts(currentState) = current.state else { return }
        
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
        
        updateFindableProduct(modifiedProduct, on: currentState)
        updateNextActionForFindableProducts()
    }
    
    func _toggleProductNotFound(_ product: FindableProduct) {
        guard case let .findProducts(currentState) = current.state else { return }
        
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
        
        updateFindableProduct(modifiedProduct, on: currentState)
        updateNextActionForFindableProducts()
    }
    
    private func updateFindableProduct(_ modifiedProduct: FindableProduct, on state: FindProductsState) {
        var modifiableState = state
        let findableProducts: [FindableProduct] = state.findableProducts.map {
            if $0.product.upc == modifiedProduct.product.upc {
                return modifiedProduct
            }
            return $0
        }
        
        modifiableState.findableProducts = findableProducts
        
        current.state = .findProducts(modifiableState)
    }
    
    private func updateNextActionForFindableProducts() {
        guard case var .findProducts(state) = current.state else { return }
        
        let ready = state.findableProducts.allSatisfy { (findableProduct) -> Bool in
            findableProduct.status != .unknown
        }
        
        if ready {
            let noneFound = state.findableProducts.allSatisfy { (findableProduct) -> Bool in
                findableProduct.status == .notFound
            }
            if noneFound {
                state.nextAction = .advanceToCanceled
            } else {
                state.nextAction = .advanceToDelivery
            }
        } else {
            state.nextAction = nil
        }
        
        current.state = .findProducts(state)
    }
}

// MARK: Options Evaluator

extension Retail.Evaluator: OptionsEvaluating {
    func _toggleOption(_ option: String) {
        guard case var .chooseDeliveryLocation(state) = current.state else { return }
        
        if option == state.deliveryLocationPreference {
            state.deliveryLocationPreference = nil
            state.nextAction = nil
        } else {
            state.deliveryLocationPreference = option
            state.nextAction = .advanceToCompleted
        }
        
        current.state = .chooseDeliveryLocation(state)
    }
}
