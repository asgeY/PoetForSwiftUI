//
//  Template-Screen.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/2/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct Template {}

extension Template {
    struct Screen: View {
        
        let evaluator: Evaluator
        let translator: Translator
        
        init() {
            evaluator = Evaluator()
            translator = evaluator.translator
        }
        
        var body: some View {
            ZStack {
                VStack(spacing: 0) {
                    ObservingTextView(translator.title)
                        .font(Font.headline)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 22)

                    ObservingTextView(translator.body, alignment: .leading)
                        .font(Font.body)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(EdgeInsets(top: 30, leading: 50, bottom: 50, trailing: 50))
                    
                    Spacer()
                }
                
                VStack {
                    DismissButton(orientation: .right)
                    Spacer()
                }
            }.onAppear {
                self.evaluator.viewDidAppear()
            }
        }
    }
}
