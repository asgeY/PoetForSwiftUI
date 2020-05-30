//
//  Login-Performer.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/29/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation
import Combine

/*
 Postman offers some open APIs for testing:
 https://docs.postman-echo.com/?version=latest
 */

struct AuthenticationResult: Decodable {
    let authenticated: Bool
}

protocol LoginPerforming {
    func login(username: String, password: String) -> AnyPublisher<AuthenticationResult, NetworkingError>?
}

extension Login {
    class Performer: LoginPerforming {
        var loginSink: Sink?
        
        func login(username: String, password: String) -> AnyPublisher<AuthenticationResult, NetworkingError>? {
            
            if let url = URL(string: "https://postman-echo.com/basic-auth") {
                
                /*
                 This call expects a user name "postman" and a password "password"
                 It expects them formatted as a header: "Authorization: Basic cG9zdG1hbjpwYXNzd29yZA=="
                 The last bit of text in the header is "postman:password" encoded to base64
                 */
                
                let preEncodedCredential = (username+":"+password)
                let encodedCredential = Data(preEncodedCredential.utf8).base64EncodedString()

                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.timeoutInterval = 20
                request.setValue("Basic \(encodedCredential)", forHTTPHeaderField: "Authorization")
                
                let publisher = URLSession.shared.dataTaskPublisher(for: request)
                return publisher
                    .delay(for: .seconds(1), scheduler: DispatchQueue.main)
                    .receive(on: DispatchQueue.main)
                    .retry(2)
                    .eraseToAnyPublisher()
                    .validateResponseAndDecode(type: AuthenticationResult.self)
            }
            
            return nil
        }

    }
}
