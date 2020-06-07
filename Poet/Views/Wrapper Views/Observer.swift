//
//  Observer.swift
//  Poet
//
//  Created by Steve Cotner on 6/6/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct Observer<Content, A>: View where Content: View {
    @ObservedObject var observable: Observable<A>
    var content: (A) -> Content
    
    init(observable: Observable<A>, @ViewBuilder content: @escaping (A) -> Content) {
        self.observable = observable
        self.content = content
    }
    
    var body: some View {
        content(observable.value)
    }
}

struct Observer2<Content, A, B>: View where Content: View {
    @ObservedObject var observableA: Observable<A>
    @ObservedObject var observableB: Observable<B>
    var content: (A, B) -> Content
    
    init(observableA: Observable<A>, observableB: Observable<B>, @ViewBuilder content: @escaping (A, B) -> Content) {
        self.observableA = observableA
        self.observableB = observableB
        self.content = content
    }
    
    var body: some View {
        content(observableA.value, observableB.value)
    }
}

struct Observer3<Content, A, B, C>: View where Content: View {
    @ObservedObject var observableA: Observable<A>
    @ObservedObject var observableB: Observable<B>
    @ObservedObject var observableC: Observable<C>
    var content: (A, B, C) -> Content
    
    init(observableA: Observable<A>, observableB: Observable<B>, observableC: Observable<C>, @ViewBuilder content: @escaping (A, B, C) -> Content) {
        self.observableA = observableA
        self.observableB = observableB
        self.observableC = observableC
        self.content = content
    }
    
    var body: some View {
        content(observableA.value, observableB.value, observableC.value)
    }
}
