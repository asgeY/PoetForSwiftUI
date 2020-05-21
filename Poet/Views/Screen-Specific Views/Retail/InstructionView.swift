//
//  InstructionView.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/21/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct InstructionView: View {
    @ObservedObject var instructionNumber: ObservableInt
    @ObservedObject var instruction: ObservableString
    
    var body: some View {
        HStack {
            ZStack(alignment: .topLeading) {
                Image.numberCircleFill(instructionNumber.int)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.primary)
                    .frame(width: 24, height: 24)
                    .padding(EdgeInsets(top: 0, leading: 39.5, bottom: 0, trailing: 0))
                    .offset(x: 0, y: -2)
                Text(instruction.string)
                    .font(Font.system(size: 17, weight: .bold).monospacedDigit())
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(EdgeInsets(top: 0, leading: 76, bottom: 0, trailing: 76))
            }
            Spacer()
        }
    }
}
