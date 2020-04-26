//
//  ButtonActionView.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/24/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct ButtonActionView: View {
    let action: Action
    let content: AnyView
    
    var body: some View {
        Button(action: action.evaluate) {
            self.content
        }
    }
}
