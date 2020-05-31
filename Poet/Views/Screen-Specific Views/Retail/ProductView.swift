//
//  ProductView.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/21/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct ProductView: View {
    let product: Product
    
    var body: some View {
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
