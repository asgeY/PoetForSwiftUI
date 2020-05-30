//
//  BusyPresenter.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/29/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation
import SwiftUI

struct BusyPresenter: View {
    let passableBool: PassableBool
    
    @State var isShowing: Bool = false
    
    var sink: Sink?
    
    init(_ passableBool: PassableBool) {
        self.passableBool = passableBool
    }
    
    var body: some View {
        GeometryReader() { geometry in
            ZStack {
                Rectangle()
                    .fill(Color.primary.opacity(0.2))
                
                ActivityIndicator()
            }
            .opacity(self.isShowing ? 1 : 0)
            .animation(.linear(duration: 0.4))
            .allowsHitTesting(self.isShowing ? true : false)
            .edgesIgnoringSafeArea([.top, .bottom])
        }.onReceive(passableBool.subject) { (bool) in
            if let bool = bool {
                self.isShowing = bool
            }
        }
    }
}

struct ActivityIndicator: View {
    var size: CGFloat = 60
    @State private var isAnimating: Bool = false
    
    var body: some View {
        Rectangle()
            .fill(Color.clear)
            .frame(width: size, height: size)
            .background(
                GeometryReader { (geometry: GeometryProxy) in
                    ForEach(0..<20) { index in
                        Group {
                            Circle()
                                .foregroundColor(Color(UIColor.systemBackground))
                                .frame(width: geometry.size.width / 10, height: geometry.size.height / 10)
                                .scaleEffect(!self.isAnimating ? 1 : 0.5 + CGFloat(index) / 40)
                                .offset(y: geometry.size.width / 10 - geometry.size.height / 2)
                        }.frame(width: geometry.size.width, height: geometry.size.height)
                            .rotationEffect(!self.isAnimating ? .degrees(0) : .degrees(360))
                            .animation(Animation
                                .timingCurve(1, 0 + Double(index) / 20, 1, 1, duration: 1.25)
                                .repeatForever(autoreverses: false))
                    }
                }
                .aspectRatio(1, contentMode: .fit)
                .onAppear {
                    self.isAnimating = true
                }
        )
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
