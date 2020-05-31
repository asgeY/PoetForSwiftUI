//
//  FoundNotFoundButtons.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/21/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct FoundNotFoundButtonsView: View {
    let findableProduct: FindableProduct
    let evaluator: FindingProductsEvaluator
    
    var body: some View {
        let isFound = findableProduct.status == .found
        let isNotFound = findableProduct.status == .notFound
        
        return GeometryReader() { geometry in
            ZStack {
                HStack {
                    SelectableCapsuleButton(
                        title: "Found",
                        isSelected: isFound,
                        imageName: "checkmark",
                        action: { self.evaluator.toggleProductFound(self.findableProduct) }
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
                        action: { self.evaluator.toggleProductNotFound(self.findableProduct) }
                    )
                    .layoutPriority(30)
                }
                .frame(width: geometry.size.width / 2.0)
                .offset(x: geometry.size.width / 2.0, y: 0)
            }
        }.frame(height: 44)
    }
}
