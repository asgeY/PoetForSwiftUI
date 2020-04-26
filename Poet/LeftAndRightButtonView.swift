//
//  LeftAndRightButtonView.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/19/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct LeftAndRightButtonView: View {
    let leftAction: Action
    let rightAction: Action
    @ObservedObject var leftButtonIsEnabled: ObservableBool
    @ObservedObject var rightButtonIsEnabled: ObservableBool
    
    var body: some View {
        HStack {
            // Left Button
            Button(action: leftAction.evaluate) {
                Image(systemName: "chevron.compact.left")
                    .resizable()
                    .frame(width: 7, height: 22, alignment: .center)
                    .padding(EdgeInsets(top: 20, leading: 12, bottom: 20, trailing: 20))
            }.disabled(!leftButtonIsEnabled.bool)
            .opacity(leftButtonIsEnabled.bool ? 1 : 0.6)
            Spacer()
            // Right Button
            Button(action: rightAction.evaluate) {
                Image(systemName: "chevron.compact.right")
                    .resizable()
                    .frame(width: 7, height: 22, alignment: .center)
                    .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 12))
            }.disabled(!rightButtonIsEnabled.bool)
            .opacity(rightButtonIsEnabled.bool ? 1 : 0.6)
        }
    }
}

struct LeftAndRightButtonView_Previews: PreviewProvider {
    static var previews: some View {
        LeftAndRightButtonView(leftAction: {}, rightAction: {}, leftButtonIsEnabled: ObservableBool(), rightButtonIsEnabled: ObservableBool())
    }
}
