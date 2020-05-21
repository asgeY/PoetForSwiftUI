//
//  TutorialBodyView.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/21/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct TutorialBodyView: View {
    @ObservedObject var bodyElements: ObservableArray<Tutorial.Evaluator.Page.Body>
    @Binding var isTouching: Bool
    
    let bottomPadding: CGFloat = 16
    
    var body: some View {
        VStack {
            ForEach(bodyElements.array, id: \.id) { bodyElement in
                HStack {
                    self.viewForBodyElement(bodyElement)
                    Spacer()
                }
            }
            Spacer()
        }.padding(EdgeInsets(top: 26, leading: 26, bottom: -bottomPadding, trailing: 26))
    }
    
    func viewForBodyElement(_ bodyElement: Tutorial.Evaluator.Page.Body) -> AnyView {
        switch bodyElement {
        case .text(let text):
            return AnyView(
                Text(text)
                    .font(Font.body)
                    .lineSpacing(5)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, 16)
                    .opacity(self.isTouching ? 0.33 : 1)
            )
        case .code(let code):
            return AnyView(
                Text(code)
                    .font(Font.system(size: 13, weight: .regular, design: .monospaced))
                    .lineSpacing(5)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: bottomPadding, trailing: -40))
                    .opacity(self.isTouching ? 0.33 : 1)
            )
            
        case .smallCode(let code):
            return AnyView(
                Text(code)
                    .font(Font.system(size: 12, weight: .regular, design: .monospaced))
                    .lineSpacing(5)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: bottomPadding, trailing: -40))
                    .opacity(self.isTouching ? 0.33 : 1)
            )
            
        case .extraSmallCode(let code):
            return AnyView(
                Text(code)
                    .font(Font.system(size: 11, weight: .regular, design: .monospaced))
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: bottomPadding, trailing: -40))
                    .opacity(self.isTouching ? 0.33 : 1)
            )
        }
    }
}
