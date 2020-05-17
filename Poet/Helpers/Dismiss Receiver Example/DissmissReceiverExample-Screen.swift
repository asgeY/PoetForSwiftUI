//
//  DissmissReceiver-Screen.swift
//  Poet
//
//  Created by Stephen E Cotner on 5/1/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct DismissReceiverExample {}

extension DismissReceiverExample {
    
    struct Screen: View {
        let _evaluator: Evaluator
        weak var evaluator: Evaluator?
        let translator: Translator
        
        init() {
            _evaluator = Evaluator()
            evaluator = _evaluator
            translator = _evaluator.translator
        }
        
        var body: some View {
            
            VStack {
                Spacer().frame(height:12)
                
                // MARK: Screen Title
                
                Text("Dismiss Receiver")
                    .font(Font.subheadline.monospacedDigit().bold())
                    .multilineTextAlignment(.center)
                    .layoutPriority(10)
                
                Spacer().frame(height:32)
                
                VStack(alignment: .leading) {
                    
                    // MARK: Countdown Text
                
                    ObservingTextView(translator.countdown)
                        .font(Font.system(size: 20, weight: .bold).monospacedDigit())
                        .padding(.bottom, 20)
                    
                    Text("It makes use of a DismissReceiver, a view that lets an Evaluator/Translator imperatively dismiss the current screen.")
                        .font(Font.headline)
                }
                
                // MARK: DISMISS RECEIVER
                
                DismissReceiver(translator: translator.dismissTranslator)
                
                Spacer()
            }
            .padding(EdgeInsets(top: 0, leading: 36, bottom: 0, trailing: 36))
            .onAppear() {
                self.evaluator?.viewDidAppear()
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
        }
    }
}

struct DismissReceiver_Screen_Previews: PreviewProvider {
    static var previews: some View {
        DismissReceiverExample.Screen()
    }
}
