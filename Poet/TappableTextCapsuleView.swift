//
//  TappableTextCapsuleView.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/26/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine
import SwiftUI

struct TappableTextCapsuleView: View {
    let action: Action
    @ObservedObject var text: ObservableString
    
    var body: some View {
        ButtonActionView(
            action: action.evaluate,
            content: AnyView(
                ObservingTextView(text: text, font: Font.subheadline.monospacedDigit(), alignment: .center)
                .padding(EdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14))
            )
        )
        .background(
            ZStack {
                BlurView()
                .mask(
                    Capsule())
            }
        )
    }
}
