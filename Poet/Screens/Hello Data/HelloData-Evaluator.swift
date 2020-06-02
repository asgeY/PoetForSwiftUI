//
//  HelloData-Evaluator.swift
//  Poet
//
//  Created by Stephen E. Cotner on 6/2/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

extension HelloData {
    class Evaluator {
        
        // Translator
        lazy var translator: Translator = Translator(current)
        var performer: MusicPerforming = Performer()
        
        // Current Step
        var current = PassableStep(Step.initial)
        
        // Sink
        var loginSink: Behavior?
        
        enum Element: EvaluatorElement {
            case usernameTextField
            case passwordTextField
        }
    }
}

// MARK: Steps and Step Configurations
extension HelloData.Evaluator {
    enum Step: EvaluatorStep {
        case initial
        case preLoading
        case listingMusic(ListingMusicStepConfiguration)
    }
    
    struct ListingMusicStepConfiguration {
        var musicResults: [MusicResult]
    }
}

// MARK: View Cycle
extension HelloData.Evaluator: ViewCycleEvaluating {
    func viewDidAppear() {
        showPreLoadingStep()
    }
}

// MARK: Advancing Between Steps
extension HelloData.Evaluator {
    
    func showPreLoadingStep() {
        current.step = .preLoading
    }
    
    // MARK: Login Step
    
    func showListingMusicStep(_ musicResults: [MusicResult]) {
        let configuration = ListingMusicStepConfiguration(
            musicResults: musicResults
        )
        current.step = .listingMusic(configuration)
    }
}

// MARK: Actions
extension HelloData.Evaluator: ActionEvaluating {
    enum Action: EvaluatorAction {
        case loadMusic
    }
    
    func evaluate(_ action: EvaluatorAction?) {
        guard let action = action as? Action else { return }
        
        switch action {
            
        case .loadMusic:
            loadMusic()

        }
    }
    
    private func loadMusic() {
        guard case .preLoading = current.step else { return }
        
        self.translator.busy.isTrue()
        
        loginSink = performer.loadMusic()?.sink(receiveCompletion: { (completion) in
                
            switch completion {
                
            case .failure(let error):
                self.showFailureAlert(with: error)
                
            case .finished:
                break
            }
            
            self.translator.busy.isFalse()
            self.loginSink?.cancel()
            
        }, receiveValue: { (musicFeed) in
            debugPrint("musicFeed:")
            debugPrint(musicFeed)
            self.showListingMusicStep(musicFeed.feed.results)
        })
    }
}

// MARK: Handling Login Success and Failure

extension HelloData.Evaluator {
    
    private func showLoginSucceededAlert(with authenticationResult: AuthenticationResult) {
        translator.alert.withConfiguration(
            title: "Login Succeeded!",
            message:
            """
            Authenticated: \(authenticationResult.authenticated)
            """
        )
    }
    
    private func showFailureAlert(with networkingError: NetworkingError) {
        translator.alert.withConfiguration(
            title: "Loading Music Failed",
            message: networkingError.shortName
        )
    }
}
