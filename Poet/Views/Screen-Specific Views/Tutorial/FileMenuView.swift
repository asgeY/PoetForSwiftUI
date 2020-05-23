//
//  FileMenuView.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/23/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation
import SwiftUI

struct FileMenuView: View {
    let title: String
    let fileTitlesAndBodies: [Tutorial.Evaluator.FileTitleAndBody]
    var showFile = PassableString()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            VStack {
                DismissButton(orientation: .right)
                    .zIndex(2)
                Spacer()
            }.zIndex(2)
            
            VStack(spacing: 0) {
                Spacer().frame(height:24)
                HStack {
                    Text(title)
                        .multilineTextAlignment(.leading)
                        .font(Font.system(size: 18, weight: .semibold))
                    Spacer()
                }.padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30))
                Spacer().frame(height:16)
                Divider()
                ScrollView {
                    Spacer().frame(height:6)
                    ForEach(self.fileTitlesAndBodies, id: \.id) { fileTitleAndBody in
                        Button(action: {
                            self.showFile.withString(fileTitleAndBody.body)
                        }) {
                            VStack(spacing: 0) {
                                HStack {
                                    Image(systemName: "doc.plaintext")
                                    Spacer().frame(width: 14)
                                    Text(fileTitleAndBody.title + ".swift")
                                        .font(Font.system(size: 15, weight: .medium))
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color.primary.opacity(0.3))
                                        .font(.body)
                                }
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.primary)
                                .padding(EdgeInsets(top: 12, leading: 0, bottom: 16, trailing: 30))
                                Divider()
                            }
                            .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 0))
                        }
                        
                    }
                }
            }.background(Rectangle().fill(Color(UIColor.systemBackground)))
            
            PresenterWithString(showFile) { string in
                SupplementaryCodeView(code: string)
            }
        }
    }
}
