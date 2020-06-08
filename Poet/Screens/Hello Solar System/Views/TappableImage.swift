//
//  TappableImage.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/21/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct TappableImage: View {
    let evaluator: ActionEvaluating
    @ObservedObject var tapAction: ObservableEvaluatorAction
    @ObservedObject var image: ObservableString
    @ObservedObject var foregroundColor: Observable<Color>
    @ObservedObject var backgroundColor: Observable<Color>
    
    var body: some View {
        return ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.primary.opacity(0.026))
            Circle()
                .fill(self.backgroundColor.value)
                .frame(width: 130, height: 130)
            Circle()
                .fill(self.foregroundColor.value)
                .frame(width: 130, height: 130)
                .mask(
                    Image(self.image.string)
                    .resizable()
                )
        }
        .frame(width: 200, height: 200)
        .onTapGesture {
            self.evaluator.evaluate(self.tapAction.action)
        }
    }
}
