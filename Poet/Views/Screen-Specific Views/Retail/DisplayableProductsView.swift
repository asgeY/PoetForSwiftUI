//
//  DisplayableProductsView.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/21/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

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
