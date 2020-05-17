//
//  Retail-Page-Views.swift
//  Poet
//
//  Created by Steve Cotner on 5/1/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine
import SwiftUI

struct InstructionView: View {
    @ObservedObject var instructionNumber: ObservableInt
    @ObservedObject var instruction: ObservableString
    
    var body: some View {
        HStack {
            ZStack(alignment: .topLeading) {
                Image.numberCircleFill(instructionNumber.int)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.primary)
                    .frame(width: 24, height: 24)
                    .padding(EdgeInsets(top: 0, leading: 39.5, bottom: 0, trailing: 0))
                    .offset(x: 0, y: -2)
                Text(instruction.string)
                    .font(Font.system(size: 17, weight: .bold).monospacedDigit())
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(EdgeInsets(top: 0, leading: 76, bottom: 0, trailing: 76))
            }
            Spacer()
        }
    }
}

struct ProductView: View {
    let product: Product
    
    var body: some View {
        debugPrint("ProductView. upc: \(product.upc)")
        return HStack {
            Image(product.image)
                .resizable()
                .frame(width: 80, height: 80)
                .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 0))
            VStack(alignment: .leading, spacing: 6) {
                Text(product.title)
                    .font(Font.system(.headline))
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .layoutPriority(20)
                Text(product.location)
                    .font(Font.system(.subheadline))
                    .lineLimit(1)
                    .fixedSize(horizontal: false, vertical: true)
                Text(product.upc)
                    .font(Font.system(.caption))
                    .lineLimit(1)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 40))
            .layoutPriority(10)
            Spacer()
        }
    }
}

struct ProductsView: View {
    @ObservedObject var products: ObservableArray<Product>

    var body: some View {
        VStack(alignment: .leading, spacing: 40) {
            ForEach(products.array, id: \.upc) { product in
                ProductView(product: product)
            }
        }
    }
}

struct FindableProductsView: View {
    @ObservedObject var findableProducts: ObservableArray<FindableProduct>
    weak var evaluator: FindingProductsEvaluator?

    var body: some View {
        debugPrint("FindableProductsView")
        return VStack(alignment: .leading, spacing: 40) {
            ForEach(findableProducts.array, id: \.product.upc) { findableProduct in
                return VStack(alignment: .leading, spacing: 10) {
                    ProductView(product: findableProduct.product)
                    FoundNotFoundButtonsOld(findableProduct: findableProduct, evaluator: self.evaluator)
                }
            }
        }
    }
}

struct DisplayableProductsView: View {
    @ObservedObject var displayableProducts: ObservableArray<Retail.Translator.DisplayableProduct>
    weak var evaluator: FindingProductsEvaluator?
    
    var body: some View {
        debugPrint("DisplayableProductsView")
        return VStack(alignment: .leading, spacing: 40) {
            ForEach(displayableProducts.array, id: \.id) { displayableProduct in
                return HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        ProductView(product: displayableProduct.product)
                        if displayableProduct.showsFindingButtons {
                            FoundNotFoundButtons(displayableProduct: displayableProduct, evaluator: self.evaluator)
                                .padding(EdgeInsets(top: 5, leading: 20, bottom: 0, trailing: 20))
                                .transition(.opacity)
                        }
                    }
                    Spacer()
                }
            }
            Spacer()
        }
    }
}

struct FoundNotFoundButtonsOld: View {
    let findableProduct: FindableProduct
    weak var evaluator: FindingProductsEvaluator?
    
    var body: some View {
        debugPrint("FoundNotFoundButtons. upc: \(findableProduct.product.upc)")
        let isFound = findableProduct.status == .found
        let isNotFound = findableProduct.status == .notFound
        
        return GeometryReader() { geometry in
            ZStack {
                HStack {
                    SelectableCapsuleButton(
                        title: "Found",
                        isSelected: isFound,
                        imageName: "checkmark",
                        action: { self.evaluator?.toggleProductFound(self.findableProduct) }
                    )
                    .layoutPriority(30)
                }
                .frame(width: geometry.size.width / 2.0)
                .offset(x: 0, y: 0)
                
                HStack {
                    SelectableCapsuleButton(
                        title: "Not Found",
                        isSelected: isNotFound,
                        imageName: "xmark",
                        action: { self.evaluator?.toggleProductNotFound(self.findableProduct) }
                    )
                    .layoutPriority(30)
                }
                .frame(width: geometry.size.width / 2.0)
                .offset(x: geometry.size.width / 2.0, y: 0)
            }
        }.frame(height: 44)
    }
}

struct FoundNotFoundButtons: View {
    let displayableProduct: Retail.Translator.DisplayableProduct
    weak var evaluator: FindingProductsEvaluator?
    
    var body: some View {
        debugPrint("FoundNotFoundButtons. upc: \(displayableProduct.product.upc)")
        let isFound = displayableProduct.status == .found
        let isNotFound = displayableProduct.status == .notFound
        
        return GeometryReader() { geometry in
            ZStack {
                HStack {
                    SelectableCapsuleButton(
                        title: "Found",
                        isSelected: isFound,
                        imageName: "checkmark",
                        action: self.displayableProduct.findableProduct != nil ? { self.evaluator?.toggleProductFound(self.displayableProduct.findableProduct!) } : {}
                    )
                    .layoutPriority(30)
                }
                .frame(width: geometry.size.width / 2.0)
                .offset(x: 0, y: 0)
                
                HStack {
                    SelectableCapsuleButton(
                        title: "Not Found",
                        isSelected: isNotFound,
                        imageName: "xmark",
                        action: self.displayableProduct.findableProduct != nil ? { self.evaluator?.toggleProductNotFound(self.displayableProduct.findableProduct!) } : {}
                    )
                    .layoutPriority(30)
                }
                .frame(width: geometry.size.width / 2.0)
                .offset(x: geometry.size.width / 2.0, y: 0)
            }
        }.frame(height: 44)
    }
}

struct SelectableCapsuleButton: View {
    let title: String
    let isSelected: Bool
    let imageName: String
    let action: (() -> Void)?
    
    var body: some View {
        return HStack(spacing: 0) {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color(UIColor.systemBackground))
                .frame(
                    width: self.isSelected ? 12 : 0,
                    height: self.isSelected ? 12 : 0)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0))
                .animation( self.isSelected ? (.spring(response: 0.37, dampingFraction: 0.4, blendDuration: 0.825)) : .linear(duration: 0.2), value: self.isSelected)
                .layoutPriority(30)
            Text(title)
                .font(Font.system(.headline))
                .foregroundColor( self.isSelected ? Color(UIColor.systemBackground) : .primary)
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
                .padding(EdgeInsets(top: 10, leading: (isSelected ? 8 : 4), bottom: 10, trailing: 0))
                .layoutPriority(51)
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 22))
        .layoutPriority(31)
        .background(
            ZStack {
                BlurView()
                Rectangle()
                    .fill(Color.primary.opacity( self.isSelected ? 0.95 : 0))
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

struct OptionsView: View {
    @ObservedObject var options: ObservableArray<String>
    @ObservedObject var preference: ObservableString
    weak var evaluator: OptionsEvaluator?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(options.array, id: \.self) { option in
                HStack {
                    OptionView(option: option, preference: self.preference.string, evaluator: self.evaluator)
                    Spacer()
                }
            }
        }
    }
}

struct OptionView: View {
    let option: String
    let preference: String
    weak var evaluator: OptionsEvaluator?
    
    var body: some View {
        let isSelected = self.option == self.preference
        return ZStack(alignment: .topLeading) {
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.primary)
                .frame(width: isSelected ? 25 : 23, height: isSelected ? 25 : 23)
                .animation(.spring(response: 0.25, dampingFraction: 0.25, blendDuration: 0), value: isSelected)
                .padding(EdgeInsets(top: isSelected ? -2 : -1, leading: isSelected ? 39 : 40, bottom: 0, trailing: 0))
            Text(self.option)
                .font(Font.headline)
                .layoutPriority(20)
                .padding(EdgeInsets(top: 0, leading: 76, bottom: 0, trailing: 76))
        }
        .onTapGesture {
            self.evaluator?.toggleOption(self.option)
        }
    }
}
