//
//  DemoBuilder-Screen.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/2/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct DemoBuilder {}

extension DemoBuilder {
    
    struct Screen: View {
        typealias Action = Evaluator.Action
        let evaluator: Evaluator
        let translator: Translator
        
        @State var isFullWidth = false
        @State var isEditing = false
        @State var isColoringViews = false
        
        @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
        
        init() {
            evaluator = Evaluator()
            translator = evaluator.translator
        }
        
        var body: some View {
            ZStack {
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Spacer().frame(width:10)
                        
                        // MARK: Add View Button
                        
                        Button(
                            action: {
                                self.evaluator.evaluate(Action.promptToAddDemoView)
                        })
                        {
                            Image(systemName: "plus")
                                .foregroundColor(Color.primary)
                                .padding(EdgeInsets(top: 26, leading: 14, bottom: 10, trailing: 10))
                                .font(Font.system(size: 18, weight: .regular))
                        }
                        
                        // MARK: Edit Views Button
                        
                        Observer(translator.arrangedDemoProviders) { arrangedDemoProviders in
                            Button(
                                action: {
                                    withAnimation(.linear) {
                                        self.isEditing.toggle()
                                    }
                            })
                            {
                                Image(systemName: self.isEditing ? "ellipsis.circle.fill" : "ellipsis.circle")
                                    .foregroundColor(Color.primary)
                                    .padding(EdgeInsets(top: 26, leading: 10, bottom: 10, trailing: 10))
                                    .font(Font.system(size: 18, weight: .regular))
                            }
                            .disabled(arrangedDemoProviders.isEmpty)
                            .opacity(arrangedDemoProviders.isEmpty ? 0.25 : 1)
                        }
                        
                        // MARK: Full Width Button
                        
                        Observer(translator.arrangedDemoProviders) { arrangedDemoProviders in
                            Button(
                                action: {
                                    withAnimation(.linear) {
                                        self.isFullWidth.toggle()
                                    }
                            })
                            {
                                Image(systemName: self.isFullWidth ? "rectangle.and.arrow.up.right.and.arrow.down.left.slash" : "rectangle.and.arrow.up.right.and.arrow.down.left")
                                    .foregroundColor(Color.primary)
                                    .frame(width: 20)
                                    .padding(EdgeInsets(top: 26, leading: 10, bottom: 10, trailing: 10))
                                    .font(Font.system(size: 18, weight: .regular))
                                    .animation(.none)
                            }
                            .disabled(arrangedDemoProviders.isEmpty || self.isEditing)
                            .opacity(arrangedDemoProviders.isEmpty || self.isEditing ? 0.25 : 1)
                        }
                        
                        Spacer()
                        
                        // MARK: Color Overlay Button
                        
                        Observer(translator.arrangedDemoProviders) { arrangedDemoProviders in
                            Button(
                                action: {
                                    withAnimation(.linear) {
                                        self.isColoringViews.toggle()
                                    }
                            })
                            {
                                Image(systemName: self.isColoringViews ? "rectangle.grid.1x2.fill" : "rectangle.grid.1x2")
                                    .foregroundColor(Color.primary)
                                    .frame(width: 20)
                                    .padding(EdgeInsets(top: 26, leading: 10, bottom: 10, trailing: 10))
                                    .font(Font.system(size: 18, weight: .regular))
                                    .animation(.none)
                            }
                            .disabled(arrangedDemoProviders.isEmpty || self.isEditing)
                            .opacity(arrangedDemoProviders.isEmpty || self.isEditing ? 0.25 : 1)
                        }
                        
                        // MARK: Dismiss Button
                        
                        Button(
                            action: {
                                self.presentationMode.wrappedValue.dismiss()
                        })
                        {
                            Image(systemName: "xmark")
                                .foregroundColor(Color.primary)
                                .padding(EdgeInsets(top: 26, leading: 10, bottom: 10, trailing: 26))
                                .font(Font.system(size: 18, weight: .regular))
                        }
                        
                    }
                    Spacer()
                }.zIndex(10)
                
                VStack {
                    Spacer()
                    HStack() {
                        Spacer()
                    }
                }
                .background(
                    ZStack {
                        Color.primary.opacity(1)
                        Color(UIColor.systemBackground).opacity(0.97)
                        Image("diagonalpattern_third")
                            .resizable(resizingMode: .tile)
                            .opacity(0.08)
                    }
                )
                    .edgesIgnoringSafeArea(.all)
                
                GeometryReader() { geometry in
                    VStack(spacing: 0) {
                        Spacer().frame(height:22)
                        Text("Demo Builder")
                            .font(.headline)
                        
                        Spacer().frame(height: 10)
                        ScrollView {
                            VStack(spacing: 0) {
                                
                                Spacer().frame(height: 10)
                                
                                VStack(spacing: 0) {
                                    Observer(self.translator.arrangedDemoProviders) { arrangedDemoProviders in
                                        
                                        if arrangedDemoProviders.count > 0 {
                                            HStack(spacing: 0) {
                                                Spacer()
                                            }
                                                .frame(height: 20)
                                                .overlay(
                                                    Color(UIColor.systemBackground)
                                                    .cornerRadius(self.isEditing ? 10 : 0)
                                                )
                                                .padding(.bottom, self.isEditing ? 16 : 0)
                                                .padding(.leading, self.isEditing ? 44 : 0)
                                                .padding(.trailing, self.isEditing ? 108 : 0)
                                                .opacity(self.isEditing ? 0.5 : 1)
                                        }
                                        
                                        ForEach(arrangedDemoProviders, id: \.id) { namedDemoProvider in
                                            HStack(spacing: 0) {
                                                
                                                // MARK: Edit button
                                                
                                                Button(
                                                    action: {
                                                        self.evaluator.evaluate(Action.editDemoView(namedDemoProvider))
                                                })
                                                {
                                                    Image(systemName: "dial")
                                                        .foregroundColor(Color.primary)
                                                        .frame(width: 20, height: 20)
//                                                        .frame(width: self.isEditing ? 20 : 0, height: self.isEditing ? 20 : 0)
                                                        .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                                                        .font(Font.system(size: 18, weight: .regular))
                                                        .offset(x: self.isEditing ? 0 : -2, y: self.isEditing ? -8 : 0)
                                                }
                                                .frame(width: self.isEditing ? nil : 0, height: self.isEditing ? nil : 0)
                                                .disabled(self.isEditing == false)
                                                .opacity(self.isEditing ? 1 : 0)
                                                
                                                // MARK: Content
                                                
                                                ZStack(alignment: .leading) {
                                                    AnyView(
                                                        namedDemoProvider.demoProvider.contentView
                                                            .opacity(0)
                                                    )
                                                    .frame(maxWidth: .infinity)
                                                    .overlay(
                                                        Color(UIColor.systemBackground)
                                                        .cornerRadius(self.isEditing ? 10 : 0)
                                                    )
                                                    .padding(.bottom, self.isEditing ? 16 : 0)
                                                    
                                                    AnyView(
                                                        namedDemoProvider.demoProvider.contentView
                                                    )
                                                    .frame(maxWidth: .infinity)
                                                    .overlay(
                                                        self.isColoringViews ?
                                                            AnyView(
                                                                Rectangle()
                                                                    .fill(Color(UIColor.random).opacity(Double.random(in: 0.12..<0.35)))
                                                                    .cornerRadius(self.isEditing ? 10 : 0)
                                                                    .opacity(self.isEditing ? 0 : 1)
                                                                
                                                            )
                                                                .allowsHitTesting(false)
                                                            :
                                                            AnyView(EmptyView())
                                                                .allowsHitTesting(false)
                                                    )
                                                    .padding(.bottom, self.isEditing ? 16 : 0)
                                                    .onTapGesture(count: 2) {
                                                        self.evaluator.evaluate(Action.editDemoView(namedDemoProvider))
                                                    }
                                                    
                                                }
                                                
                                                // MARK: Up button
                                                
                                                Button(
                                                    action: {
                                                        self.evaluator.evaluate(Action.moveDemoViewUp(namedDemoProvider))
                                                })
                                                {
                                                    Image(systemName: "arrow.up")
                                                        .foregroundColor(.primary)
                                                        .frame(width: 20, height: 20)
//                                                        .frame(width: self.isEditing ? 20 : 0, height: self.isEditing ? 20 : 0)
                                                        .padding(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 4))
                                                        .font(Font.system(size: 18, weight: .regular))
                                                        .offset(x: self.isEditing ? 0 : 2, y: self.isEditing ? -8 : 0)
                                                }
                                                .frame(width: self.isEditing ? nil : 0, height: self.isEditing ? nil : 0)
                                                .disabled(self.isEditing == false || arrangedDemoProviders.count < 2)
                                                .opacity((self.isEditing && arrangedDemoProviders.count > 1) ? 1 : self.isEditing ? 0.33 : 0)
                                                
                                                // MARK: Down button
                                                
                                                Button(
                                                    action: {
                                                        self.evaluator.evaluate(Action.moveDemoViewDown(namedDemoProvider))
                                                })
                                                {
                                                    Image(systemName: "arrow.down")
                                                        .foregroundColor(.primary)
                                                        .frame(width: 20, height: 20)
//                                                        .frame(width: self.isEditing ? 20 : 0, height: self.isEditing ? 20 : 0)
                                                        .padding(EdgeInsets(top: 8, leading: 4, bottom: 8, trailing: 6))
                                                        .font(Font.system(size: 18, weight: .regular))
                                                        .offset(x: self.isEditing ? 0 : 2, y: self.isEditing ? -8 : 0)
                                                }
                                                .frame(width: self.isEditing ? nil : 0, height: self.isEditing ? nil : 0)
                                                .disabled(self.isEditing == false || arrangedDemoProviders.count < 2)
                                                .opacity((self.isEditing && arrangedDemoProviders.count > 1) ? 1 : self.isEditing ? 0.33 : 0)
                                                
                                                // MARK: Delete button
                                                                                                
                                                Button(
                                                    action: {
                                                        self.evaluator.evaluate(Action.deleteDemoView(namedDemoProvider))
                                                })
                                                {
                                                    Image(systemName: "minus.circle.fill")
                                                        .foregroundColor(Color(UIColor.systemRed))
                                                        .frame(width: 20, height: 20)
                                                        .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                                                        .font(Font.system(size: 18, weight: .regular))
                                                        .offset(x: self.isEditing ? 0 : 2, y: self.isEditing ? -8 : 0)
                                                }
                                                .frame(width: self.isEditing ? nil : 0, height: self.isEditing ? nil : 0)
                                                .disabled(self.isEditing == false)
                                                .opacity(self.isEditing ? 1 : 0)
                                                
                                            }
                                        }
                                        
                                        if arrangedDemoProviders.count > 0 {
                                            HStack(spacing: 0) {
                                                Spacer()
                                            }
                                                .frame(height: 20)
                                                .overlay(
                                                    Color(UIColor.systemBackground)
                                                    .cornerRadius(self.isEditing ? 10 : 0)
                                                )
                                                .padding(.bottom, self.isEditing ? 16 : 0)
                                                .padding(.leading, self.isEditing ? 44 : 0)
                                                .padding(.trailing, self.isEditing ? 108 : 0)
                                                .opacity(self.isEditing ? 0.5 : 1)
                                        }
                                    }
                                    .padding(0)
                                    .frame(width: self.isFullWidth ? geometry.size.width : self.isEditing ? geometry.size.width : geometry.size.width - 28)
                                }
                                .cornerRadius(self.isFullWidth ? 0 : 10)
                                .shadow(color: Color.black.opacity(0.03), radius: 12, x: 0, y: 4)
                                
                                Spacer()
                            }
                            .frame(width: geometry.size.width)
                        }
                    }
                }
                
                Group {
                    PresenterWithPassedValue(self.translator.editDemoView) { editConfiguration in
                        ViewDemoDetail(demoViewEditingConfiguration: editConfiguration)
                    }
                    
                    PresenterWithPassedValue(self.translator.promptToAddDemoView, evaluator: self.evaluator) { providers in
                        ViewDemoPicker(namedDemoProviders: providers, evaluator: self.evaluator)
                    }
                }
                
                VStack {
                    DismissButton(orientation: .right)
                        .zIndex(2)
                    Spacer()
                }.zIndex(2)
            }
            
            .onAppear {
                self.evaluator.viewDidAppear()
            }
        }
    }
}

protocol ViewDemoPickerEvaluating {
    func pickViewDemo(_ provider: NamedDemoProvider)
}

protocol DismissDelegate {
    func dismissPlease()
}

struct ViewDemoPicker: View {
    let namedDemoProviders: [NamedDemoProvider]
    let evaluator: ViewDemoPickerEvaluating
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        return ZStack {
            VStack {
                Spacer().frame(height:22)
                Text("Add a View")
                    .font(.headline)
                
                ScrollView() {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(namedDemoProviders, id: \.id) { namedDemoProvider in
                            Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                                self.evaluator.pickViewDemo(namedDemoProvider)
                            }) {
                                VStack(spacing: 0) {
                                    Spacer().frame(height: 12)
                                    HStack(spacing: 0) {
                                        Spacer().frame(width: 30)
                                        Text(namedDemoProvider.title)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .opacity(0.3)
                                        Spacer().frame(width: 30)
                                    }
                                    Spacer().frame(height: 12)
                                    Divider()
                                        .opacity(0.6)
                                        .padding(.leading, 30)
                                }
                            }
                            .foregroundColor(.primary)
                        }
                    }
                    
                }
            }
        }
    }
}

extension CGFloat {
    static var random: CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random, green: .random, blue: .random, alpha: 1.0)
    }
}
