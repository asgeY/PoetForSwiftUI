//
//  PageBodyView.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/26/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct PageBodyView: View {
    @ObservedObject var pageBody: ObservableArray<Page.Element>
    
    init(pageBody: ObservableArray<Page.Element>) {
        self.pageBody = pageBody
    }
    
    func view(for element: Page.Element) -> AnyView {
        switch element {
            case .text(let string):
                return AnyView(
                    Text(string)
                        .font(Font.body.monospacedDigit())
                        .lineSpacing(4)
                        .padding(.bottom, 20)
                        .fixedSize(horizontal: false, vertical: true)
                )
                
            case .code(let string):
                return AnyView(
                    
                    HStack {
                        Text(string)
                            .font(Font.system(size: 12, design: .monospaced))
                            .lineSpacing(4)
                            .padding(EdgeInsets(top: 12, leading: 14, bottom: 12, trailing: 14))
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                    }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.primary.opacity(0.035)))
//                        .padding(.bottom, 20)
                        .padding(EdgeInsets(top: 0, leading: -14, bottom: 20, trailing: -14))
                )
                
            case .quote(let string):
                return AnyView(
                    Text(string)
                        .font(Font.system(size: 14, design: .monospaced))
                        .lineSpacing(3)
                        .padding(.bottom, 20)
                        .fixedSize(horizontal: false, vertical: true)
                )
            
            case .leftLargeTitle(let string):
                return AnyView(
                   HStack {
                       Text(string)
                           .multilineTextAlignment(.leading)
                           .font(Font.system(size: 32, weight: .bold, design: .default))
                           .padding(EdgeInsets(top: 0, leading: 0, bottom: 28, trailing: 0))
                           .fixedSize(horizontal: false, vertical: true)
                       Spacer()
                   }
               )
            
            case .leftMediumTitle(let string):
             return AnyView(
                HStack {
                    Text(string)
                        .multilineTextAlignment(.leading)
                        .font(Font.system(size: 24, weight: .bold, design: .default))
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }
            )
            
            case .largeTitle(let string):
                return AnyView(
                    HStack {
                        Spacer()
                        Text(string)
                            .multilineTextAlignment(.center)
                            .font(Font.system(size: 19, weight: .semibold, design: .default))
                            .padding(EdgeInsets(top: 6, leading: 0, bottom: 24, trailing: 0))
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                    }
                )
            
            case .title(let string):
                return AnyView(
                    HStack {
                        Spacer()
                        Text(string)
                            .multilineTextAlignment(.center)
                            .font(Font.system(size: 17, weight: .semibold, design: .default))
                            .padding(.bottom, 20)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                    }
                )
            
            case .subtitle(let string):
                return AnyView(
                    Text(string)
                        .font(Font.system(size: 17, weight: .semibold, design: .default))
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                        .fixedSize(horizontal: false, vertical: true)
                )
            
            case .footnote(let string):
                return AnyView(
                    VStack(alignment: .leading) {
                        Divider()
                            .padding(.bottom, 20)
                        Text(string)
                            .font(Font.footnote.monospacedDigit())
                            .opacity(0.9)
                            .padding(.bottom, 20)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                )
            case .fineprint(let string):
                return AnyView(
                    VStack(alignment: .leading) {
                        Divider()
                            .padding(.bottom, 20)
                        Text(string)
                            .font(Font.system(size: 12, weight: .medium))
                            .opacity(0.4)
                            .padding(.bottom, 20)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                )
            
            case .signature(let string):
                return AnyView(
                    Text(string)
                        .font(Font.system(size: 17, weight: .medium, design: .serif).italic())
                        .lineSpacing(2)
                        .padding(.bottom, 20)
                        .fixedSize(horizontal: false, vertical: true)
                )
            
            case .image(let string):
                return AnyView(
                    VStack(alignment: .leading) {
                        
                        Image(string)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.bottom, 20)
                    }
                )
            
            case .space(let height):
                return AnyView(
                    Spacer().frame(height: CGFloat(height))
                )
            
            default:
                return AnyView(EmptyView())
        }
    }
    
    var body: some View {
        if self.pageBody.array.isEmpty {
            return AnyView(EmptyView())
        } else {
            return AnyView(
                ScrollView {
                    ForEach(pageBody.array, id: \.id) { element in
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                self.view(for: element)
                                Spacer()
                            }
                            if self.pageBody.array.firstIndex(of: element) == self.pageBody.array.count - 1 {
                                Spacer().frame(height:44)
                            }
                        }.padding(EdgeInsets(top: 0, leading: 56, bottom: 0, trailing: 56))
                    }
                }
//                List(pageBody.array, id: \.id) { element in
//                    VStack {
//                        self.view(for: element)
//                        if self.pageBody.array.firstIndex(of: element) == self.pageBody.array.count - 1 {
//                            Spacer().frame(height:44)
//                        }
//                    }
//                }
//                    .id(UUID()) // <-- this forces the list not to animate
//                    .onAppear() {
//                        UITableView.appearance().showsVerticalScrollIndicator = false
//                        UITableView.appearance().separatorColor = .clear
//                    }
            )
        }
    }
}
