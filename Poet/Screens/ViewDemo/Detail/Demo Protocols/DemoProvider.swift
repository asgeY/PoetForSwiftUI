//
//  DemoProvider.swift
//  Poet
//
//  Created by Steve Cotner on 6/6/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

protocol DemoProvider {
    // to be determined upon use
    var contentView: AnyView { get }
    var controls: [DemoControl] { get }
    
    // provided by default implementation
    var demoContainerView: AnyView { get }
}

extension DemoProvider {
    var demoContainerView: AnyView {
        AnyView(
            VStack {
                DemoContainerView(
                    content: {
                        self.contentView
                    },
                    panel: {
                        DemoControlPanelView(self.controls)
                    }
                )
            }
        )
    }
}

struct NamedDemoProvider {
    let title: String
    var demoProvider: DemoProvider
    let id: UUID = UUID()
}
