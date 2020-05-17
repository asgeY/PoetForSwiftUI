//
//  CharacterBezelTranslating.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/16/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

protocol CharacterBezelTranslating {
    var characterBezelTranslator: CharacterBezelTranslator { get }
    func showBezel(character: String)
}

extension CharacterBezelTranslating {
    func showBezel(character: String) {
        characterBezelTranslator.character.string = character
    }
}

struct CharacterBezelTranslator {
    var character = PassableString()
}
