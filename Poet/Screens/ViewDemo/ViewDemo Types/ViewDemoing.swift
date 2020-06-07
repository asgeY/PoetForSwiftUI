//
//  ViewDemoing.swift
//  Poet
//
//  Created by Steve Cotner on 6/6/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

protocol ViewDemoing {
    static var demoProvider: DemoProvider { get }
    static var namedDemoProvider: NamedDemoProvider { get }
}

extension ViewDemoing {
    static var namedDemoProvider: NamedDemoProvider {
        return NamedDemoProvider(
            title: String(describing: Self.self),
            demoProvider: self.demoProvider)
    }
}
