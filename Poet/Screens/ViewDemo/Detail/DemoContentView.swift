//
//  DemoContentView.swift
//  Poet
//
//  Created by Stephen E. Cotner on 6/13/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct DemoContentView: View {
    let namedDemoProvider: NamedDemoProvider
    let isEditing: Bool
    let isColoringViews: Bool
    let shouldRoundCorners: Bool
    let evaluator: ActionEvaluating
    let editAction: EvaluatorAction
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .leading) {
                HStack(spacing: 0) {
                    AnyView(
                        namedDemoProvider.demoProvider.contentView
                            .opacity(0)
                    )
                    Spacer()
                }
                .overlay(
                    Color(UIColor.systemBackground)
                        .cornerRadius(self.shouldRoundCorners ? 10 : 0)
                )
                
                HStack(spacing: 0) {
                    AnyView(
                        namedDemoProvider.demoProvider.contentView
                    )
                    Spacer()
                }
                    .overlay(
                        self.isColoringViews ?
                            AnyView(
                                Rectangle()
                                    .fill(Color(UIColor.random).opacity(Double.random(in: 0.12..<0.35)))
                                    .cornerRadius(self.shouldRoundCorners ? 10 : 0)
                                    .opacity(self.isEditing ? 0 : 1)
                                
                            )
                                .allowsHitTesting(false)
                            :
                            AnyView(EmptyView())
                                .allowsHitTesting(false)
                    )
                        .onTapGesture(count: 2) {
                            self.evaluator.evaluate(self.editAction)
                    }
            }
        }
    }
}
