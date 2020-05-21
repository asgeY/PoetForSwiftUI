//
//  DismissReceiverExample-Evaluator.swift
//  Poet
//
//  Created by Stephen E Cotner on 5/1/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation
import SwiftUI

extension DismissReceiverExample {
    
    class Evaluator {
        
        var count = PassableInt()
        
        // Translator
        lazy var translator: Translator = Translator(count: count)
    }
}

extension DismissReceiverExample.Evaluator: ViewCycleEvaluator {
    func viewDidAppear() {
        countDownToDismiss()
    }
    
    func countDownToDismiss() {
        func countDown(_ int: Int) {
            count.int = int
            if int > 0 {
                afterWait(1000) {
                    let newValue = int - 1
                    self.count.int = newValue
                    countDown(newValue)
                }
                
                
            } else {
                afterWait(100) {
                    self.translator.dismiss()
                }
            }
        }
        
        countDown(5)
    }
}
