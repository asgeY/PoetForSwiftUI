//
//  NetworkingError.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/30/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation
import Combine

enum NetworkingError: Error {
    case invalidServerResponse(response: URLResponse)
    case unauthorized(response: URLResponse)
    case unrecognizedStatusCode(response: URLResponse)
    case decodingFailed(error: Error)
    case notFound(response: URLResponse)
    
    var shortName: String {
        switch self {
        
        case .invalidServerResponse:
            return "Invalid Server Response"
        
        case .unauthorized:
            return "Unauthorized"
        
        case .unrecognizedStatusCode(let response):
            if let response = response as? HTTPURLResponse {
                return "Unrecognized Status Code: \(response.statusCode)"
            } else {
                return "Unrecognized Status Code"
            }
            
        case .decodingFailed:
            return "Decoding Failure"
            
        case .notFound:
            return "404 Not Found"
        }
    }
}
