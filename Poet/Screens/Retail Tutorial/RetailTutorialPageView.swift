//
//  RetailTutorialPageView.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/29/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI
import Combine

protocol FindingProductsEvaluator: class {
    func toggleProductFound(_ product: FindableProduct)
    func toggleProductNotFound(_ product: FindableProduct)
}

protocol OptionsEvaluator: class {
    func toggleOption(_ option: String)
}

struct RetailTutorialPageView: View {
    @ObservedObject var pageSections: ObservableArray<RetailTutorial.Page.Section>
    @ObservedObject var title: ObservableString
    @ObservedObject var details: ObservableString
    @ObservedObject var instruction: ObservableString
    @ObservedObject var instructionNumber: ObservableInt
    @ObservedObject var products: ObservableArray<Product>
    @ObservedObject var findableProducts: ObservableArray<FindableProduct>
    @ObservedObject var deliveryOptions: ObservableArray<String>
    @ObservedObject var deliveryPreference: ObservableString
    @ObservedObject var completedSummary: ObservableString
    
    weak var findingProductsEvaluator: FindingProductsEvaluator?
    weak var optionsEvaluator: OptionsEvaluator?
    
    func view(for element: RetailTutorial.Page.Section) -> AnyView {
        switch element {
            
        case .title:
            return AnyView(
                Text(title.string)
                    .font(Font.system(size: 28, weight: .bold))
                    .multilineTextAlignment(.leading)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 30, trailing: 80))
            )
            
        case .details:
            return AnyView(
                Text(details.string)
                    .font(Font.system(.headline))
                    .opacity(0.33)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 18, trailing: 20))
            )
            
        case .instruction:
            return AnyView(
                InstructionView(instructionNumber: instructionNumber.int, instruction: instruction.string)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 18, trailing: 20))
            )
         
        case .products:
            return AnyView(
                VStack(alignment: .leading, spacing: 40) {
                    ForEach(products.array, id: \.upc) { product in
                        ProductView(product: product)
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
            )
            
        case .findableProducts:
            return AnyView(
                VStack(alignment: .leading, spacing: 40) {
                    ForEach(findableProducts.array, id: \.product.upc) { product in
                        FindableProductView(findableProduct: product, evaluator: self.findingProductsEvaluator)
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
            )
            
        case .deliveryOptions:
            return AnyView(
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(deliveryOptions.array, id: \.self) { option in
                        DeliveryOptionView(option: option, preference: self.deliveryPreference.string, evaluator: self.optionsEvaluator)
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
            )
            
        case .completedSummary:
            return AnyView(
                Text(completedSummary.string)
                .font(Font.system(.headline))
                .multilineTextAlignment(.leading)
                .opacity(0.33)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            )
        }
    }
    
    var body: some View {
        debugPrint("make Retail Tutorial Page View")
        if self.pageSections.array.isEmpty {
            return AnyView(EmptyView())
        } else {
            return AnyView(
                VStack() {
                    List(pageSections.array, id: \.id) { element in
                        VStack {
                            self.view(for: element)
                            if self.pageSections.array.firstIndex(of: element) == self.pageSections.array.count - 1 {
                                Spacer().frame(height:44)
                            }
                        }
                    }
                        .onAppear() {
                            UITableView.appearance().showsVerticalScrollIndicator = false
                            UITableView.appearance().separatorStyle = .none
                        }
                    Spacer()
                }
            )
        }
    }
}

struct InstructionView: View {
    var instructionNumber: Int
    var instruction: String
    
    var body: some View {
        HStack {
            Image(systemName: (instructionNumber <= 50) ? "\(instructionNumber).circle.fill" : ".circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.black)
                .frame(width: 20, height: 20)
                .padding(.trailing, 10)
            Text(instruction)
                .font(.system(.headline))
                .multilineTextAlignment(.leading)
        }
    }
}

struct ProductView: View {
    let product: Product
    
    var body: some View {
        debugPrint("make product view")
        return HStack {
            Image(product.image)
                .resizable()
                .frame(width: 80, height: 80)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
            VStack(alignment: .leading, spacing: 6) {
                Text(product.title)
                    .font(Font.system(.headline))
                    .lineLimit(2)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
                    .layoutPriority(20)
                Text(product.location)
                    .font(Font.system(.subheadline))
                    .lineLimit(1)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
                Text(product.upc)
                    .font(Font.system(.caption))
                    .lineLimit(1)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
            }.layoutPriority(10)
        }
    }
}

struct FindableProductView: View {
    let findableProduct: FindableProduct
    weak var evaluator: FindingProductsEvaluator?
    
    var body: some View {
        debugPrint("make findable product view")
        
        return VStack(alignment: .leading, spacing: 10) {
            ProductView(product: findableProduct.product)
            FoundNotFoundButtons(findableProduct: findableProduct, evaluator: evaluator)
        }
    }
}

struct FoundNotFoundButtons: View {
    let findableProduct: FindableProduct
    weak var evaluator: FindingProductsEvaluator?
    
    var body: some View {
        let isFound = findableProduct.status == .found
        let isNotFound = findableProduct.status == .notFound
        
        return GeometryReader() { geometry in
            ZStack {
                HStack {
                    Spacer()
                    SelectableCapsuleButton(
                        title: "Found",
                        isSelected: isFound,
                        action: { self.evaluator?.toggleProductFound(self.findableProduct) }
                    )
                    .layoutPriority(30)
                    Spacer()
                }
                .frame(width: geometry.size.width / 2.0)
                .offset(x: -geometry.size.width / 4.0, y: 0)
                
                HStack {
                    Spacer()
                    SelectableCapsuleButton(
                        title: "Not Found",
                        isSelected: isNotFound,
                        action: { self.evaluator?.toggleProductNotFound(self.findableProduct) }
                    )
                    .layoutPriority(30)
                    Spacer()
                }
                .frame(width: geometry.size.width / 2.0)
                .offset(x: geometry.size.width / 4.0, y: 0)
            }
        }.frame(height: 44)
    }
}

struct SelectableCapsuleButton: View {
    let title: String
    let isSelected: Bool
    let action: Action
    
    var body: some View {
        debugPrint("SelectableCapsuleButton body")
        return HStack(spacing: 0) {
            Image(systemName: "checkmark")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
                .frame(
                    width: self.isSelected ? 12 : 0,
                    height: self.isSelected ? 12 : 0)
                .padding(EdgeInsets(top: 0, leading: 14, bottom: 0, trailing: 0))
                .animation( self.isSelected ? (.spring(response: 0.4, dampingFraction: 0.4, blendDuration: 0.825)) : .linear(duration: 0.2), value: self.isSelected)
                .layoutPriority(30)
            Text(title)
                .font(Font.system(.headline))
                .foregroundColor( self.isSelected ? .white : .black)
                .padding(EdgeInsets(top: 8, leading: (isSelected ? 8 : 4), bottom: 8, trailing: 18))
                .layoutPriority(31)
        }
        .layoutPriority(30)
        .background(
            ZStack {
                BlurView()
                Rectangle()
                    .fill(Color.black.opacity( self.isSelected ? 0.95 : 0))
            }
            .mask(
                Capsule()
            )
            
        )
            .animation(.linear(duration: 0.2), value: self.isSelected)
        .onTapGesture {
            self.action?()
        }
    }
}

struct DeliveryOptionView: View {
    let option: String
    let preference: String
    weak var evaluator: OptionsEvaluator?
    
    var body: some View {
        debugPrint("make delivery option view. option: \(option). preference: \(preference)")
        return HStack(alignment: .center, spacing: 10) {
            Image(systemName: self.option == self.preference ? "checkmark.circle.fill" : "circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.black)
                .frame(width: 18, height: 18)
                .animation(.linear(duration: 0.2), value: self.preference)
            Text(self.option)
                .font(Font.headline)
        }
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
        .onTapGesture {
            self.evaluator?.toggleOption(self.option)
        }
    }
}
