//
//  DemoControl.swift
//  Poet
//
//  Created by Steve Cotner on 6/6/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct DemoControl {
    let title: String
    var instructions: String? = nil
    let viewMaker: () -> AnyView
    let id: UUID = UUID()
}
