//
//  DisplayableProductsView.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/21/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct DisplayableProductsView: View, ViewDemoing {
    @ObservedObject var displayableProducts: ObservableArray<Retail.Translator.DisplayableProduct>
    let evaluator: FindingProductsEvaluating
    
    static var demoProvider: DemoProvider = DisplayableProductsView_DemoProvider()
    
    var body: some View {
        return VStack(alignment: .leading, spacing: 40) {
            ForEach(displayableProducts.array, id: \.id) { displayableProduct in
                return HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        ProductView(product: displayableProduct.product)
                        if displayableProduct.findableProduct != nil {
                            FoundNotFoundButtonsView(findableProduct: displayableProduct.findableProduct!, evaluator: self.evaluator)
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

struct DisplayableProductsView_DemoProvider: DemoProvider, FindingProductsEvaluating {
    typealias DisplayableProduct = Retail.Translator.DisplayableProduct
    @ObservedObject var displayableProducts = ObservableArray<DisplayableProduct>([
        DisplayableProduct(
            product: Product(
                title: "Air Jordan 1 Mid",
                upc: "123678098543",
                image: "airJordan1Mid-red",
                location: "Bin 1"),
            findableProduct: nil),
        
        DisplayableProduct(
        product: Product(
            title: "Air Jordan 1 Mid",
            upc: "2468098753120",
            image: "airJordan1Mid-green",
            location: "Bin 2"),
        findableProduct: nil),
        
        DisplayableProduct(
        product: Product(
            title: "Air Jordan 1 Mid",
            upc: "642798530951",
            image: "airJordan1Mid-blue",
            location: "Bin 3"),
        findableProduct: nil)
    ])
    
    var contentView: AnyView {
        return AnyView(
            DisplayableProductsView(
                displayableProducts: displayableProducts,
                evaluator: self)
        )
    }
    
    var controls: [DemoControl] {
        return [
            /*
            DemoControl(
                title: "Number of products",
                instructions: "Type a positive number.") {
                    AnyView(
                        //
                    )
            }
             */
        ]
    }
    
    func toggleProductFound(_ product: FindableProduct) {
        //
    }
    
    func toggleProductNotFound(_ product: FindableProduct) {
        //
    }
}
