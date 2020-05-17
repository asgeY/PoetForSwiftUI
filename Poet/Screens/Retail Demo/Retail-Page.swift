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
            case title
            case instruction
            case details
            case displayableProducts
            case products
            case findableProducts
            case deliveryOptions
            case completedSummary
            case space
            case divider
            
            var id: String {
                return rawValue
            }
        }
    }
}
