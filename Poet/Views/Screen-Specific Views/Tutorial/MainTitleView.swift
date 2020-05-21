//
//  MainTitle.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/21/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct MainTitleView: View {
    @ObservedObject var text: ObservableString
    
    var body: some View {
        GeometryReader() { geometry in
            VStack {
                ObservingTextView(self.text, alignment: .center, kerning: -0.05)
                    .font(Font.system(size: 32, weight: .semibold).monospacedDigit())
                    .padding(.top, 5)
            }
        }
    }
}
