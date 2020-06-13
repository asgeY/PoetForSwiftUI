//
//  FeedbackView.swift
//  Poet
//
//  Created by Stephen E. Cotner on 6/13/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct FeedbackView: View {
    @ObservedObject var feedback: ObservableString
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(feedback.string)
                    .font(Font.headline.monospacedDigit().bold())
                    .opacity(0.36)
                    .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
                Spacer()
            }
            Spacer().frame(height: 18)
        }
    }
}
