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
        private var stateSink: AnyCancellable?
        
        init(_ state: PassableState<Evaluator.State>) {
            stateSink = state.subject.sink { [weak self] value in
                self?.translate(state: value)
            }
        }
    }
}

extension HelloData.Translator {
    func translate(state: Evaluator.State) {
        switch state {
            
        case .initial:
            break
            
        case .preLoading:
            translatePreLoading()
            
        case .listingMusic(let state):
            translateListingMusic(state)
        }
    }
    
    func translatePreLoading() {
        self.shouldShowLoadButton.bool = true
        self.shouldShowMusicResults.bool = false
        
    }
    
    func translateListingMusic(_ state: Evaluator.ListingMusicState) {
        musicResults.array = state.musicResults
        musicType.string = state.musicType.displayName
        shouldShowLoadButton.bool = false
        shouldShowMusicResults.bool = true
    }
}
