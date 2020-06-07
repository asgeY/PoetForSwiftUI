//
//  Observer.swift
//  Poet
//
//  Created by Steve Cotner on 6/6/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct Observer<Content, T>: View where Content: View {
    @ObservedObject var observable: Observable<T>
    var content: (T) -> Content
    
    init(observable: Observable<T>, @ViewBuilder content: @escaping (T) -> Content) {
        self.observable = observable
        self.content = content
    }
    
    var body: some View {
        content(observable.value)
    }
}
