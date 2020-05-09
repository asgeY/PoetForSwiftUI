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
        
        let _evaluator: Evaluator
        weak var evaluator: Evaluator?
        let translator: Translator
        
        enum Layout {
            static let boxSize: CGFloat = 300
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
        
        var body: some View {
            debugPrint("Tutorial body")
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
                                    MainTitle(text: self.translator.mainTitle)
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
                                    ChapterTitle(text: self.translator.chapterTitle, number: self.translator.chapterNumber, shouldShowNumber: self.translator.shouldShowChapterNumber, isFocused: self.translator.shouldFocusOnChapterTitle)
                                    Spacer()
                                }
                                Spacer()
                            }
                        }
                        
                        
                        Hideable(isShowing: self.translator.shouldShowText, transition: .opacity) // <-- observed
                        {
                            // MARK: Page Count
                            
                            ZStack(alignment: .topLeading) {
                                HStack {
                                    Hideable(isShowing: self.translator.shouldShowLeftAndRightButtons, transition: .opacity) {
                                        Button(action: { self.evaluator?.buttonTapped(action: Evaluator.ButtonAction.pageBackward) }) {
                                            Image(systemName: "chevron.compact.left")
                                                .resizable()
                                                .frame(width: 3.5, height: 9, alignment: .center)
                                                .padding(EdgeInsets(top: 30, leading: 16, bottom: 30, trailing: 0))
                                                .font(Font.system(size: 16, weight: .ultraLight))
                                                .opacity(0.7)
                                        }
                                    }
                                    Spacer().frame(width: 14)
                                    ObservingTextView(self.translator.pageXofX) // <-- observed
                                        .font(Font.caption.monospacedDigit())
                                        .opacity(0.85)
                                    Spacer().frame(width: 14)
                                    Hideable(isShowing: self.translator.shouldShowLeftAndRightButtons, transition: .opacity) {
                                        Button(action: { self.evaluator?.buttonTapped(action: Evaluator.ButtonAction.pageForward) }) {
                                            Image(systemName: "chevron.compact.right")
                                                .resizable()
                                                .frame(width: 3.5, height: 9, alignment: .center)
                                                .padding(EdgeInsets(top: 30, leading: 0, bottom: 30, trailing: 16))
                                                .font(Font.system(size: 16, weight: .ultraLight))
                                                .opacity(0.7)
                                        }
                                    }
                                }.offset(x: 0, y: -(Layout.boxSize / 2.0 + 24))
                            }
                            .fixedSize(horizontal: true, vertical: true)
                            .frame(width: 100, height: 100)
                            .foregroundColor(Color.primary)
                        }
                                
                        Hideable(isShowing: self.translator.shouldShowText, transition: .opacity) // <-- observed
                        {
                            ZStack(alignment: .topLeading) {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(
                                        self.touchingDownOnBox ? Color.black.opacity(0.03) : Color.black.opacity(0.025)
                                )
                                VStack {
                                    
                                    // MARK: Page Text
                                    
//                                    SwappableText(self.translator.text, kerning: -0.05, transition: .opacity)
                                    ObservingTextView(self.translator.text) // <-- observed
                                        .font(Font.system(size: 17, weight: .medium))
//                                        .font(.headline)
                                        .lineSpacing(4)
                                        .padding(EdgeInsets(top: 20, leading: 20, bottom: 10, trailing: 20))
                                        .blur(radius: self.touchingDownOnBox ? 0.25 : 0)
                                        .opacity(self.touchingDownOnBox ? 0.33 : 1)
                                    Spacer()
                                }
                            }
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
                                self.evaluator?.buttonTapped(action: Evaluator.ButtonAction.pageForward)
                            }
                        }
                        
                        // MARK: Image
                        
                        Hideable(isShowing: self.translator.shouldShowImage, transition: .opacity) // <-- observed
                        {
                            ZStack(alignment: .center) {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.black.opacity(0.025))
                                
                                ObservingImageView(self.translator.imageName) // <-- observed
                                    .font(Font.headline)
                                    .frame(width: 130, height: 130)
                            }
                            .frame(width: Layout.boxSize, height: Layout.boxSize)
                                
                        }
                        .onTapGesture {
                            debugPrint("tap image")
                            self.evaluator?.buttonTapped(action: Evaluator.ButtonAction.advanceWorldImage)
                        }
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
                        .font(Font.caption)
                        .opacity(0.85)
                        .padding(.top, 10)
                    }
                    Spacer()
                }
                .offset(x: 0, y: Layout.boxSize / 2.0 + 30)
                
                // MARK: Illustration
                
                VStack {
                    Spacer()
//                    Hideable(isShowing: self.translator.shouldShowIllustration, transition: .opacity)
//                    {
//                    Image("")
//                    }
                        .padding(.bottom, 20)
                }
                
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
                                    .foregroundColor(.white)
                                    .padding(EdgeInsets(top: 12, leading: 18, bottom: 12, trailing: 18))
                                    .background(Capsule().fill(Color.black.opacity(0.95)))
                        })
                    }
                    .padding(.bottom, 36)
                }
                
                // MARK: Table of Contents Button and About Button
                
                VStack {
                    HStack {
                        Hideable(isShowing: self.translator.shouldShowTableOfContentsButton, transition: .opacity) {
                            
                            Button(action: {
                                self.showingTableOfContents.toggle()
                            }) {
                                Image(systemName: "list.bullet")
                            }.sheet(isPresented: self.$showingTableOfContents) {
                                TableOfContents(selectableChapterTitles: self.translator.selectableChapterTitles, evaluator: self.evaluator)
                            }
                            .foregroundColor(Color.primary)
                            .font(Font.system(size: 20, weight: .medium))
                            .padding(EdgeInsets.init(top: 16, leading: 22, bottom: 16, trailing: 24))
                        }
                        
                        Spacer()
                        
                        Hideable(isShowing: self.translator.shouldShowAboutButton, transition: .opacity) {
                            Button(action: {
                                self.showingAbout.toggle()
                            }) {
                                Image(systemName: "sparkles")
                            }.sheet(isPresented: self.$showingAbout) {
                                About.Screen()
                            }
                            .foregroundColor(Color.primary)
                            .font(Font.system(size: 20, weight: .medium))
                            .padding(EdgeInsets.init(top: 16, leading: 22, bottom: 16, trailing: 24))
                        }
                    }
                    Spacer()
                }
            }
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

struct TableOfContents: View {
    @ObservedObject var selectableChapterTitles: ObservableArray<NumberedNamedEvaluatorAction>
    weak var evaluator: ButtonEvaluator?
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            VStack {
                DismissButton()
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
            }.background(Rectangle().fill(Color(UIColor.systemBackground)))
        }
    }
}

struct Dimmable: View {
    @ObservedObject var isShowing: ObservableBool
    let content: AnyView
    var body: some View {
        return content
            .opacity(isShowing.bool ? 1 : 0.2)
    }
}

struct Hideable<Content>: View where Content : View {
    @ObservedObject var isShowing: ObservableBool
    var transition: AnyTransition?
    var content: () -> Content
    
    init(isShowing: ObservableBool, transition: AnyTransition? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.isShowing = isShowing
        self.transition = transition
        self.content = content
    }
    
    var body: some View {
        Group {
            if isShowing.bool {
                Group {
                    if transition != nil {
                        content()
                            .transition(transition!)
                    } else {
                        content()
                    }
                }
            }
        }
    }
}

struct MainTitle: View {
    @ObservedObject var text: ObservableString
    
    var body: some View {
        GeometryReader() { geometry in
            VStack {
                ObservingTextView(self.text, alignment: .center, kerning: -0.05)
                    .font(Font.system(size: 32, weight: .semibold).monospacedDigit())
                    .opacity(0.85)
                    .padding(.top, 5)
            }
        }
    }
}

struct ChapterTitle: View {
    @ObservedObject var text: ObservableString
    @ObservedObject var number: ObservableInt
    @ObservedObject var shouldShowNumber: ObservableBool
    @ObservedObject var isFocused: ObservableBool
    
    var body: some View {
        GeometryReader() { geometry in
            VStack {
                Image.numberCircleFill(self.number.int)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .opacity(self.shouldShowNumber.bool ? 1 : 0)
                ObservingTextView(self.text, alignment: .center, kerning: -0.05)
                    .font(Font.system(size: 24, weight: .semibold).monospacedDigit())
                    .opacity(0.85)
                    .padding(.top, 5)
            }
            .offset(x: 0, y: self.isFocused.bool ? 0 : -266)
        }
    }
}

struct SwappableText: View {
    var text: ObservableString
    var alignment: TextAlignment
    var kerning: CGFloat
    var transition: AnyTransition

    private var isShowing = ObservableBool(true)
    @State private var localText: String = ""
    
    init(_ text: ObservableString, alignment: TextAlignment = .leading, kerning: CGFloat = 0, transition: AnyTransition) {
        self.text = text
        self.alignment = alignment
        self.kerning = kerning
        self.transition = transition
        self.localText = text.string
    }
    
    var body: some View {
        debugPrint("swappable text body")
        return Hideable(isShowing: isShowing, transition: transition) {
            Text(self.localText == "" && self.text.string != "" ? self.text.string : self.localText)
                .kerning(self.kerning)
                .multilineTextAlignment(self.alignment)
                .onReceive(self.text.objectWillChange) { _ in
                    if self.text.string != self.localText {
                        withAnimation(.linear(duration: 0.1)) {
                            self.isShowing.bool = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now().advanced(by: .milliseconds(150))) {
                            withAnimation(.linear(duration: 0.1)) {
                                self.isShowing.bool = true
                                self.localText = self.text.string
                            }
                        }
                    }
            }
        }
    }
}

struct ObservingButton<Label>: View where Label : View {
    @ObservedObject var action: Observable<EvaluatorAction?>
    var evaluator: ButtonEvaluator?
    var label: () -> Label
    
    init(action: Observable<EvaluatorAction?>, evaluator: ButtonEvaluator?, @ViewBuilder label: @escaping () -> Label) {
        self.action = action
        self.evaluator = evaluator
        self.label = label
    }

    var body: some View {
        return Button(action: { self.evaluator?.buttonTapped(action: self.action.object) }, label: label)
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
        content
            .simultaneousGesture(DragGesture(minimumDistance: 0)
                .onChanged { value in
                    if !self.tapped {
                        self.tapped = true
                        self.callback()
                    }
                }
                .onEnded { _ in
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
        content
            .simultaneousGesture(DragGesture(minimumDistance: 0)
                .onChanged { value in
                    
                    let movementX = value.translation.width
                    let movementY = value.translation.height
                    
                    let distanceLeft = value.startLocation.x
                    let distanceRight = self.width - value.startLocation.x
                    let distanceUp = value.startLocation.y
                    let distanceDown = self.height - value.startLocation.y
                    
                    debugPrint("width: \(self.width)")
                    debugPrint("startLocation.x: \(value.startLocation.x)")
                    debugPrint("movementx: \(movementX)")
                    debugPrint("distanceRight: \(distanceRight)")
                    
                    if movementX < -distanceLeft ||
                        movementX > distanceRight ||
                        movementY < -distanceUp ||
                        movementY > distanceDown
                        {
                        self.canceled = true
                        self.cancelCallback()
                    }
                    
                }
                .onEnded { _ in
                    if self.canceled == false {
                        self.callback()
                    }
                    self.canceled = false
                })
    }
}
