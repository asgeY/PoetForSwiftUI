//
//  HelloWorld-Translator.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/25/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine
import SwiftUI

extension HelloWorld {

    class Translator {
        
        typealias Evaluator = HelloWorld.Evaluator
        typealias Action = Evaluator.Action
        
        // Observable Display State
        var helloCount = ObservableString()
        var buttonAction = Observable<NamedEnabledEvaluatorAction<Action>?>(nil)
        var bubbleText = ObservableString()
        var shouldShowBubble = ObservableBool()
        
        // Passthrough Behavior
        private var stateSink: AnyCancellable?
        
        init(_ state: PassableState<Evaluator.State>) {
            stateSink = state.subject.sink { [weak self] value in
                self?.translate(state: value)
            }
        }
    }
}

extension HelloWorld.Translator {
    func translate(state: Evaluator.State) {
        switch state {
            
        case .initial:
            break
            
        case .sayStuff(let state):
            translateSayStuff(state)
        }
    }
    
    func translateSayStuff(_ state: Evaluator.SayStuffState) {
        // update the hello count
        helloCount.string = "Hello count: \(state.helloCount)"
        
        // hide the button
        buttonAction.value = nil
        
        // show the button after 0.8 seconds
        afterWait(800) {
            self.buttonAction.value = NamedEnabledEvaluatorAction(
                name: state.buttonAction.name,
                enabled: true,
                action: state.buttonAction
            )
        }
        
        // show or hide the bubble
        if let bubbleText = state.bubbleText {
            self.bubbleText.string = bubbleText
        }
        withAnimation(.spring(response: 0.55, dampingFraction: 0.65, blendDuration: 0)) {
            shouldShowBubble.bool = state.bubbleText != nil
        }
    }
}
