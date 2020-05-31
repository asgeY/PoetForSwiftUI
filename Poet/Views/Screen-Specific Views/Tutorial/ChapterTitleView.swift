//
//  ChapterTitleView.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/21/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct ChapterTitleView: View {
    @ObservedObject var text: ObservableString
    @ObservedObject var number: ObservableInt
    @ObservedObject var shouldShowNumber: ObservableBool
    @ObservedObject var isFocused: ObservableBool
    let height: CGFloat
    let topSpace: CGFloat
    
    var body: some View {
        return VStack {
            Spacer().frame(height: self.isFocused.bool ? self.height / 2.0 - 60 : topSpace)
            HStack {
                Spacer()
                VStack {
                    Image.numberCircleFill(self.number.int)
                        .resizable()
                        .frame(width: 30, height: 30)
                        .opacity(self.shouldShowNumber.bool ? 1 : 0)
                    ObservingTextView(self.text, alignment: .center, kerning: -0.05)
                        .font(FontSystem.largeTitle.monospacedDigit())
                        .padding(.top, 5)
                }
                Spacer()
            }
            Spacer()
        }
    }
}
