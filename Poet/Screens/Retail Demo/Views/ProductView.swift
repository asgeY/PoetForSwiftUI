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

// MARK: View Demoing

extension ProductView: ViewDemoing {
    static var demoProvider: DemoProvider { return ProductView_DemoProvider() }
}

struct ProductView_DemoProvider: DemoProvider, TextFieldEvaluating {
    
    @ObservedObject var title = ObservableString("Air Jordan")
    @ObservedObject var upc = ObservableString("198430268490")
    @ObservedObject var location = ObservableString("Bin 1")
    
    enum Element: EvaluatorElement {
        case title
        case upc
        case location
    }
    
    func deepCopy() -> Self {
        let provider = ProductView_DemoProvider(
            title: self.title.deepCopy(),
            upc: self.upc.deepCopy(),
            location: self.location.deepCopy()
        )
        return provider
    }
    
    var contentView: AnyView {
        return AnyView(
            Observer3(title, upc, location) { title, upc, location in
                ProductView(product:
                    Product(
                        title: title,
                        upc: upc,
                        image: "airJordan1Mid-red",
                        location: location
                    )
                )
            }
        )
    }
    
    var controls: [DemoControl] {
        [
            DemoControl(
                title: "Title",
                type: DemoControl.Text(evaluator: self, elementName: Element.title, input: .text, initialText: title.string)
            ),
            
            DemoControl(
                title: "Location",
                type: DemoControl.Text(evaluator: self, elementName: Element.location, input: .text, initialText: location.string)
            ),
            
            DemoControl(
                title: "UPC",
                type: DemoControl.Text(evaluator: self, elementName: Element.upc, input: .text, initialText: upc.string)
            )
        ]
    }
    
    func textFieldDidChange(text: String, elementName: EvaluatorElement) {
        guard let elementName = elementName as? Element else { return }
        switch elementName {
        case .title:
            self.title.value = text
        case .upc:
            self.upc.value = text
        case .location:
            self.location.value = text
        }
    }
}
