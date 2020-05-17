//
//  Retail-Page.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/29/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine
import SwiftUI

extension Retail {
    class Page: ObservableObject {
        @Published var body: [Section] = [Section]()
        
        enum Section: String, ObservingPageSection {
            case canceledTitle
            case completedTitle
            case completedSummary
            case customerTitle
            case deliveryOptions
            case details
            case displayableProducts
            case divider
            case findableProducts
            case instruction
            case products
            case space
            case topSpace
            
            var id: String {
                return rawValue
            }
        }
    }
}
