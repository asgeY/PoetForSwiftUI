//
//  HelloData-Translator.swift
//  Poet
//
//  Created by Stephen E. Cotner on 6/2/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine
import SwiftUI

extension HelloData {

    class Translator {
        
        typealias Evaluator = HelloData.Evaluator
        typealias Action = Evaluator.Action
        
        // Observable Display State
        var shouldShowLoadButton = ObservableBool()
        var shouldShowMusicResults = ObservableBool()
        var musicType = ObservableString()
        var musicResults = ObservableArray<MusicResult>([])
        
        // Passable
        var alert = PassableAlert()
        var busy = PassableBool()
        
        // Passthrough Behavior
        private var stepSink: AnyCancellable?
        
        init(_ step: PassableStep<Evaluator.Step>) {
            stepSink = step.subject.sink { [weak self] value in
                self?.translate(step: value)
            }
        }
    }
}

extension HelloData.Translator {
    func translate(step: Evaluator.Step) {
        switch step {
            
        case .initial:
            break
            
        case .preLoading:
            translatePreLoadingStep()
            
        case .listingMusic(let configuration):
            translateListingMusicStep(configuration)
        }
    }
    
    func translatePreLoadingStep() {
        self.shouldShowLoadButton.bool = true
        self.shouldShowMusicResults.bool = false
        
    }
    
    func translateListingMusicStep(_ configuration: Evaluator.ListingMusicStepConfiguration) {
        musicResults.array = configuration.musicResults
        musicType.string = configuration.musicType.displayName
        shouldShowLoadButton.bool = false
        shouldShowMusicResults.bool = true
    }
}
