//
//  NamedDemoProvider.swift
//  Poet
//
//  Created by Stephen E. Cotner on 6/10/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

struct NamedDemoProvider: DeepCopying {
    let title: String
    let demoProvider: DemoProvider
    var id: UUID = UUID()
    
    func deepCopy() -> Self {
        let provider = NamedDemoProvider(
            title: self.title,
            demoProvider: self.demoProvider.deepCopy(),
            id: self.id
        )
        return provider
    }
}
