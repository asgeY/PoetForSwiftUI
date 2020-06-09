//
//  NamedIdentifiedValue.swift
//  Poet
//
//  Created by Stephen E. Cotner on 6/9/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

struct NamedIdentifiedValue<T>: Identifiable {
    let title: String
    let value: T
    let id: UUID = UUID()
}
