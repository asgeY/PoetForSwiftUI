//
//  CircularTabBar.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/21/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct CircularTabBar<E: ActionEvaluating>: View {
    
    let evaluator: E
    @ObservedObject var tabs: ObservableArray<IconRepresentedAndIdentifiedEvaluatorAction<E.Action>>
    @ObservedObject var currentTab: Observable<IconRepresentedAndIdentifiedEvaluatorAction<E.Action>?>
    let spacing: CGFloat = 30
    
    var body: some View {
        ZStack {
            HStack(spacing: spacing) {
                // MARK: World Button
                ForEach(self.tabs.array, id: \.id) { tab in
                    CircularTabButton(evaluator: self.evaluator, tab: tab)
                }
            }.overlay(
                GeometryReader() { geometry in
                    Capsule()
                        .fill(Color.primary.opacity(0.06))
                        .frame(width: geometry.size.width / CGFloat(self.tabs.array.count), height: 48)
                        .opacity(self.indexOfCurrentTab() != nil ? 1 : 0)
                        .offset(x: {
                            let divided = CGFloat((geometry.size.width + self.spacing) / CGFloat(self.tabs.array.count))
                            return divided * CGFloat(self.indexOfCurrentTab() ?? 0) + (self.spacing / 2.0) - (geometry.size.width / 2.0)
                        }(), y: 0)
                        .allowsHitTesting(false)
                }
            )
        }
    }
    
    func indexOfCurrentTab() -> Int? {
        if let currentTabObject = currentTab.value {
            return self.tabs.array.firstIndex { tab in
                tab.id == currentTabObject.id
            }
        }
        return nil
    }
    
    struct CircularTabButton<E: ActionEvaluating>: View {
        let evaluator: E
        let tab: IconRepresentedAndIdentifiedEvaluatorAction<E.Action>
        var body: some View {
            Button(action: { self.evaluator.evaluate(self.tab.action) }) {
                Image(self.tab.icon)
                .resizable()
                .frame(width: 30, height: 30)
            }
        }
    }
}
