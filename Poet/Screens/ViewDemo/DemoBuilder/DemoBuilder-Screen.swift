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
                VStack {
                    Spacer().frame(height:22)
                    Text("Demo Builder")
                    
                    ScrollView() {
                        
                        VStack(alignment: .leading, spacing: 0) {
                            
                            Observer(translator.arrangedDemoProviders) { arrangedDemoProviders in
                                ForEach(arrangedDemoProviders, id: \.id) { namedDemoProvider in
                                    HStack(spacing: 0) {
                                        
                                        // Edit button
                                        
                                        Button(
                                            action: {
                                                debugPrint("edit this view!")
                                                self.evaluator.evaluate(Action.editDemoView(namedDemoProvider))
                                        })
                                        {
                                            Image(systemName: "ellipsis.circle.fill")
                                                .foregroundColor(Color.primary)
                                                .frame(width: self.isEditing ? 20 : 0, height: self.isEditing ? 20 : 0)
                                                .padding(EdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 10))
                                                .font(Font.system(size: 18, weight: .regular))
                                        }
                                        .frame(width: self.isEditing ? nil : 0, height: self.isEditing ? nil : 0)
                                        .disabled(self.isEditing == false)
                                        .opacity(self.isEditing ? 1 : 0)
                                        
                                        AnyView(namedDemoProvider.demoProvider.contentView)
                                            .background(Color.white)
                                            .padding(.top, self.isEditing ? 10 : 0)
                                            .padding(.bottom, self.isEditing ? 10 : 0)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            
                            KeyboardPadding()
                        }

                        .frame(maxWidth: .infinity)
                    }
                    .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
                    .padding(EdgeInsets(top: 30, leading: isFullWidth ? 0 : isEditing ? 0 : 30, bottom: 30, trailing: isFullWidth ? 0 : 30))
                        
                    .frame(maxWidth: .infinity)
                    .background(
                        ZStack {
                            Color(UIColor(white: 0.94, alpha: 0.9))
                            Image("diagonalpattern_third")
                                .resizable(resizingMode: .tile)
                                .opacity(0.1)
                        }
                    )
                }
                
                VStack {
                    DismissButton(orientation: .right)
                    Spacer()
                }
                
                VStack {
                    HStack(spacing: 0) {
                        Spacer().frame(width:10)
                        
                        // MARK: Add View Button
                        
                        Button(
                            action: {
                                self.evaluator.evaluate(Action.addDemoView(ObservingTextView.namedDemoProvider))
                        })
                        {
                            Image(systemName: "plus")
                                .foregroundColor(Color.primary)
                                .padding(EdgeInsets(top: 26, leading: 14, bottom: 24, trailing: 10))
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
                                Image(systemName: "slider.horizontal.below.rectangle")
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
                                Image(systemName: "arrow.left.and.right.square")
                                    .foregroundColor(Color.primary)
                                    .padding(EdgeInsets(top: 26, leading: 10, bottom: 24, trailing: 10))
                                    .font(Font.system(size: 18, weight: .regular))
                            }
                            .disabled(arrangedDemoProviders.isEmpty)
                            .opacity(arrangedDemoProviders.isEmpty ? 0.33 : 1)
                        }
                        
                        Spacer()
                    }
                    Spacer()
                }
                
                PresenterWithPassedValue(self.translator.editDemoView) { editConfiguration in
                    ViewDemoDetail(demoViewEditingConfiguration: editConfiguration)
                }
            }
            .onAppear {
                self.evaluator.viewDidAppear()
            }
        }
    }
}
