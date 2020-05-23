//
//  BezelTranslating.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/16/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

protocol BezelTranslating {
    var bezelTranslator: BezelTranslator { get }
    func showBezel(text: String, textSize: BezelView.TextSize)
}

extension BezelTranslating {
    func showBezel(text: String, textSize: BezelView.TextSize) {
        bezelTranslator.text.string = text
        bezelTranslator.textSize.value = textSize
    }
}

struct BezelTranslator {
    var text = PassableString()
    var textSize = Observable<BezelView.TextSize>(BezelView.TextSize.medium)
}
