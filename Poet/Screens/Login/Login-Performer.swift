//
//  Login-Performer.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/29/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation
import Combine
//import Network

/*
 Postman offers some open APIs for testing:
 https://docs.postman-echo.com/?version=latest
 */

extension String {

    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }

}

struct AuthenticationResult: Decodable {
    let authenticated: Bool
}

struct AuthenticationError: Error {
    let message = "Authentication failed"
    let error: Error
}

protocol LoginPerforming {
    func login(username: String, password: String) -> AnyPublisher<AuthenticationResult, AuthenticationError>?
}

extension Login {
    class Performer: LoginPerforming {
        var loginSink: Sink?
        
        func login(username: String, password: String) -> AnyPublisher<AuthenticationResult, AuthenticationError>? {
            
            let encodedBase64String = (username+":"+password).toBase64()
            
            if let url = URL(string: "https://postman-echo.com/basic-auth") {
                
                /*
                 This call expects a user name "postman" and a password "password"
                 It expects them formatted as a header: "Authorization: Basic cG9zdG1hbjpwYXNzd29yZA=="
                 The last bit of text in the header is "postman:password" encoded to base64
                 */
                
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.setValue("Basic \(encodedBase64String)", forHTTPHeaderField: "Authorization")
                
                let publisher = URLSession.shared.dataTaskPublisher(for: request)
                return publisher
                    .delay(for: .seconds(1), scheduler: DispatchQueue.main)
                    .receive(on: DispatchQueue.main)
                    .map { $0.data }
                    .decode(type: AuthenticationResult.self, decoder: JSONDecoder())
                    .mapError({ error in
                        return AuthenticationError(error: error)
                    })
                    .eraseToAnyPublisher()
            }
            
            return nil
        }

    }
}
