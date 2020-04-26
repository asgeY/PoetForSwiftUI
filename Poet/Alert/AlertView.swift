//
//  AlertView.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/24/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine
import SwiftUI

struct AlertView: View {
    @ObservedObject var title: ObservableString
    @ObservedObject var message: ObservableString
    @ObservedObject var isPresented: ObservableBool
    
    var body: some View {
        VStack {
            EmptyView()
        }
        .alert(isPresented: $isPresented.bool) {
            Alert(title: Text(title.string), message: Text(message.string), dismissButton: .default(Text("OK")))
        }
    }
}
