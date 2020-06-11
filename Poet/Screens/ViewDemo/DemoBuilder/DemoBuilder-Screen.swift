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
        
        init() {
            evaluator = Evaluator()
            translator = evaluator.translator
        }
        
        var body: some View {
            return ZStack {
                ZStack {
                    VStack {
                        Spacer()
                        HStack() {
                            Spacer()
                        }
                    }
                }
                .background(
                    ZStack {
                        Color(UIColor(white: 0.94, alpha: 0.9))
                        Image("diagonalpattern_third")
                            .resizable(resizingMode: .tile)
                            .opacity(0.1)
                    }
                )
                    .edgesIgnoringSafeArea(.bottom)
                
                VStack {
                    Spacer().frame(height:22)

                    Text("Demo Builder")
                    
                    ScrollView() {
                        Spacer().frame(height: 30)
                        
                        VStack(alignment: .leading, spacing: 0) {
                            
                            Observer(translator.arrangedDemoProviders) { arrangedDemoProviders in
                                ForEach(arrangedDemoProviders, id: \.id) { namedDemoProvider in
                                    HStack(spacing: 0) {
                                        
                                        // MARK: Edit button
                                        
                                        Button(
                                            action: {
                                                debugPrint("edit this view!")
                                                self.evaluator.evaluate(Action.editDemoView(namedDemoProvider))
                                        })
                                        {
                                            Image(systemName: "dial")
                                                .foregroundColor(Color.primary)
                                                .frame(width: self.isEditing ? 20 : 0, height: self.isEditing ? 20 : 0)
                                                .padding(EdgeInsets(top: 8, leading: 14, bottom: 8, trailing: 10))
                                                .font(Font.system(size: 18, weight: .regular))
                                                .offset(x: 0, y: self.isEditing ? -8 : 0)
                                        }
                                        .frame(width: self.isEditing ? nil : 0, height: self.isEditing ? nil : 0)
                                        .disabled(self.isEditing == false)
                                        .opacity(self.isEditing ? 1 : 0)
                                        
                                        // MARK: Content
                                        
                                        AnyView(namedDemoProvider.demoProvider.contentView)
                                            .background(Color.white)
                                            .padding(.bottom, self.isEditing ? 16 : 0)
                                        
                                        // MARK: Delete button
                                        
                                        Button(
                                            action: {
                                                debugPrint("delete this view!")
                                                self.evaluator.evaluate(Action.deleteDemoView(namedDemoProvider))
                                        })
                                        {
                                            Image(systemName: "minus.circle.fill")
                                                .foregroundColor(Color(UIColor.systemRed))
                                                .frame(width: self.isEditing ? 20 : 0, height: self.isEditing ? 20 : 0)
                                                .padding(EdgeInsets(top: 8, leading: 14, bottom: 8, trailing: 10))
                                                .font(Font.system(size: 18, weight: .regular))
                                                .offset(x: 0, y: self.isEditing ? -8 : 0)
                                        }
                                        .frame(width: self.isEditing ? nil : 0, height: self.isEditing ? nil : 0)
                                        .disabled(self.isEditing == false)
                                        .opacity(self.isEditing ? 1 : 0)
                                    }
                                }
                            }
                            
                            KeyboardPadding()
                        }
                        .padding(EdgeInsets(top: 0, leading: isFullWidth ? 0 : isEditing ? 0 : 30, bottom: 0, trailing: isFullWidth ? 0 : isEditing ? 0 : 30))
                            
                        Spacer().frame(height: 30)
                    }
                    .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
                    
                }
                
                VStack {
                    DismissButton(orientation: .right)
                    Spacer()
                }
                
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
                                .padding(EdgeInsets(top: 12, leading: 14, bottom: 10, trailing: 10))
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
                                    .padding(EdgeInsets(top: 26, leading: 10, bottom: 24, trailing: 10))
                                    .font(Font.system(size: 18, weight: .regular))
                            }
                            .disabled(arrangedDemoProviders.isEmpty)
                            .opacity(arrangedDemoProviders.isEmpty ? 0.33 : 1)
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
                                    .padding(EdgeInsets(top: 26, leading: 10, bottom: 24, trailing: 10))
                                    .font(Font.system(size: 18, weight: .regular))
                                    .animation(.none)
                            }
                            .disabled(arrangedDemoProviders.isEmpty)
                            .opacity(arrangedDemoProviders.isEmpty ? 0.33 : 1)
                        }
                        
                        Spacer()
                    }
                    Spacer()
                }
                
                Group {
                    PresenterWithPassedValue(self.translator.editDemoView) { editConfiguration in
                        ViewDemoDetail(demoViewEditingConfiguration: editConfiguration)
                    }
                    
                    PresenterWithPassedValue(self.translator.promptToAddDemoView) { providers in
                        ViewDemoPicker(namedDemoProviders: providers, evaluator: self.evaluator)
                    }
                }
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

struct ViewDemoPicker: View {
    let namedDemoProviders: [NamedDemoProvider]
    let evaluator: ViewDemoPickerEvaluating
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        return ZStack {
            VStack {
                Spacer().frame(height:22)
                Text("Add a View")
                
                ScrollView() {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(namedDemoProviders, id: \.id) { namedDemoProvider in
                            Button(action: {
                                self.evaluator.pickViewDemo(namedDemoProvider)
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                VStack(spacing: 0) {
                                    Spacer().frame(height: 10)
                                    HStack(spacing: 0) {
                                        Spacer().frame(width: 30)
                                        Text(namedDemoProvider.title)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .opacity(0.3)
                                        Spacer().frame(width: 30)
                                    }
                                    Spacer().frame(height: 10)
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
            
            VStack {
                DismissButton(orientation: .right)
                Spacer()
            }
        }
    }
}
