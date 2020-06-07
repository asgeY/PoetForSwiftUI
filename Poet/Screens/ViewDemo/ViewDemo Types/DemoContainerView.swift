//
//  DemoContainerView.swift
//  Poet
//
//  Created by Steve Cotner on 6/6/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct DemoContainerView<Content, Panel>: View where Content: View, Panel: View {
    var content: () -> Content
    var panel: () -> Panel
    
    init(@ViewBuilder content: @escaping () -> Content, @ViewBuilder panel: @escaping () -> Panel) {
        self.content = content
        self.panel = panel
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    VStack(spacing: 20) {
                        Spacer().frame(height: 20)
                        HStack(spacing: 0) {
                            Spacer().frame(width: 20)
                            self.content()
                                .background(Color.white)
                                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
                            Spacer().frame(width: 20)
                        }
                        Spacer().frame(height: 20)
                    }.background(
                        ZStack {
                            Color(UIColor(white: 0.92, alpha: 0.9))
                            Image("diagonalpattern_half")
                                .resizable(resizingMode: .tile)
                                .opacity(0.08)
                        }
                    )
                    
                    Spacer().frame(height: 30)
                    
                    self.panel()
                    
                    KeyboardPadding()
                }
            }
        }
    }
}
