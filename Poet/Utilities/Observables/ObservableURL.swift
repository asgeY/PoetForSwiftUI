//
//  ObservableURL.swift
//  Poet
//
//  Created by Steve Cotner on 5/22/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine
import Foundation

class ObservableURL: ObservableObject {
    @Published var url: URL?
    
    init(_ url: URL? = nil) {
        self.url = url
    }
}
