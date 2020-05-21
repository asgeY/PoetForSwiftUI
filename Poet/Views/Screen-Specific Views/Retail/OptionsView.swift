//
//  OptionsView.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/21/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct OptionsView: View {
    @ObservedObject var options: ObservableArray<String>
    @ObservedObject var preference: ObservableString
    weak var evaluator: OptionsEvaluator?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(options.array, id: \.self) { option in
                HStack {
                    OptionView(option: option, preference: self.preference.string, evaluator: self.evaluator)
                    Spacer()
                }
            }
        }
    }
}

struct OptionView: View {
    let option: String
    let preference: String
    weak var evaluator: OptionsEvaluator?
    
    var body: some View {
        let isSelected = self.option == self.preference
        return ZStack(alignment: .topLeading) {
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.primary)
                .frame(width: isSelected ? 25.5 : 23, height: isSelected ? 25.5 : 23)
                .animation(.spring(response: 0.25, dampingFraction: 0.25, blendDuration: 0), value: isSelected)
                .padding(EdgeInsets(top: isSelected ? -2.25 : -1, leading: isSelected ? 38.75 : 40, bottom: 0, trailing: 0))
            Text(self.option)
                .font(Font.headline)
                .layoutPriority(20)
                .padding(EdgeInsets(top: 0, leading: 76, bottom: 0, trailing: 76))
        }
        .onTapGesture {
            self.evaluator?.toggleOption(self.option)
        }
    }
}
