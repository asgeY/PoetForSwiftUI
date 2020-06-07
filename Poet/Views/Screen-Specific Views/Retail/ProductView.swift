//
//  ProductView.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/21/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct ProductView: View, ViewDemoing {
    let product: Product
    static var demoProvider: DemoProvider { return ProductView_DemoProvider() }
    
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

struct ProductView_DemoProvider: DemoProvider, TextFieldEvaluating {
    
    @ObservedObject var title = Observable<String>("Air Jordan")
    @ObservedObject var upc = Observable<String>("198430268490")
    @ObservedObject var location = Observable<String>("Bin 1")
    
    
    enum Element: EvaluatorElement {
        case title
        case upc
        case location
    }
    
    var contentView: AnyView {
        return AnyView(
            Observer(observable: self.title) { title in
                Observer(observable: self.upc) { upc in
                    Observer(observable: self.location) { location in
                        ProductView(product:
                            Product(
                                title: title,
                                upc: upc,
                                image: "airJordan",
                                location: location
                            )
                        )
                    }
                }
            }
        )
    }
    
    var controls: [DemoControl] {
        [
            DemoControl(
                title: "Title",
                viewMaker: {
                    AnyView(
                        DemoControl_ObservableControlledByTextInput(
                            observable: self.title,
                            evaluator: self,
                            elementName: Element.title,
                            input: .text))}),
            
            DemoControl(
                title: "Location",
                viewMaker: {
                    AnyView(
                        DemoControl_ObservableControlledByTextInput(
                            observable: self.location,
                            evaluator: self,
                            elementName: Element.location,
                            input: .text))}),
            
            DemoControl(
                title: "UPC",
                viewMaker: {
                    AnyView(
                        DemoControl_ObservableControlledByTextInput(
                            observable: self.upc,
                            evaluator: self,
                            elementName: Element.upc,
                            input: .number))})
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
