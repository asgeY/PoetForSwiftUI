//
//  Device.swift
//  Poet
//
//  Created by Steve Cotner on 5/22/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import UIKit

enum Device {
    case big // iPads
    case medium // iPhones except SE
    case small // SE and iPod
    
    static let current: Device = {
        let bounds = UIScreen.main.bounds
        let width = min(bounds.width, bounds.height)
        
        // SE is 320 (small). iPhone 7, 8, X, and Xs are 375 (medium)
        if width < 375 {
            return .small
        }
        
        // iPhone 7 Plus, 8 Plus, Xs Max, XR are 414 (medium). Smallest iPad size begins at 768 (big)
        else if width < 600 {
            return .medium
        }
        
        // iPad begins at 768
        else {
            return .big
        }
    }()
}
