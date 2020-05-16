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

struct CircularTabBar: View {
    typealias TabButtonAction = EvaluatorActionWithIconAndID
    
    weak var evaluator: ButtonEvaluator?
    @ObservedObject var tabs: ObservableArray<TabButtonAction>
    @ObservedObject var currentTab: Observable<TabButtonAction?>
    let spacing: CGFloat = 30
    
    var body: some View {
        ZStack {
            HStack(spacing: spacing) {
                // MARK: World Button
                ForEach(self.tabs.array, id: \.id) { tab in
                    CircularTabButton(evaluator: self.evaluator, tab: tab)
                }
            }.overlay(
                GeometryReader() { geometry in
                    Capsule()
                        .fill(Color.primary.opacity(0.06))
                        .frame(width: geometry.size.width / CGFloat(self.tabs.array.count), height: 48)
                        .opacity(self.indexOfCurrentTab() != nil ? 1 : 0)
                        .offset(x: {
                            let divided = CGFloat((geometry.size.width + self.spacing) / CGFloat(self.tabs.array.count))
                            return divided * CGFloat(self.indexOfCurrentTab() ?? 0) + (self.spacing / 2.0) - (geometry.size.width / 2.0)
                        }(), y: 0)
                        .allowsHitTesting(false)
                }
            )
        }
    }
    
    func indexOfCurrentTab() -> Int? {
        if let currentTabObject = currentTab.object {
            return self.tabs.array.firstIndex { tab in
                tab.id == currentTabObject.id
            }
        }
        return nil
    }
    
    struct CircularTabButton: View {
        weak var evaluator: ButtonEvaluator?
        let tab: TabButtonAction
        var body: some View {
            Button(action: { self.evaluator?.buttonTapped(action: self.tab) }) {
                Image(self.tab.icon)
                .resizable()
                .frame(width: 30, height: 30)
            }
        }
    }
}


