//
//  RetailTutorial-Page.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/29/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine
import SwiftUI

extension RetailTutorial {
    class Page: ObservableObject {
        @Published var body: [Section] = [Section]()
        
        enum Section: String, ObservingPageSection {
            case title
            case instruction
            case details
            case products
            case findableProducts
            case deliveryOptions
            case completedSummary
            
            var id: String {
                return rawValue
            }
        }
    }
}
