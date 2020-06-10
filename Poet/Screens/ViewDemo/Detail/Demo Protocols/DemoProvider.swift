//
//  DemoProvider.swift
//  Poet
//
//  Created by Steve Cotner on 6/6/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

/**
 You must implement the deepCopy() method on your DemoProvider by doing a deep copy of each observable.
 If you do not, the process of saving changes to a demo provider will be broken in the Demo Builder.
 */
protocol DemoProvider: DeepCopying {
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

struct NamedDemoProvider: DeepCopying {
    let title: String
    let demoProvider: DemoProvider
    var id: UUID = UUID()
    
    func deepCopy() -> Self {
        let provider = NamedDemoProvider(
            title: self.title,
            demoProvider: self.demoProvider.deepCopy(),
            id: self.id
        )
        return provider
    }
}
