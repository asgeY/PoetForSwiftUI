//
//  Login-MockPerformer.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/29/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine
@testable import Poet
import XCTest

class LoginMockPerformer: LoginPerforming {
    let shouldSucceed: Bool
    
    init(shouldSucceed: Bool) {
        self.shouldSucceed = shouldSucceed
    }
    
    func login(username: String, password: String) -> AnyPublisher<AuthenticationResult, NetworkingError>? {
        if shouldSucceed {
            return Result.Publisher(AuthenticationResult(authenticated: true)).eraseToAnyPublisher()
        } else {
            return Result.Publisher(NetworkingError.unauthorized(response: URLResponse())).eraseToAnyPublisher()
        }
    }
}
