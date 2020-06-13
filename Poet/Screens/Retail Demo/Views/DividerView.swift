//
//  DividerView.swift
//  Poet
//
//  Created by Stephen E. Cotner on 6/13/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct DividerView: View {
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .background(Color.primary)
                .frame(height: 2)
                .opacity(0.25)
                .padding(.leading, 40)
            
            Spacer().frame(height: 28)
        }
    }
}
