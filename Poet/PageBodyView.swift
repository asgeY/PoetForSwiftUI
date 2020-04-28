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
                        .padding(EdgeInsets(top: 0, leading: 36, bottom: 10, trailing: 36))
                )
                
            case .code(let string):
                return AnyView(
                    
                    HStack {
                        Text(string)
                            .font(Font.system(size: 11, design: .monospaced))
                            .padding(EdgeInsets(top: 12, leading: 13, bottom: 12, trailing: 13))
                        Spacer()
                    }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.black.opacity(0.035)))
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
                )
                
            case .quote(let string):
                return AnyView(
                    Text(string)
                        .font(Font.system(size: 14, design: .monospaced))
                        .lineSpacing(1)
                        .padding(EdgeInsets(top: 0, leading: 36, bottom: 10, trailing: 36))
                )
            
            case .title(let string):
                return AnyView(
                    HStack {
                        Spacer()
                        Text(string)
                            .multilineTextAlignment(.center)
                            .font(Font.system(size: 16, weight: .semibold, design: .default))
                            .padding(EdgeInsets(top: 0, leading: 36, bottom: 10, trailing: 36))
                        Spacer()
                    }
                )
            
            case .subtitle(let string):
                return AnyView(
                    Text(string)
                        .font(Font.system(size: 15, weight: .semibold, design: .default))
                        .padding(EdgeInsets(top: 0, leading: 36, bottom: 0, trailing: 36))
                )
            
            case .footnote(let string):
                return AnyView(
                    VStack(alignment: .leading) {
                        Divider()
                            .padding(EdgeInsets(top: 0, leading: 36, bottom: 10, trailing: 36))
                        Text(string)
                            .font(Font.footnote.monospacedDigit())
                            .opacity(0.9)
                            .padding(EdgeInsets(top: 0, leading: 36, bottom: 10, trailing: 36))
                            .multilineTextAlignment(.leading)
                    }
                )
            case .fineprint(let string):
                return AnyView(
                    Text(string)
                        .font(Font.system(size: 10, design: .monospaced))
                        .opacity(0.5)
                        .padding(EdgeInsets(top: 0, leading: 36, bottom: 10, trailing: 36))
                )
            
            case .image(let string):
                return AnyView(
                    VStack(alignment: .leading) {
                        
                        Image(string)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(EdgeInsets(top: 0, leading: 30, bottom: 10, trailing: 30))
                    }
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
                List(pageBody.array, id: \.id) { element in
                    VStack {
                        self.view(for: element)
                        if self.pageBody.array.firstIndex(of: element) == self.pageBody.array.count - 1 {
                            Spacer().frame(height:44)
                        }
                    }
                }
                    .id(UUID()) // <-- this forces the list not to animate
                    .onAppear() {
                        UITableView.appearance().showsVerticalScrollIndicator = false
                        UITableView.appearance().separatorStyle = .none
                    }
            )
        }
    }
}
