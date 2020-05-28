//
//  NamedEvaluatorAction.swift
//  Poet
//
//  Created by Steve Cotner on 5/28/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

struct NamedEvaluatorAction {
    let name: String
    let action: EvaluatorAction
    var id: UUID = UUID()
}

struct NumberedNamedEvaluatorAction {
    let number: Int
    let name: String
    let action: EvaluatorAction
    var id: UUID = UUID()
}
