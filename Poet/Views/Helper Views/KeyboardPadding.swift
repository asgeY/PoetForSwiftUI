//
//  KeyboardPadding.swift
//  Poet
//
//  Created by Steve Cotner on 6/6/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct KeyboardPadding: View {
    @ObservedObject private var keyboard = KeyboardResponder()
    var body: some View {
        Spacer().frame(height: keyboard.currentHeight)
            .animation(.linear(duration: 0.3))
    }
}
