//
//  AfterWait.swift
//  Poet
//
//  Created by Steve Cotner on 5/6/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

func afterWait(_ milliseconds: Int, completion: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now().advanced(by: .milliseconds(milliseconds))) {
        completion()
    }
}
