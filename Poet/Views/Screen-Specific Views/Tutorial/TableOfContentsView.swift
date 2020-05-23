//
//  TableOfContentsView.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/21/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct TableOfContentsView: View {
    @ObservedObject var selectableChapterTitles: ObservableArray<NumberedNamedEvaluatorAction>
    weak var evaluator: ButtonEvaluating?
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var isShowingAbout = false
    
    var body: some View {
        ZStack {
            VStack {
                DismissButton(orientation: .right)
                    .zIndex(2)
                Spacer()
            }.zIndex(2)
            
            VStack {
                Spacer().frame(height:42)
                HStack {
                    Text("Table of Contents")
                        .multilineTextAlignment(.leading)
                        .font(Font.system(size: 18, weight: .semibold))
                    Spacer()
                }.padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30))
                Spacer().frame(height:16)
                ScrollView {
                    ForEach(self.selectableChapterTitles.array, id: \.id) { item in
                        Button(action: {
                            self.evaluator?.buttonTapped(action: item.action)
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack {
                                Text("\(item.number).   " + item.name)
                                Spacer()
                            }
                            .font(Font.body.monospacedDigit())
                            .multilineTextAlignment(.leading)
                            
                        }
                        .foregroundColor(.primary)
                        .padding(EdgeInsets(top: 13, leading: 30, bottom: 13, trailing: 30))
                    }
                }
                
                Button(action: { self.isShowingAbout.toggle() }) {
                    HStack {
                        Image(systemName: "questionmark.circle")
                            .resizable()
                            .frame(width: 22, height: 22)
                        Text("About")
                        Spacer()
                    }
                    .foregroundColor(Color.primary)
                        .background(Color(UIColor.systemBackground))
                        .padding(EdgeInsets(top: 24, leading: 30, bottom: 26, trailing: 30))
                        .sheet(isPresented: self.$isShowingAbout) {
                            About.Screen()
                        }
                }
                
            }.background(Rectangle().fill(Color(UIColor.systemBackground)))
        }
    }
}
