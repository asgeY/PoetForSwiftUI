//
//  DismissReceiver-Translator.swift
//  Poet
//
//  Created by Stephen E Cotner on 5/1/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine

extension DismissReceiverExample {
    class Translator: DismissTranslating {
        
        // Composable Translating
        var dismissTranslator = DismissTranslator()
        
        // Display State
        var countdown = ObservableString()
        var countdownBehavior: Behavior?
        
        init(count: PassableInt) {
            self.countdownBehavior = count.subject.sink { newValue in
                if let newValue = newValue {
                    self.countdown.string = "In \(newValue) seconds, this screen will self-dismiss."
                }
            }
        }
    }
}
