//
//  HelloData-Evaluator.swift
//  Poet
//
//  Created by Stephen E. Cotner on 6/2/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine
import SwiftUI

extension HelloData {
    class Evaluator {
        
        // Translator
        lazy var translator: Translator = Translator(current)
        var performer: MusicPerforming = HelloData.Performer()
        
        // Current Step
        var current = PassableStep(Step.initial)
        
        // Sink
        var musicSink: AnyCancellable?
        
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
        var musicType: MusicType
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
    
    func showListingMusicStep(_ musicResults: [MusicResult], musicType: MusicType) {
        let configuration = ListingMusicStepConfiguration(
            musicResults: musicResults,
            musicType: musicType
        )
        current.step = .listingMusic(configuration)
    }
}

// MARK: Actions
extension HelloData.Evaluator: ActionEvaluating {
    
    enum MusicType {
        case albums
        case hotTracks
        case newReleases
        
        var displayName: String {
            switch self {
            case .albums:
                return "Top Albums"
            case .hotTracks:
                return "Hot Playlists"
            case .newReleases:
                return "New Releases"
            }
        }
    }
    
    enum Action: EvaluatorAction {
        case loadMusic(MusicType)
    }
    
    func evaluate(_ action: EvaluatorAction?) {
        guard let action = action as? Action else { return }
        
        switch action {
            
        case .loadMusic(let musicType):
            loadMusic(musicType: musicType)
        }
    }
    
    private func loadMusic(musicType: MusicType) {
        
        translator.busy.isTrue()
        
        let publisher: AnyPublisher<MusicFeedWrapper, NetworkingError>? = {
            switch musicType {
            case .albums:
                return performer.loadMusic(.albums)
            case .hotTracks:
                return performer.loadMusic(.hotTracks)
            case .newReleases:
                return performer.loadMusic(.newReleases)
            }
        }()
        
        musicSink = publisher?.sink(receiveCompletion: { (completion) in
                
            switch completion {
                
            case .failure(let error):
                self.showFailureAlert(with: error)
                
            case .finished:
                break
            }
            
            self.translator.busy.isFalse()
            self.musicSink?.cancel()
            
        }, receiveValue: { (musicFeed) in
            debugPrint("musicFeed:")
            debugPrint(musicFeed)
            self.showListingMusicStep(musicFeed.feed.results, musicType: musicType)
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
