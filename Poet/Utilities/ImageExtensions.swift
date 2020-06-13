//
//  ImageExtensions.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/8/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

extension Image {
    static func numberCircleFill(_ int: Int) -> Image {
        let systemName = (int <= 50) ? "\(int).circle.fill" : "circle.fill"
        return Image(systemName: systemName)
    }
    
    static func numberCircle(_ int: Int) -> Image {
        let systemName = (int <= 50) ? "\(int).circle" : "circle"
        return Image(systemName: systemName)
    }
}
