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
        
        // iPhone SE, 7, 8, and X are 375 (small).
        if width < 376 {
            return .small
        }
        
        // iPhone 7 Plus, 8 Plus, Xs Max, XR are 414 (medium).
        else if width < 600 {
            return .medium
        }
        
        // Smallest iPad begins at 768. We'll cover anything from 600 up.
        else {
            return .big
        }
    }()
}
