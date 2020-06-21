//
//  DemoBuilder-Translator.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/2/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

extension DemoBuilder {

    class Translator {
        
        typealias Evaluator = DemoBuilder.Evaluator
        
        // Observable Display State
        var arrangedDemoProviders = ObservableArray<NamedDemoProvider>([])
        
        // Passable
        var editDemoView = Passable<DemoViewEditingConfiguration>()
        var promptToAddDemoView = Passable<[NamedDemoProvider]>()
        
        // State Sink
        private var stateSink: AnyCancellable?
        
        init(_ state: PassableState<Evaluator.State>) {
            stateSink = state.subject.sink { [weak self] value in
                self?.translate(state: value)
            }
        }
        
        deinit {
            debugPrint("demobuilder deinit translator")
        }
    }
}

extension DemoBuilder.Translator {
    func translate(state: Evaluator.State) {
        switch state {
            
        case .initial:
            break // no initial setup needed
            
        case .build(let state):
            translateBuildState(state)
        }
    }
    
    func translateBuildState(_ state: Evaluator.BuildState) {
        // Set observable display state
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7, blendDuration: 0)) {
            self.arrangedDemoProviders.array = state.arrangedDemoProviders
        }
    }
}
