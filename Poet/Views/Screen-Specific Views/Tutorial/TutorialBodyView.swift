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
    
    let bottomPadding: CGFloat = {
        switch Device.current {
        case .small, .medium:
            return 9
        case .big:
            return 11
        }
    }()
    
    var body: some View {
        VStack {
            ForEach(bodyElements.array, id: \.id) { bodyElement in
                HStack {
                    self.viewForBodyElement(bodyElement)
                    Spacer()
                }
            }
            Spacer()
        }.padding(EdgeInsets(top: 26, leading: 26, bottom: -16, trailing: 26))
    }
    
    func viewForBodyElement(_ bodyElement: Tutorial.Evaluator.Page.Body) -> AnyView {
        switch bodyElement {
        case .text(let text):
            return AnyView(
                VStack(alignment: .leading, spacing: 0) {
                    Text(text)
                        .font(FontSystem.body)
                        .lineSpacing(FontSystem.Spacing.body)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, 16)
                        .opacity(self.isTouching ? 0.33 : 1)
                    Spacer().frame(height: bottomPadding)
                }
            )
        case .code(let code):
            return AnyView(
                VStack(alignment: .leading, spacing: 0) {
                    Text(code)
                        .font(FontSystem.code)
                        .kerning(FontSystem.Kerning.code)
                        .lineSpacing(FontSystem.Spacing.code)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: bottomPadding, trailing: -45))
                        .opacity(self.isTouching ? 0.33 : 1)
                    Spacer().frame(height: bottomPadding)
                }
            )
            
        case .smallCode(let code):
            return AnyView(
                VStack(alignment: .leading, spacing: 0) {
                    Text(code)
                        .font(FontSystem.codeSmall)
                        .kerning(FontSystem.Kerning.codeSmall)
                        .lineSpacing(FontSystem.Spacing.code)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: bottomPadding, trailing: -45))
                        .opacity(self.isTouching ? 0.33 : 1)
                    Spacer().frame(height: bottomPadding)
                }
            )
            
        case .extraSmallCode(let code):
            return AnyView(
                VStack(alignment: .leading, spacing: 0) {
                    Text(code)
                        .font(FontSystem.codeExtraSmall)
                        .kerning(FontSystem.Kerning.codeSmall)
                        .lineSpacing(FontSystem.Spacing.codeExtraSmall)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: bottomPadding, trailing: -45))
                        .opacity(self.isTouching ? 0.33 : 1)
                    Spacer().frame(height: bottomPadding)
                }
            )
        }
    }
}
