//
//  RetailTutorial-Page.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/29/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine
import SwiftUI
import Foundation

extension RetailTutorial {
    class Page: ObservableObject {
        @Published var body: [Section] = [Section]()
        
        
        enum Section: String, Identifiable, Equatable {
            static func == (lhs: Page.Section, rhs: Page.Section) -> Bool {
                return lhs.id == rhs.id
            }

            case title
            case details
            case instruction
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
