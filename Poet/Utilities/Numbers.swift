//
//  Numbers.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/25/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation
import UIKit

extension Double {
    func bounded(minimum: Double, maximum: Double) -> Double {
        let bottomBounded = max(minimum, self)
        let topBoundedToo = min(maximum, bottomBounded)
        return topBoundedToo
    }
}

extension CGFloat {
    func bounded(minimum: CGFloat, maximum: CGFloat) -> CGFloat {
        let bottomBounded = Swift.max(minimum, self)
        let topBoundedToo = Swift.min(maximum, bottomBounded)
        return topBoundedToo
    }
}
