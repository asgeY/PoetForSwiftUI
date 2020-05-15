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
            debugPrint("About body")
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
                        HStack(spacing: 20) {
                            // MARK: World Button
                            WorldButton(evaluator: self.evaluator)
                            MoonButton(evaluator: self.evaluator)
                            SunButton(evaluator: self.evaluator)
                        }.foregroundColor(.primary)
                        Spacer().frame(height: 20)
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
    
    struct WorldButton: View {
        weak var evaluator: ButtonEvaluator?
        var body: some View {
            Button(action: { self.evaluator?.buttonTapped(action: Evaluator.ButtonAction.showHelloWorld) }) {
                Image("world01")
                .resizable()
                .frame(width: 30, height: 30)
            }
        }
    }
    
    struct MoonButton: View {
        weak var evaluator: ButtonEvaluator?
        var body: some View {
            Button(action: { self.evaluator?.buttonTapped(action: Evaluator.ButtonAction.showHelloMoon) }) {
                Image("moon-03-waning-crescent")
                .resizable()
                .frame(width: 30, height: 30)
            }
        }
    }
    
    struct SunButton: View {
        weak var evaluator: ButtonEvaluator?
        var body: some View {
            Button(action: { self.evaluator?.buttonTapped(action: Evaluator.ButtonAction.showHelloSun) }) {
                Image("sun")
                .resizable()
                .frame(width: 30, height: 30)
            }
        }
    }
    
    struct TappableImage: View {
        weak var evaluator: ButtonEvaluator?
        @ObservedObject var tapAction: Observable<Evaluator.ButtonAction?>
        @ObservedObject var image: ObservableString
        @ObservedObject var foregroundColor: Observable<Color>
        @ObservedObject var backgroundColor: Observable<Color>
        
        var body: some View {
            return ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.primary.opacity(0.026))
                Circle()
                    .fill(self.backgroundColor.object)
                    .frame(width: 130, height: 130)
                Circle()
                    .fill(self.foregroundColor.object)
                    .frame(width: 130, height: 130)
                    .mask(
                        Image(self.image.string)
                        .resizable()
                    )
            }
            .frame(width: 200, height: 200)
            .onTapGesture {
                self.evaluator?.buttonTapped(action: self.tapAction.object)
            }
        }
    }
}
