//
//  FileOfInterestButton.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/23/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct FileOfInterestButton: View {
    @ObservedObject var title: ObservableString
    @ObservedObject var isShowing: ObservableBool
    let transition: AnyTransition
    weak var evaluator: ButtonEvaluating?
    let action: EvaluatorAction?
    
    var body: some View {
        Hideable(isShowing: isShowing, transition: transition) {
            Button(action: {
                self.evaluator?.buttonTapped(action: self.action)
            }) {
                HStack {
                    ObservingTextView(self.title)
                        .font(Font.subheadline)
                        .fixedSize(horizontal: true, vertical: false)
                        .frame(height:40)
                    
                    
                    Image(systemName: "doc.plaintext")
                        .font(Font.system(size: 20, weight: .medium))
                        .padding(20)
                        .zIndex(4)
                        .transition(.scale)
                        .frame(width: 40, height: 40)
                }
            }.zIndex(4)
        }
        .frame(height: 40)
        .foregroundColor(.primary)
    }
}
