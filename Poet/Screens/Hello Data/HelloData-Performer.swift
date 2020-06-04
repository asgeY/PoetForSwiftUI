//
//  HelloData-Performer.swift
//  Poet
//
//  Created by Stephen E. Cotner on 6/2/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation
import Combine

/*
 Postman offers some open APIs for testing:
 https://docs.postman-echo.com/?version=latest
 */

struct MusicFeedWrapper: Decodable {
    let feed: MusicFeed
}
struct MusicFeed: Decodable {
    let results: [MusicResult]
}

enum MusicKind: String, Decodable {
    case album = "album"
    case playlist = "playlist"
}

struct MusicGenre: Decodable {
    let genreId: String
    let name: String
    let url: URL
}

struct MusicResult: Decodable {
    let artistName: String?
    let id: String
    let releaseDate: String?
    let name: String
    let kind: MusicKind?
    let copyright: String?
    let artistId: String?
    let contentAdvisoryRating: String?
    let artistUrl: URL?
    let artworkUrl100: URL
    let genres: [MusicGenre]
    
    /*
    "artistName": "Gunna",
    "id": "1514490028",
    "releaseDate": "2020-05-22",
    "name": "WUNNA",
    "kind": "album",
    "copyright": "℗ 2020 Young Stoner Life Records / 300 Entertainment",
    "artistId": "1236267297",
    "contentAdvisoryRating": "Explicit",
    "artistUrl": "https://music.apple.com/us/artist/gunna/1236267297?app=music",
    "artworkUrl100": "https://is3-ssl.mzstatic.com/image/thumb/Music123/v4/82/db/15/82db15f2-22b2-728a-2a44-ebd7b58b2f9e/810043680837.jpg/200x200bb.png",
    "genres": [
      {
        "genreId": "18",
        "name": "Hip-Hop/Rap",
        "url": "https://itunes.apple.com/us/genre/id18"
      },
      {
        "genreId": "34",
        "name": "Music",
        "url": "https://itunes.apple.com/us/genre/id34"
      }
    ],
    "url": "https://music.apple.com/us/album/wunna/1514490028?app=music"
     */
}

protocol MusicPerforming {
    func loadMusic(_ musicType: HelloData.Evaluator.MusicType) -> AnyPublisher<MusicFeedWrapper, NetworkingError>?
}

extension HelloData {
    class Performer: MusicPerforming {
        var loginSink: Sink?
        
        func loadMusic(_ musicType: HelloData.Evaluator.MusicType) -> AnyPublisher<MusicFeedWrapper, NetworkingError>? {
            switch musicType {
            case .albums:
                if let url = URL(string: "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/10/explicit.json") {
                    return loadMusic(url: url)
                }
            case .hotTracks:
                if let url = URL(string: "https://rss.itunes.apple.com/api/v1/us/apple-music/hot-tracks/all/10/explicit.json") {
                    return loadMusic(url: url)
                }
                
            case .newReleases:
                if let url = URL(string: "https://rss.itunes.apple.com/api/v1/us/apple-music/new-releases/all/10/explicit.json") {
                    return loadMusic(url: url)
                }
            }
            
            return nil
        }
        
        private func loadMusic(url: URL) -> AnyPublisher<MusicFeedWrapper, NetworkingError>? {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.timeoutInterval = 20
            
            let publisher = URLSession.shared.dataTaskPublisher(for: request)
            return publisher
                .delay(for: .seconds(1), scheduler: DispatchQueue.main)
                .receive(on: DispatchQueue.main)
                .retry(2)
                .eraseToAnyPublisher()
                .validateResponseAndDecode(type: MusicFeedWrapper.self)
        }
    }
}
