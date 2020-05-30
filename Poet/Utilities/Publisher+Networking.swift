//
//  NetworkPublishing.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/30/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine
import Foundation

extension Publisher where Self == AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure> {
    
    func validateResponseAndDecode<Item: Decodable>(type: Item.Type) -> AnyPublisher<Item, NetworkingError> {
        self.validateNetworkResponse()
        .eraseToAnyPublisher()
        .decodeData(type: type)
    }
    
    func validateNetworkResponse() -> Publishers.TryMap<Self, Data> {
        
        return self.tryMap { (data, response) -> Data in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkingError.invalidServerResponse(response: response)
            }
            switch httpResponse.statusCode {
            case 200:
                return data
            case 401:
                throw NetworkingError.unauthorized(response: response)
            case 404:
                throw NetworkingError.notFound(response: response)
            default:
                throw NetworkingError.unrecognizedStatusCode(response: response)
            }
        }
    }
}

extension Publisher where Self == AnyPublisher<Data, Error> {
    func decodeData<Item: Decodable>(type: Item.Type) -> AnyPublisher<Item, NetworkingError> {
        return self.decode(type: type, decoder: JSONDecoder())
            .mapError({ error in
                if let error = error as? NetworkingError {
                    return error
                }
                return NetworkingError.decodingFailed(error: error)
            })
            .eraseToAnyPublisher()
    }
}
