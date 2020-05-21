//
//  PageBodyView.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/26/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct StaticPageViewMaker: ObservingPageView_ViewMaker {

    func view(for section: ObservingPageViewSection) -> AnyView {
        guard let section = section as? StaticPage.Section else { return AnyView(EmptyView()) }
        switch section {
            case .text(let string):
                return AnyView(
                    HStack {
                        Text(string)
                            .font(Font.body.monospacedDigit())
                            .lineSpacing(4)
                            .padding(.bottom, 20)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                    }
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
                    HStack {
                        Text(string)
                            .font(Font.system(size: 14, design: .monospaced))
                            .lineSpacing(3)
                            .padding(.bottom, 20)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                    }
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
                    HStack {
                        Text(string)
                            .font(Font.system(size: 17, weight: .semibold, design: .default))
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                    }
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
                    HStack {
                        Text(string)
                            .font(Font.system(size: 17, weight: .medium, design: .serif).italic())
                            .lineSpacing(2)
                            .padding(.bottom, 20)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                    }
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
}

struct StaticPage {
    let body: [Section]
    
    enum Section: ObservingPageViewSection {
        static func == (lhs: StaticPage.Section, rhs: StaticPage.Section) -> Bool {
            return lhs.id == rhs.id
        }

        case text(String)
        case code(String)
        case quote(String)
        case leftLargeTitle(String)
        case leftMediumTitle(String)
        case largeTitle(String)
        case title(String)
        case subtitle(String)
        case footnote(String)
        case fineprint(String)
        case signature(String)
        case image(String)
        case space(Int)
        case link(name: String, url: URL) // not implemented yet
        
        var id: String {
            switch self {
            case .text(let string):
                return "text_\(string)"
            case .code(let string):
                return "code_\(string)"
            case .quote(let string):
                return "quote_\(string)"
            case .leftLargeTitle(let string):
                return "leftLargeTitle_\(string)"
            case .leftMediumTitle(let string):
                return "leftMediumTitle_\(string)"
            case .largeTitle(let string):
                return "largeTitle_\(string)"
            case .title(let string):
                return "title_\(string)"
            case .subtitle(let string):
                return "subtitle_\(string)"
            case .footnote(let string):
                return "footnote_\(string)"
            case .fineprint(let string):
                return "fineprint_\(string)"
            case .signature(let string):
            return "signature_\(string)"
            case .image(let string):
                return "image_\(string)"
            case .link(let name, _):
                return "link_\(name)"
            case .space(let height):
                return "space_\(height)"
            }
        }
    }
}
