//
//  ViewDemoDetail.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/2/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct ViewDemoDetail: View {

    private let namedDemoProvider: NamedDemoProvider
    private let evaluator: DemoViewEditingEvaluating?
    private let canSave: Bool
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    init(namedDemoProvider: NamedDemoProvider) {
        self.namedDemoProvider = namedDemoProvider
        self.evaluator = nil
        self.canSave = false
    }
    
    init(demoViewEditingConfiguration configuration: DemoViewEditingConfiguration) {
        self.namedDemoProvider = configuration.namedDemoProvider
        self.evaluator = configuration.evaluator
        self.canSave = true
    }
    
    var body: some View {
        ZStack {
            
            VStack(spacing: 0) {
                Text(namedDemoProvider.title)
                    .font(Font.headline)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 22)
                
                Spacer().frame(height: 20)
                
                namedDemoProvider.demoProvider.demoContainerView
                
                Spacer()
            }
            
            VStack {
                HStack {
                    Button(
                        action: {
                            self.presentationMode.wrappedValue.dismiss()
                    })
                    {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                            .padding(EdgeInsets(top: 26, leading: 14, bottom: 24, trailing: 26))
                            .font(Font.system(size: 18, weight: .regular))
                    }
                    
                    Spacer()
                    Button(
                        action: {
                            self.evaluator?.saveChangesToProvider(self.namedDemoProvider)
                            self.presentationMode.wrappedValue.dismiss()
                    })
                    {
                        Text("Save")
                            .font(Font.body)
                            .foregroundColor(.primary)
                            .padding(EdgeInsets(top: 12, leading: 12, bottom: 8, trailing: 26))
                    }
                }
                Spacer()
            }
        }
    }
}
