//
//  DemoControlPanelView.swift
//  Poet
//
//  Created by Steve Cotner on 6/6/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct DemoControlPanelView: View {
    let controls: [DemoControl]
    
    init(_ controls: [DemoControl]) {
        self.controls = controls
    }
    
    var body: some View {
        VStack(spacing: 7) {
            if !controls.isEmpty {
                HStack {
                    Spacer().frame(width: 50)
                    
                    Text("Settings")
                        .font(Font.headline)
                        
                        .foregroundColor(Color.primary.opacity(0.95))
                    Spacer()
                }
            }
            
            Spacer().frame(height: 7)
            
            ForEach(controls, id: \.id) { control in
                VStack {
                    VStack(spacing: 0) {
                        HStack {
                            Spacer().frame(width: 50)
                            Text(control.title)
                                .font(Font.caption.bold())
                                .foregroundColor(Color.primary.opacity(0.9))
                            Spacer()
                        }
                        
                        if control.instructions != nil {
                            Spacer().frame(height: 6)
                            HStack {
                                Spacer().frame(width: 50)
                                Text(control.instructions!)
                                    .font(Font.caption)
                                    .foregroundColor(Color.primary.opacity(0.43))
                                Spacer().frame(width: 50)
                                Spacer()
                            }
                        }
                    }
                    
                    Spacer().frame(height: 10)
                    control.viewMaker()
                    Spacer().frame(height: 16)
                }
            }
        }
    }
}
