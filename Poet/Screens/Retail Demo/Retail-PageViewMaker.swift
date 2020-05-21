//
//  Retail-PageViewMaker.swift
//  Poet
//
//  Created by Stephen E Cotner on 5/1/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine
import SwiftUI

protocol FindingProductsEvaluator: class {
    func toggleProductFound(_ product: FindableProduct)
    func toggleProductNotFound(_ product: FindableProduct)
}

protocol OptionsEvaluator: class {
    func toggleOption(_ option: String)
}

extension Retail {
    struct ViewMaker: ObservingPageView_ViewMaker {
        
        // Fade state
        let fadeDeliveryOptions = ObservableBool()
        let fadeCompletedSummary = ObservableBool()
        let fadeCompletedTitle = ObservableBool()
        let fadeCanceledTitle = ObservableBool()
        
        func view(for section: ObservingPageViewSection) -> AnyView {
            guard let section = section as? Retail.Translator.Section else {
                return AnyView(EmptyView())
            }
            
            switch section {
            
            case .topSpace:
                return AnyView(
                    Spacer().frame(height: 40)
                )
                
            case .canceledTitle:
            return AnyView(
                Fadeable {
                    HStack {
                        Text("Canceled")
                            .font(Font.system(size: 32, weight: .bold))
                            .padding(EdgeInsets(top: 0, leading: 40, bottom: 18, trailing: 40))
                        Spacer()
                    }.foregroundColor(Color(UIColor.systemRed))
                }
            )
                
            case .completedTitle:
                return AnyView(
                    Fadeable {
                        HStack {
                            Text("Completed")
                                .font(Font.system(size: 32, weight: .bold))
                                .padding(EdgeInsets(top: 0, leading: 40, bottom: 18, trailing: 40))
                            Spacer()
                        }.foregroundColor(Color(UIColor.systemGreen))
                    }
                )
                
            case .customerTitle(let title):
                return AnyView(
                    HStack {
                        ObservingTextView(title)
                            .font(Font.system(size: 32, weight: .bold))
                            .padding(EdgeInsets(top: 0, leading: 40, bottom: 18, trailing: 40))
                        Spacer()
                    }
                )
                
            case .divider:
                return AnyView(
                    Divider()
                        .background(Color.primary)
                        .frame(height: 2)
                        .opacity(0.25)
                        .padding(EdgeInsets(top: 0, leading: 40, bottom: 20, trailing: 0))
                )
                
            case .feedback(let feedback):
                return AnyView(
                    VStack {
                        HStack {
                            ObservingTextView(feedback)
                                .font(Font.headline.monospacedDigit().bold())
                                .opacity(0.4)
                                .padding(EdgeInsets(top: 0, leading: 40, bottom: 26, trailing: 42))
                            Spacer()
                        }
                    }
                )
                
            case .instruction(let instructionNumber, let instruction):
                return AnyView(
                    InstructionView(instructionNumber: instructionNumber, instruction: instruction)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                )
             
            case .displayableProducts(let displayableProducts, let findingProductsEvaluator):
                return AnyView(
                    DisplayableProductsView(displayableProducts: displayableProducts, evaluator: findingProductsEvaluator)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                )
                
            case .deliveryOptions(let deliveryOptions, let deliveryPreference, let optionsEvaluator):
                return AnyView(
                    Fadeable {
                        OptionsView(options: deliveryOptions, preference: deliveryPreference, evaluator: optionsEvaluator)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 34, trailing: 0))
                    }
                )
                
            case .completedSummary(let completedSummary):
                return AnyView(
                    Fadeable {
                        VStack {
                            Divider()
                            .background(Color.primary)
                            .frame(height: 1.75)
                            .opacity(0.22)
                            .padding(EdgeInsets(top: 0, leading: 40, bottom: 20, trailing: 0))
                            
                            HStack {
                                ObservingTextView(completedSummary)
                                    .font(Font.system(.headline))
                                    .opacity(0.33)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
                                Spacer()
                            }
                        }.padding(.bottom, 30)
                    }
                )
            }
        }
    }
    
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
                                FoundNotFoundButtons(findableProduct: displayableProduct.findableProduct!, evaluator: self.evaluator)
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

    struct FoundNotFoundButtons: View {
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
                    .frame(width: isSelected ? 25.5 : 23, height: isSelected ? 25.5 : 23)
                    .animation(.spring(response: 0.25, dampingFraction: 0.25, blendDuration: 0), value: isSelected)
                    .padding(EdgeInsets(top: isSelected ? -2.25 : -1, leading: isSelected ? 38.75 : 40, bottom: 0, trailing: 0))
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
}

struct Fadeable<Content>: View where Content : View {
    @State var isShowing: Bool = false
    var content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        content()
            .opacity(isShowing ? 1 : 0)
            .onDisappear() {
                withAnimation(Animation.linear(duration: 0.3)) {
                    self.isShowing = false
                }
        }
            .onAppear() {
                withAnimation(Animation.linear(duration: 0.3).delay(0.45)) {
                    self.isShowing = true
                }
        }
    }
}
