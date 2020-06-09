//
//  DemoBuilder-Screen.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/2/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct DemoBuilder {}

extension DemoBuilder {
    
    struct Screen: View {
        let evaluator: Evaluator
        let translator: Translator
        
        init() {
            evaluator = Evaluator()
            translator = evaluator.translator
        }
        
        var body: some View {
            return ZStack {
                VStack {
                    Spacer().frame(height:22)
                    Text("Demo Builder")
                }
                VStack {
                    DismissButton(orientation: .right)
                    Spacer()
                }
            }
            .onAppear {
                self.evaluator.viewDidAppear()
            }
        }
    }
}
