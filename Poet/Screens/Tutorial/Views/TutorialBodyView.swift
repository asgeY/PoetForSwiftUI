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
    let evaluator: Tutorial.Evaluator
    
    let bottomPadding: CGFloat = {
        switch Device.current {
        case .small, .medium:
            return 28
        case .big:
            return 29
        }
    }()
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(bodyElements.array, id: \.id) { bodyElement in
                self.viewForBodyElement(bodyElement)
            }
            Spacer()
        }
        .padding(EdgeInsets(top: 26, leading: 0, bottom: -20, trailing: 0))
    }
    
    func viewForBodyElement(_ bodyElement: Tutorial.Evaluator.Page.Body) -> AnyView {
        switch bodyElement {
        case .text(let text):
            return AnyView(
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(text)
                            .font(FontSystem.body)
                            .lineSpacing(FontSystem.Spacing.body)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer().frame(height: bottomPadding)
                    }
                    Spacer()
                }
            )
            
        case .title(let text):
            return AnyView(
                VStack(alignment: .leading, spacing: 0) {
                    Spacer().frame(height: 12)
                    Divider()
                        .opacity(0.75)
                    Spacer().frame(height: 26)
                    Text(text)
                        .font(FontSystem.smallTitle)
                        .lineSpacing(FontSystem.Spacing.body)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer().frame(height: bottomPadding)
                }
            )
            
        case .divider:
            return AnyView(
                VStack(alignment: .leading, spacing: 0) {
                    Spacer().frame(height: 12)
                    Divider()
                        .opacity(0.75)
                    Spacer().frame(height: 32)
                }
            )
            
        case .code(let code):
            return AnyView(
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        Spacer().frame(height: 10)
                        Text(code)
                            .font(FontSystem.code)
                            .kerning(FontSystem.Kerning.code)
                            .lineSpacing(FontSystem.Spacing.code)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: -48))
                        Spacer().frame(height: bottomPadding)
                        Spacer().frame(height: 10)
                    }
                    Spacer()
                }
            )
            
        case .smallCode(let code):
            return AnyView(
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        Spacer().frame(height: 10)
                        Text(code)
                            .font(FontSystem.codeSmall)
                            .kerning(FontSystem.Kerning.codeSmall)
                            .lineSpacing(FontSystem.Spacing.code)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: -48))
                        Spacer().frame(height: bottomPadding)
                        Spacer().frame(height: 10)
                    }
                    Spacer()
                }
            )
            
        case .extraSmallCode(let code):
            return AnyView(
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        Spacer().frame(height: 10)
                        Text(code)
                            .font(FontSystem.codeExtraSmall)
                            .kerning(FontSystem.Kerning.codeSmall)
                            .lineSpacing(FontSystem.Spacing.codeExtraSmall)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: -48))
                        Spacer().frame(height: bottomPadding)
                        Spacer().frame(height: 10)
                    }
                    Spacer()
                }
            )
            
        case .codeScrolling(let code):
            return AnyView(
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        VStack(alignment: .leading, spacing: 0) {
                            Spacer().frame(height: 10)
                            Text(code)
                                .font(FontSystem.code)
                                .kerning(FontSystem.Kerning.code)
                                .lineSpacing(FontSystem.Spacing.code)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            Spacer().frame(height: bottomPadding)
                            Spacer().frame(height: 10)
                        }
                        Spacer()
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: -42))
            )
        
        case .bullet(let text):
            return AnyView(
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .top, spacing: 0) {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .frame(width: 8, height: 8)
                            .padding(.top, 7)
                        Spacer().frame(width: 20)
                        Text(text)
                            .font(FontSystem.body)
                            .lineSpacing(FontSystem.Spacing.body)
                            .fixedSize(horizontal: false, vertical: false)
                        Spacer()
                    }
                    Spacer().frame(height: bottomPadding)
                }
            )
        
        case .button(let action):
            return AnyView(
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        Spacer()
                        Button(action: { self.evaluator.evaluate(action) }) {
                            Text(action.name)
                                .font(Font.headline)
                                .foregroundColor(Color(UIColor.systemBackground))
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(EdgeInsets(top: 12, leading: 22, bottom: 12, trailing: 22))
                                .background(
                                    Capsule()
                                        .fill(Color.primary.opacity(0.96))
                            )
                        }
                        
                        Spacer()
                    }
                    Spacer().frame(height: 38)
                }
            )
            
        case .file(let fileName):
            return AnyView(
                VStack(spacing: 0) {
                    FileNameView(fileName)
                    Spacer().frame(height: bottomPadding)
                }
            )
            
        case .demo(let action):
        return AnyView(
            VStack(spacing: 0) {
                DemoButtonView(action: action, evaluator: evaluator)
                Spacer().frame(height: bottomPadding)
            }
        )
            
        case .space(let space):
            return AnyView(
                Spacer().frame(height: space)
            )
            
        case .aside(let text):
            return AnyView(
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(text)
                            .font(FontSystem.aside)
                            .lineSpacing(FontSystem.Spacing.body)
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(Color.primary.opacity(0.5))
                        Spacer().frame(height: bottomPadding)
                    }
                    Spacer()
                }
            )
        }
    }
}

struct FileNameView: View {
    let fileName: String
    let textFile: TextFile?
    
    let showFile = PassableString()
    
    init(_ fileName: String) {
        self.fileName = fileName
        self.textFile = TextFile.fromFileName(fileName)
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Button(action: {
                    if let body = self.textFile?.body {
                        self.showFile.withString(body)
                    }
                }) {
                    VStack(spacing: 0) {
                        Spacer().frame(height: 20)
                        
                        HStack(spacing: 0) {
                            Spacer().frame(width:20)
                            Image(systemName: "doc.plaintext")
                                .foregroundColor(Color.primary.opacity(0.95))
                            Spacer().frame(width: 10)
                            Text(fileName)
                                .font(FontSystem.detail)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(Color.primary.opacity(0.95))
                            
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color.primary.opacity(0.3))
                            Spacer().frame(width:20)
                        }
                        
                        Spacer().frame(height: 20)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.primary.opacity(0.03))
                    )
                }
            }
            PresenterWithString(showFile) { text in
                SupplementaryCodeView(code: text)
            }
        }
        
    }
}

struct DemoButtonView: View {
    let action: Tutorial.Evaluator.Action
    let evaluator: Tutorial.Evaluator
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Button(action: {
                    self.evaluator.evaluate(self.action)
                }) {
                    VStack(spacing: 0) {
                        Spacer().frame(height: 20)
                        
                        HStack(spacing: 0) {
                            Spacer().frame(width:20)
                            Image(systemName: "macwindow")
                                .foregroundColor(Color.primary.opacity(0.95))
                            Spacer().frame(width: 10)
                            Text(action.name)
                                .font(FontSystem.detail)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(Color.primary.opacity(0.95))
                            
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color.primary.opacity(0.3))
                            Spacer().frame(width:20)
                        }
                        
                        Spacer().frame(height: 20)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.primary.opacity(0.03))
                    )
                }
            }
        }
    }
}
