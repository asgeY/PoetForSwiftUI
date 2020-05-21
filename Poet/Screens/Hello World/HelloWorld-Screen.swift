//
//  HelloWorld-Screen.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/15/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI
import Combine

struct HelloWorld {}

extension HelloWorld {
    struct Screen: View {
        
        typealias ButtonAction = Evaluator.ButtonAction
        
        private let _evaluator: Evaluator
        weak var evaluator: Evaluator?
        let translator: Translator
        
        init() {
            _evaluator = Evaluator()
            evaluator = _evaluator
            translator = _evaluator.translator
        }
        
        @State var navBarHidden: Bool = true
        
        var body: some View {
            return GeometryReader() { geometry in
                ZStack {
                    
                    // MARK: Dismiss Button
                    
                    VStack {
                        DismissButton()
                            .zIndex(2)
                        Spacer()
                    }.zIndex(2)
                    
                    // MARK: Title and Image
                    
                    VStack {
                        Spacer()
                        
                        // MARK: Title
                        
                        ObservingTextView(self.translator.title)
                            .font(Font.headline)
                        
                        Spacer().frame(height:20)
                        
                        // MARK: Tappable Image
                        
                        TappableImage(
                            evaluator: self.evaluator,
                            tapAction: self.translator.tapAction,
                            image: self.translator.imageName,
                            foregroundColor: self.translator.foregroundColor,
                            backgroundColor: self.translator.backgroundColor
                        )
                        
                        ZStack {
                            Hideable(isShowing: self.translator.shouldShowTapMe) {
                                VStack {
                                    Image(systemName: "arrow.up")
                                    Text("Tap me")
                                }
                                .font(Font.caption)
                                .opacity(0.9)
                                .padding(.top, 10)
                            }
                        }.frame(height: 50)

                        Spacer()
                    }.zIndex(1)
                    
                    // MARK: Our Different Image Choices
                    
                    VStack {
                        Spacer()
                        CircularTabBar(evaluator: self.evaluator, tabs: self.translator.tabs, currentTab: self.translator.currentTab)
                            .foregroundColor(.primary)
                        Spacer().frame(height: 30)
                    }.zIndex(2)
                }
                
                // MARK: ViewCycle
                .onAppear {
                    self.navBarHidden = true
                    self.evaluator?.viewDidAppear()
                    UITableView.appearance().separatorColor = .clear
                }
                    
                // MARK: Hide Navigation Bar
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                    self.navBarHidden = true
                }
                .navigationBarTitle("Pager", displayMode: .inline)
                    .navigationBarHidden(self.navBarHidden)
            }
        }
    }
}
