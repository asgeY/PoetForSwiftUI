//
//  ViewDemoDetail.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/2/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct ViewDemoDetail: View {

    let namedDemoProvider: NamedDemoProvider
    
    init(namedDemoProvider: NamedDemoProvider) {
        self.namedDemoProvider = namedDemoProvider
    }
    
    var body: some View {
        ZStack {
            
            VStack(spacing: 0) {
                Text(namedDemoProvider.title)
                    .font(Font.headline)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 22)
                
                Spacer().frame(height: 20)
                
                namedDemoProvider.demoProvider.demoContainerView
                
                Spacer()
            }
            
            VStack {
                DismissButton(orientation: .right)
                Spacer()
            }
        }
    }
}
