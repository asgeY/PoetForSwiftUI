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
        
        let _evaluator: Evaluator
        weak var evaluator: Evaluator?
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
            _evaluator = Evaluator()
            evaluator = _evaluator
            translator = _evaluator.translator
        }
        
        @State var touchingDownOnBox = false
        @State var navBarHidden: Bool = true
        @State var showingAbout = false
        @State var showingTableOfContents = false
        @State var showingSupplement = false
        @State var showingHelloWorld = false
        
        
        var body: some View {
            return ZStack {
                  
                VStack {
                    Spacer()
                    ZStack(alignment: .center) {
                        VStack {
                                
                            // MARK: Main Title
                            
                            Hideable(isShowing: self.translator.shouldShowMainTitle, transition: .opacity) // <-- observed
                            {
                                HStack {
                                    Spacer()
                                    MainTitleView(text: self.translator.mainTitle)
                                    Spacer()
                                }
                                Spacer()
                            }
                        }
                        
                        VStack {
                                
                            // MARK: Chapter Title
                            
                            Hideable(isShowing: self.translator.shouldShowChapterTitle, transition: .opacity) // <-- observed
                            {
                                HStack {
                                    Spacer()
                                    ChapterTitleView(text: self.translator.chapterTitle, number: self.translator.chapterNumber, shouldShowNumber: self.translator.shouldShowChapterNumber, isFocused: self.translator.shouldFocusOnChapterTitle, boxSize: Layout.boxSize)
                                    Spacer()
                                }
                                Spacer()
                            }
                        }
                        
                        // MARK: Page Body
                                
                        Hideable(isShowing: self.translator.shouldShowBody, transition: .opacity) // <-- observed
                        {
                            ZStack(alignment: .topLeading) {
                                VStack {
                                    
                                    TutorialBodyView(bodyElements: self.translator.body, isTouching: self.$touchingDownOnBox)
                                    Spacer()
                                }
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    self.touchingDownOnBox ?
                                        LinearGradient(gradient: Gradient(colors: [Color.primary.opacity(0.005), Color.primary.opacity(0.01)]), startPoint: .top, endPoint: .bottom) :
                                        LinearGradient(gradient: Gradient(colors: [Color.primary.opacity(0.0025), Color.primary.opacity(0.004)]), startPoint: .top, endPoint: .bottom)
                                )
                            )
                                .shadow(color: Color.black.opacity(0.03), radius: 40, x: 0, y: 2)
                            .frame(
                                width: Layout.boxSize,
                                height: Layout.boxSize)
                                
                                .fixedSize(horizontal: true, vertical: true)
                                .onTouchDownGesture {
                                    debugPrint("touch")
                                    withAnimation(.linear(duration: 0.15)) {
                                        self.touchingDownOnBox = true
                                    }
                            }
                            .onTouchUpGesture(width: Layout.boxSize, height: Layout.boxSize, cancelCallback: {
                                withAnimation(.linear(duration: 0.15)) {
                                    self.touchingDownOnBox = false
                                }
                            }) {
                                debugPrint("touch up")
                                withAnimation(.linear(duration: 0.15)) {
                                    self.touchingDownOnBox = false
                                }
                                self.evaluator?.evaluate(Action.pageForward)
                            }
                        }
                        
                        ///////
                        
                    }
                    .frame(height: Layout.boxSize)
                    
                    Spacer()
                }
                
                // MARK: Tap me
                
                HStack {
                    Spacer()
                    Hideable(isShowing: self.translator.shouldShowTapMe, transition: .asymmetric(insertion: AnyTransition.move(edge: .bottom).combined(with: .opacity), removal: .opacity))
                    {
                        VStack {
                            Image(systemName: "arrow.up")
                            Text("Tap me")
                        }
                        .font(Font.system(size: 16, weight: .regular).monospacedDigit())
                        .opacity(0.9)
                        .padding(.top, 10)
                    }
                    Spacer()
                }
                .offset(x: 0, y: Layout.boxSize / 2.0 + 48)
                
                // MARK: Button
                
                VStack {
                    Spacer()
                    Hideable(isShowing: self.translator.shouldShowButton, transition: AnyTransition.asymmetric(insertion: AnyTransition.move(edge: .bottom).combined(with: .opacity), removal: AnyTransition.opacity))
                    {
                        ObservingButton(
                            action: self.translator.buttonAction,
                            evaluator: self.evaluator,
                            label: {
                                ObservingTextView(self.translator.buttonName)
                                    .font(Font.headline)
                                    .foregroundColor(Color.primary)
                                    .padding(EdgeInsets(top: 12, leading: 22, bottom: 12, trailing: 22))
                                    .background(Capsule().fill(Color.primary.opacity(0.045)))
                        })
                    }.offset(x: 0, y: Layout.boxSize / 2.0 + 48)
                    Spacer()
                }
                
                // MARK: Page Count and Arrows
                
                VStack {
                    Spacer()
                    Hideable(isShowing: self.translator.shouldShowPageCount, transition: .opacity) {
                        
                        ZStack(alignment: .topLeading) {
                            HStack {
                                Hideable(isShowing: self.translator.shouldShowLeftAndRightButtons, transition: .opacity) {
                                    Button(action: { self.evaluator?.evaluate(Action.pageBackward) }) {
                                        Image(systemName: "chevron.compact.left")
                                            .resizable()
                                            .frame(width: 7, height: 16, alignment: .center)
                                            .padding(EdgeInsets(top: 32, leading: 18, bottom: 32, trailing: 0))
                                            .font(Font.system(size: 16, weight: .thin))
                                            .opacity(0.22)
                                    }
                                    .layoutPriority(0)
                                    .zIndex(4)
                                }
                                .layoutPriority(0)
                                Spacer().frame(width: 24)
                                    .layoutPriority(0)
                                ObservingTextView(self.translator.pageXofX) // <-- observed
                                    .font(Font.system(size: 16, weight: .regular).monospacedDigit())
                                    .fixedSize(horizontal: true, vertical: false)
                                    .layoutPriority(2)
                                Spacer().frame(width: 24)
                                    .layoutPriority(0)
                                Hideable(isShowing: self.translator.shouldShowLeftAndRightButtons, transition: .opacity) {
                                    Button(action: { self.evaluator?.evaluate(Action.pageForward) }) {
                                        Image(systemName: "chevron.compact.right")
                                            .resizable()
                                            .frame(width: 7, height: 16, alignment: .center)
                                            .padding(EdgeInsets(top: 32, leading: 0, bottom: 32, trailing: 18))
                                            .font(Font.system(size: 16, weight: .thin))
                                            .opacity(0.22)
                                    }
                                    .layoutPriority(0)
                                    .zIndex(4)
                                }
                                .layoutPriority(0)
                            }
                        }
                        .fixedSize(horizontal: true, vertical: true)
                        .frame(width: 100, height: 60)
                        .foregroundColor(Color.primary)
                    }.zIndex(4)
                    .padding(.bottom, 6)
                }
                
                // MARK: Table of Contents Button
                
                VStack {
                    
                    HStack {
                        Hideable(isShowing: self.translator.shouldShowTableOfContentsButton, transition: .opacity) {
                            
                            Button(action: {
                                self.showingTableOfContents.toggle()
                            }) {
                                Image(systemName: "list.bullet")
                            }.sheet(isPresented: self.$showingTableOfContents) {
                                TableOfContentsView(selectableChapterTitles: self.translator.selectableChapterTitles, evaluator: self.evaluator)
                            }
                            .zIndex(5)
                            .foregroundColor(.primary)
                            .font(Font.system(size: 20, weight: .semibold))
                            
                        }
                        .layoutPriority(2)
                        .frame(width: 40, height: 40)
                        
                        Spacer()
                        .layoutPriority(2)
                    }
                    Spacer()
                }.padding(EdgeInsets(top: 14, leading: (Device.current == .small ? 16 : 20), bottom: 16, trailing: 24))
                
                // MARK: File Buttons
                
                VStack(alignment: .trailing) {
                    HStack {
                        Spacer()
                        FileOfInterestButton(
                            title: self.translator.fileOfInterestName,
                            isShowing: self.translator.shouldShowFileOfInterestButton,
                            transition: AnyTransition.opacity.combined(with: AnyTransition.offset(x: 20, y: 0)),
                            evaluator: evaluator,
                            action: Action.showFileOfInterest)
                        
                        Hideable(isShowing: self.translator.shouldShowFileOfInterestButton, transition: .opacity) {
                            Divider()
                                .padding(.leading, 4)
                                .padding(.trailing, 4)
                        }
                        
                        FileTrayButton(
                            isShowing: self.translator.shouldShowFilesButton,
                            transition: .opacity,
                            evaluator: evaluator,
                            action: Action.showChapterFiles)
                    }
                    .frame(height: 40)
                    Spacer()
                }
                .padding(.top, 14)
                
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
                self.evaluator?.viewDidAppear()
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
