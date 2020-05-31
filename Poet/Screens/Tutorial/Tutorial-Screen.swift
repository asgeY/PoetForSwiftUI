//
//  Tutorial-Screen.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/2/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct Tutorial {}

extension Tutorial {
    struct Screen: View {
        
        typealias Action = Evaluator.Action
        
        let evaluator: Evaluator
        let translator: Translator
        
        enum Layout {
            static let boxSize: CGFloat = {
                switch Device.current {
                case .small:
                    return 358
                case .medium:
                    return 370
                case .big:
                    return 480
                }
            }()
        }
        
        init() {
            evaluator = Evaluator()
            translator = evaluator.translator
        }
        
        @State var touchingDownOnBox = false
        @State var navBarHidden: Bool = true
        @State var showingAbout = false
        @State var showingTableOfContents = false
        @State var showingSupplement = false
        @State var showingHelloWorld = false
        
        @State var height: CGFloat = 0
        @State var width: CGFloat = 0
        let topSpace: CGFloat = 90
        
        var body: some View {
            return ZStack {
                
                GeometryReader() { geometry in
                    return Rectangle()
                        .fill(Color.clear)
                        .frame(height: geometry.size.height - 52)
                        .onAppear() {
                            self.height = geometry.size.height - 52
                            self.width = geometry.size.width
                    }
                }.zIndex(0)
                
                VStack(spacing: 0) {
                    Spacer().frame(height: 52)
                    ScrollView {
                        ZStack {
                            
                            Rectangle()
                                .fill(Color.clear)
                                .frame(height: self.height)
                            
                            // MARK: Main Title
                            
                            Hideable(isShowing: self.translator.shouldShowMainTitle, transition: .opacity) // <-- observed
                            {
                                MainTitleView(
                                    text: self.translator.mainTitle,
                                    height: self.height - 30)
                            }
                            
                            // MARK: Chapter Title
                            
                            Hideable(isShowing: self.translator.shouldShowChapterTitle, transition: .opacity) {
                                ChapterTitleView(
                                    text: self.translator.chapterTitle,
                                    number: self.translator.chapterNumber,
                                    shouldShowNumber: self.translator.shouldShowChapterNumber,
                                    isFocused: self.translator.shouldFocusOnChapterTitle,
                                    height: self.height - 30,
                                    topSpace: self.topSpace)
                            }
                            
                            // MARK: Page Body
                            
                            Hideable(isShowing: self.translator.shouldShowBody, removesContent: false, transition: .opacity) {
                                VStack(spacing: 0) {
                                    Spacer().frame(height: 92 + self.topSpace)
                                    
                                    // Body
                                    HStack(spacing: 0) {
                                        Spacer().frame(width:42)
                                        TutorialBodyView(
                                            bodyElements: self.translator.body,
                                            evaluator: self.evaluator)
                                        Spacer().frame(width:42)
                                    }
                                    
                                    Spacer().frame(height: 50)
                                    
                                    // Next Chapter
                                    
                                    Hideable(isShowing: self.translator.shouldShowNextChapterButton) {
                                        Button(action: {
                                            self.evaluator.evaluate(Action.nextChapter)
                                        }) {
                                            HStack(spacing: 0) {
                                                Spacer().frame(width:42)
                                                VStack(spacing: 0) {
                                                    Spacer().frame(height: 26)
                                                    
                                                    HStack {
                                                        Spacer().frame(width:26)
                                                        VStack(alignment: .leading) {
                                                            Text("Next Chapter:")
                                                                .font(Font.subheadline.smallCaps())
                                                                .multilineTextAlignment(.leading)
                                                                .foregroundColor(Color.primary.opacity(0.85))
                                                            Spacer().frame(height:8)
                                                            ObservingTextView(self.translator.nextChapterTitle)
                                                                .font(FontSystem.largeTitle)
                                                                .multilineTextAlignment(.leading)
                                                                .foregroundColor(Color.primary.opacity(0.95))
                                                        }
                                                        Spacer().frame(width:20)
                                                        Spacer()
                                                        Image(systemName: "chevron.right")
                                                            .foregroundColor(Color.primary.opacity(0.3))
                                                        Spacer().frame(width:26)
                                                    }
                                                    
                                                    Spacer().frame(height: 32)
                                                }
                                                .background(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .fill(Color.primary.opacity(0.03))
                                                )
                                                Spacer().frame(width:42)
                                            }
                                        }
                                    }
                                    
                                    Spacer().frame(height: 20)
                                    Spacer()
                                }
                                .frame(width: self.width)
                            }
                            
                        }
                        Spacer()
                    }
                    .frame(height: self.height)
                    .fixedSize(horizontal: false, vertical: true)
                    .zIndex(0)
                }
                .frame(height: self.height)
                
                // MARK: Table of Contents Button
                
                VStack {
                    HStack {
                        Hideable(isShowing: self.translator.shouldShowBody, transition: .opacity) {
                            
                            Button(action: {
                                self.showingTableOfContents.toggle()
                            }) {
                                Image(systemName: "list.bullet")
                            }.sheet(isPresented: self.$showingTableOfContents) {
                                TableOfContentsView(selectableChapterTitles: self.translator.selectableChapterTitles, evaluator: self.evaluator)
                            }
                            .zIndex(5)
                            .foregroundColor(Color.primary)
                            .font(Font.system(size: 20, weight: .semibold))
                            
                        }
                        .layoutPriority(2)
                        .frame(width: 40, height: 40)
                        
                        Spacer()
                        .layoutPriority(2)
                    }
                    Spacer()
                }.padding(EdgeInsets(top: 6, leading: 30, bottom: 16, trailing: 32))
                
                // MARK: Title
                
                VStack(alignment: .trailing) {
                    Hideable(isShowing: self.translator.shouldShowBody, transition: .opacity) {
                        HStack {
                            Spacer()
                            ObservingTextView(self.translator.chapterTitle)
                                .font(Font.subheadline.smallCaps())
                                .foregroundColor(Color.primary)
                            Spacer()
                        }
                        .frame(height: 40)
                    }
                    Spacer()
                }
                .padding(.top, 6)
                
                // MARK: File Buttons
                
                VStack(alignment: .trailing) {
                    HStack {
                        Spacer()
                        FileTrayButton(
                            isShowing: self.translator.shouldShowFilesButton,
                            transition: .opacity,
                            evaluator: evaluator,
                            action: Action.showChapterFiles)
                        .foregroundColor(Color.primary.opacity(0.22))
                    }
                    .frame(height: 40)
                    Spacer()
                }
                .padding(.top, 6)
                
                Group {
                    Group {
                        // MARK: Files
                        PresenterWithPassedValue(self.translator.showChapterFileMenu) { textFiles in
                            FileMenuView(title: "Files", textFiles: textFiles)
                        }
                        
                        // MARK: File of Interest
                        PresenterWithString(self.translator.showFile) { text in
                            SupplementaryCodeView(code: text)
                        }
                        
                        // MARK: Something Screen
                        Presenter(self.translator.showSomething) {
                            Text("Something")
                        }
                        
                        // MARK: Template Screen
                        Presenter(self.translator.showTemplate) {
                            Template.Screen()
                        }
                        
                        // MARK: Hello World Screen
                        Presenter(self.translator.showHelloWorld) {
                            HelloWorld.Screen()
                        }
                        
                        // MARK: Hello Solar System Screen
                        Presenter(self.translator.showHelloSolarSystem) {
                            HelloSolarSystem.Screen()
                        }
                        
                        // MARK: Retail Demo
                        Presenter(self.translator.showRetailDemo) {
                            Retail.Screen()
                        }
                        
                        // MARK: Login Demo
                        Presenter(self.translator.showLoginDemo) {
                            Login.Screen()
                        }
                    }
                    
                    // MARK: Alert
                    AlertView(translator: translator)
                    
                    // MARK: AlertPresenter
                    AlertPresenter(self.translator.showAlert)
                    
                    // MARK: Character Bezel
                    BezelView(translator: translator)
                }
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.primary.opacity(0.00), Color.primary.opacity(0.01)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            )
            .zIndex(0)
                
            .onAppear {
                self.evaluator.viewDidAppear()
                self.navBarHidden = true
                UITableView.appearance().separatorColor = .clear
            }
            
            // MARK: Hide Navigation Bar
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                self.navBarHidden = true
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(self.navBarHidden)
            
        }
    }
}

extension View {
    func onTouchDownGesture(callback: @escaping () -> Void) -> some View {
        modifier(OnTouchDownGestureModifier(callback: callback))
    }
}

private struct OnTouchDownGestureModifier: ViewModifier {
    @State private var tapped = false
    let callback: () -> Void

    func body(content: Content) -> some View {
        debugPrint("OnTouchDownGestureModifier body")
        return content
            .simultaneousGesture(DragGesture(minimumDistance: 0)
                .onChanged { value in
                    debugPrint("OnTouchDownGestureModifier onChanged")
                    if !self.tapped {
                        self.tapped = true
                        self.callback()
                    }
                }
                .onEnded { _ in
                    debugPrint("OnTouchDownGestureModifier onEnded")
                    self.tapped = false
                })
    }
}

extension View {
    func onTouchUpGesture(width: CGFloat, height: CGFloat, cancelCallback: @escaping () -> Void, callback: @escaping () -> Void) -> some View {
        self.modifier(OnTouchUpGestureModifier(width: width, height: height, cancelCallback: cancelCallback, callback: callback))
    }
}

private struct OnTouchUpGestureModifier: ViewModifier {
    @State private var canceled = false
    let width: CGFloat
    let height: CGFloat
    let cancelCallback: () -> Void
    let callback: () -> Void

    func body(content: Content) -> some View {
        debugPrint("OnTouchUpGestureModifier body")
        return content
            .simultaneousGesture(DragGesture(minimumDistance: 0)
                .onChanged { value in
                    debugPrint("OnTouchUpGestureModifier onChanged")
                    let movementX = value.translation.width
                    let movementY = value.translation.height
                    
                    let distanceLeft = value.startLocation.x
                    let distanceRight = self.width - value.startLocation.x
                    let distanceUp = value.startLocation.y
                    let distanceDown = self.height - value.startLocation.y
                    
                    debugPrint("width: \(self.width)")
                    debugPrint("startLocation.x: \(value.startLocation.x)")
                    debugPrint("startLocation.y: \(value.startLocation.y)")
                    debugPrint("movementx: \(movementX)")
                    debugPrint("movementy: \(movementY)")
                    debugPrint("distanceUp: \(distanceUp)")
                    debugPrint("distanceDown: \(distanceDown)")
                    debugPrint("distanceLeft: \(distanceLeft)")
                    debugPrint("distanceRight: \(distanceRight)")
                    
                    if movementX < -abs(distanceLeft) ||
                        movementX > abs(distanceRight) ||
                        movementY < -abs(distanceUp) ||
                        movementY > abs(distanceDown)
                        {
                            debugPrint("setting canceled to true")
                        self.canceled = true
                        self.cancelCallback()
                    }
                    
                }
                .onEnded { _ in
                    debugPrint("OnTouchUpGestureModifier onEnded")
                    if self.canceled == false {
                        self.callback()
                    }
                    self.canceled = false
                })
    }
}
