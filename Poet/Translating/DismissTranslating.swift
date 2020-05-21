//
//  DismissTranslating.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/21/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

protocol DismissTranslating {
    var dismissTranslator: DismissTranslator { get }
    func dismiss()
}

extension DismissTranslating {
    func dismiss() {
        dismissTranslator.dismiss.please()
    }
}

struct DismissTranslator {
    var dismiss = PassablePlease()
}
