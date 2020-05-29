//
//  TextEntry-Screen.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/2/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct TextEntry {}

extension TextEntry {
    struct Screen: View {
        
        let _evaluator: Evaluator
        weak var evaluator: Evaluator?
        let translator: Translator
        
        init() {
            _evaluator = Evaluator()
            evaluator = _evaluator
            translator = _evaluator.translator
        }
        
        @State var navBarHidden: Bool = true
        
        var body: some View {
            ZStack {
                VStack(spacing: 0) {
                    ObservingTextView(translator.title)
                        .font(Font.headline)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 22)

                    ObservingTextField(
                        placeholder: self.translator.textFieldPlaceholder,
                        text: self.translator.textFieldText,
                        elementName: Evaluator.Element.textField,
                        evaluator: evaluator)
                    
                    Spacer().frame(height: 20)
                    
                    Text("You entered:")
                    
                    ObservingTextView(translator.body)
                        .font(Font.body)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(EdgeInsets(top: 10, leading: 50, bottom: 50, trailing: 50))
                    Spacer()
                }
                
                VStack {
                    DismissButton(orientation: .right)
                    Spacer()
                }
            }.onAppear {
                self.evaluator?.viewDidAppear()
                self.navBarHidden = true
            }
                
            // MARK: Hide Navigation Bar
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                self.navBarHidden = true
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(self.navBarHidden)
        }
    }
}
