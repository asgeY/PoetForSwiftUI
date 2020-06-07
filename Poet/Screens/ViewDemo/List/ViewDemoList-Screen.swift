//
//  ViewDemoList-Screen.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/2/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct ViewDemoList {}

extension ViewDemoList {
    
    struct Screen: View {
        let evaluator: Evaluator
        let translator: Translator
        
        @State var bindableText: String = ""
        
        init() {
            evaluator = Evaluator()
            translator = evaluator.translator
        }
        
        var body: some View {
            return ZStack {
                PreviewListView(demoProviders: translator.demoProviders, evaluator: evaluator)
                
                VStack {
                    DismissButton(orientation: .right)
                    Spacer()
                }
                
                AnyView(
                    PresenterWithPassedValue(translator.showPreview, evaluator: evaluator) { provider in
                        return ViewDemoDetailView(namedDemoProvider: provider)
                    }
                )
            }
            .onAppear {
                self.evaluator.viewDidAppear()
            }
        }
    }
}

enum DemoListAction: EvaluatorAction {
    case demoProviderSelected(NamedDemoProvider)
}

struct PreviewListView: View {
    @ObservedObject var demoProviders: ObservableArray<NamedDemoProvider>
    let evaluator: ActionEvaluating
    
    var body: some View {
        ScrollView {
            Text("View Demos")
                .font(Font.headline)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 22)
                .padding(.bottom, 20)
            
            Text("Choose a view to see its demo.")
                .font(Font.body)
                .foregroundColor(Color.primary.opacity(0.43))
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .padding(EdgeInsets(top: 0, leading: 30, bottom: 22, trailing: 30))
            
            VStack(alignment: .leading, spacing: 20) {
                ForEach(self.demoProviders.array, id: \.id) { provider in
                    Button(action: {
                        self.evaluator.evaluate(DemoListAction.demoProviderSelected(provider))
                    }) {
                        HStack {
                            Spacer().frame(width: 30)
                            Text(provider.title)
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .opacity(0.3)
                            Spacer().frame(width: 20)
                        }
                    }
                    .foregroundColor(.primary)
                }
                Spacer()
            
            }.frame(maxWidth: .infinity)
            
            Spacer()
        }
    }
}
