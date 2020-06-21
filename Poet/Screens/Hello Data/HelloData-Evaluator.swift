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
        
        // Current State
        var current = PassableState(State.initial)
        
        // Sink
        var musicSink: AnyCancellable?
        
        enum Element: EvaluatorElement {
            case usernameTextField
            case passwordTextField
        }
        
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
    }
}

// MARK: States

extension HelloData.Evaluator {
    enum State: EvaluatorState {
        case initial
        case preLoading
        case listingMusic(ListingMusicState)
    }
    
    struct ListingMusicState {
        var musicResults: [MusicResult]
        var musicType: MusicType
    }
}

// MARK: View Cycle

extension HelloData.Evaluator: ViewCycleEvaluating {
    func viewDidAppear() {
        showPreLoading()
    }
    
    func showPreLoading() {
           current.state = .preLoading
       }
}

// MARK: Actions

extension HelloData.Evaluator: ActionEvaluating {
    
    enum Action: EvaluatorAction {
        case loadMusic(MusicType)
    }
    
    func _evaluate(_ action: Action) {
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
            self.showListingMusic(musicFeed.feed.results, musicType: musicType)
        })
    }
    
    private func showListingMusic(_ musicResults: [MusicResult], musicType: MusicType) {
        let state = ListingMusicState(
            musicResults: musicResults,
            musicType: musicType
        )
        current.state = .listingMusic(state)
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
