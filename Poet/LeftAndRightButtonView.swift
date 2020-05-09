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
        GeometryReader { geometry in
            
            // Left Button
            Button(action: self.leftAction.evaluate) {
                Image(systemName: "chevron.compact.left")
                    .resizable()
                    .frame(width: 7, height: 22, alignment: .center)
                    .padding(EdgeInsets(top: 30, leading: 10, bottom: 30, trailing: 30))
            }
            .offset(x: 0, y: geometry.size.height / 2)
            .disabled(!self.leftButtonIsEnabled.bool)
            .opacity(self.leftButtonIsEnabled.bool ? 1 : 0.25)
            .edgesIgnoringSafeArea([.top, .bottom])
            
            // Right Button
            Button(action: self.rightAction.evaluate) {
                Image(systemName: "chevron.compact.right")
                    .resizable()
                    .frame(width: 7, height: 22, alignment: .center)
                    .padding(EdgeInsets(top: 30, leading: 30, bottom: 30, trailing: 10))
            }
            .offset(x: geometry.size.width - 47, y: geometry.size.height / 2)
            .disabled(!self.rightButtonIsEnabled.bool)
            .opacity(self.rightButtonIsEnabled.bool ? 1 : 0.25)
            .edgesIgnoringSafeArea([.top, .bottom])
        }
        .foregroundColor(Color.primary)
    }
}

struct LeftAndRightButtonView_Previews: PreviewProvider {
    static var previews: some View {
        LeftAndRightButtonView(leftAction: {}, rightAction: {}, leftButtonIsEnabled: ObservableBool(), rightButtonIsEnabled: ObservableBool())
    }
}
