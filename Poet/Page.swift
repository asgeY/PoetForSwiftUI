//
//  Page.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/26/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

struct Page {
    let body: [Element]
    
    enum Element: Identifiable, Equatable {
        static func == (lhs: Page.Element, rhs: Page.Element) -> Bool {
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
