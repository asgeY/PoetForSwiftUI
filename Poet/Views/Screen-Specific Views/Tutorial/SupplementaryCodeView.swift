//
//  SupplementaryCodeView.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/21/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct SupplementaryCodeView: View {
    let code: String
    let textColor = Color(UIColor(red: 244/255.0, green: 244/255.0, blue: 246/255.0, alpha: 1))
    let backgroundColor = Color(UIColor(red: 31/255.0, green: 32/255.0, blue: 38/255.0, alpha: 1))
    let barColor = Color(UIColor(red: 37/255.0, green: 40/255.0, blue: 47/255.0, alpha: 0.98))
    
    var body: some View {
        ZStack {
            VStack {
                DismissButton(foregroundColor: textColor)
                Spacer()
            }.background(Color.clear)
            .zIndex(2)
            
            VStack(alignment: .leading) {
                ScrollView(.horizontal, showsIndicators: false) {
                    ScrollView(.vertical, showsIndicators: false) {
                        Spacer().frame(height:26)
                        Text(code)
                            .font(Font.system(size: 12.5, weight: .medium, design: .monospaced))
                            .foregroundColor(textColor)
                            .lineSpacing(5)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(EdgeInsets(top: 0, leading: 30, bottom: 44, trailing: 16))
                        Spacer()
                    }
                }
            }.background(Rectangle().fill(
                backgroundColor
            )).zIndex(0)
        }.edgesIgnoringSafeArea(.bottom)
    }
}
