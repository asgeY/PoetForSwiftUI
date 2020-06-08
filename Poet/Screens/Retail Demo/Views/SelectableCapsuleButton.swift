//
//  SelectableCapsuleButton.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/21/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct SelectableCapsuleButton: View {
    let title: String
    let isSelected: Bool
    let imageName: String
    let action: (() -> Void)?
    
    var body: some View {
        return HStack(spacing: 0) {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color(UIColor.systemBackground))
                .frame(
                    width: self.isSelected ? 12 : 0,
                    height: self.isSelected ? 12 : 0)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0))
                .animation( self.isSelected ? (.spring(response: 0.37, dampingFraction: 0.4, blendDuration: 0.825)) : .linear(duration: 0.2), value: self.isSelected)
                .layoutPriority(30)
            Text(title)
                .font(Font.system(.headline))
                .foregroundColor( self.isSelected ? Color(UIColor.systemBackground) : .primary)
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
                .padding(EdgeInsets(top: 10, leading: (isSelected ? 8 : 4), bottom: 10, trailing: 0))
                .layoutPriority(51)
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 22))
        .layoutPriority(31)
        .background(
            ZStack {
                BlurView()
                Rectangle()
                    .fill(Color.primary.opacity( self.isSelected ? 0.95 : 0))
            }
            .mask(
                Capsule()
            )
            
        )
            .animation(.linear(duration: 0.2), value: self.isSelected)
        .onTapGesture {
            self.action?()
        }
    }
}
