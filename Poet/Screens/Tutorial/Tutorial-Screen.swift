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
        
        typealias ButtonAction = Evaluator.ButtonAction
        
        let _evaluator: Evaluator
        weak var evaluator: Evaluator?
        let translator: Translator
        
        enum Layout {
            static let boxSize: CGFloat = 370
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
        @State var showingExtra = false
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
                                    ChapterTitle(text: self.translator.chapterTitle, number: self.translator.chapterNumber, shouldShowNumber: self.translator.shouldShowChapterNumber, isFocused: self.translator.shouldFocusOnChapterTitle, boxSize: Layout.boxSize)
                                    Spacer()
                                }
                                Spacer()
                            }
                        }
                        
                        // MARK: Page Body
                                
                        Hideable(isShowing: self.translator.shouldShowBody, transition: .opacity) // <-- observed
                        {
                            ZStack(alignment: .topLeading) {
//                                RoundedRectangle(cornerRadius: 12)
//                                    .stroke( Color.primary.opacity(0.0025))
                                    
                                VStack {
                                    
                                    TutorialBodyView(bodyElements: self.translator.body, isTouching: self.$touchingDownOnBox)
                                    Spacer()
                                }
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                .fill(
//                                    Color.white
                                    self.touchingDownOnBox ?
                                        LinearGradient(gradient: Gradient(colors: [Color.primary.opacity(0.01), Color.primary.opacity(0.015)]), startPoint: .top, endPoint: .bottom) :
                                        LinearGradient(gradient: Gradient(colors: [Color.primary.opacity(0.003), Color.primary.opacity(0.005)]), startPoint: .top, endPoint: .bottom)
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
                                self.evaluator?.buttonTapped(action: ButtonAction.pageForward)
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
                                    .foregroundColor(Color(UIColor.systemBackground))
                                    .padding(EdgeInsets(top: 12, leading: 22, bottom: 12, trailing: 22))
                                    .background(Capsule().fill(Color.primary))
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
                                    Button(action: { self.evaluator?.buttonTapped(action: ButtonAction.pageBackward) }) {
                                        Image(systemName: "chevron.compact.left")
                                            .resizable()
                                            .frame(width: 7, height: 16, alignment: .center)
                                            .padding(EdgeInsets(top: 32, leading: 18, bottom: 32, trailing: 0))
                                            .font(Font.system(size: 16, weight: .thin))
                                            .opacity(0.2)
                                    }
                                    .layoutPriority(0)
                                    .zIndex(4)
                                }
                                .layoutPriority(0)
                                Spacer().frame(width: 22)
                                    .layoutPriority(0)
                                ObservingTextView(self.translator.pageXofX) // <-- observed
                                    .font(Font.system(size: 16, weight: .regular).monospacedDigit())
                                    .fixedSize(horizontal: true, vertical: false)
                                    .layoutPriority(2)
                                Spacer().frame(width: 22)
                                    .layoutPriority(0)
                                Hideable(isShowing: self.translator.shouldShowLeftAndRightButtons, transition: .opacity) {
                                    Button(action: { self.evaluator?.buttonTapped(action: ButtonAction.pageForward) }) {
                                        Image(systemName: "chevron.compact.right")
                                            .resizable()
                                            .frame(width: 7, height: 16, alignment: .center)
                                            .padding(EdgeInsets(top: 32, leading: 0, bottom: 32, trailing: 18))
                                            .font(Font.system(size: 16, weight: .thin))
                                            .opacity(0.2)
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
                                TableOfContents(selectableChapterTitles: self.translator.selectableChapterTitles, evaluator: self.evaluator)
                            }
                            .foregroundColor(Color.primary.opacity(0.9))
                            .font(Font.system(size: 20, weight: .regular))
                            
                        }
                        .layoutPriority(2)
                        .frame(width: 40, height: 40)
                        
                        Spacer()
                        .layoutPriority(2)
                    }
                    Spacer()
                }.padding(EdgeInsets.init(top: 10, leading: 24, bottom: 16, trailing: 24))
                
                // MARK: Supplement Button
                
                VStack(alignment: .trailing) {
                    HStack {
                        Spacer()
                        Hideable(isShowing: self.translator.shouldShowExtraButton, transition: AnyTransition.opacity.combined(with: AnyTransition.offset(x: 20, y: 0))) {
                            Button(action: {
                                self.showingExtra.toggle()
                            }) {
                                HStack {
                                    Spacer()
                                    ObservingTextView(self.translator.supplementTitle)
                                        .font(Font.subheadline)
                                        .fixedSize(horizontal: true, vertical: false)
                                        .frame(height:40)
                                    
                                    
                                    Image(systemName: "text.bubble")
                                        .font(Font.system(size: 20, weight: .medium))
                                        .padding(30)
                                        .zIndex(4)
                                        .transition(.scale)
                                        .frame(width: 40, height: 40)
                                }
                            }
                            .sheet(isPresented: self.$showingExtra) {
                                Extra(bodyElements: self.translator.supplementBody)
                            }
                            
                        }
                        .frame(height: 40)
                        .padding(.trailing, 24)
                        .foregroundColor(.primary)
                    }
                    Spacer()
                }
                .padding(.top, 14)
                
                Group {
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
                    
                    // MARK: Retail Demo
                    Presenter(self.translator.showRetailDemo) {
                        Retail.Screen()
                    }
                    
                    // MARK: Alert
                    AlertView(translator: translator)
                    
                    // MARK: Character Bezel
                    CharacterBezelView(translator: translator)
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

struct Presenter<Content>: View where Content : View {
    let passablePlease: PassablePlease
    var content: () -> Content
    @State var isShowing: Bool = false
       
    init(_ passablePlease: PassablePlease, @ViewBuilder content: @escaping () -> Content) {
        self.passablePlease = passablePlease
        self.content = content
    }
    
    var body: some View {
        Spacer()
            .sheet(isPresented: self.$isShowing) {
                self.content()
            }
            .onReceive(passablePlease.subject) { _ in
                self.isShowing.toggle()
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

struct Extra: View {
    @ObservedObject var bodyElements: ObservableArray<Tutorial.Evaluator.Page.Body>
    
    var body: some View {
        ZStack {
            VStack {
                DismissButton(foregroundColor: Color.white)
                    .zIndex(2)
                Spacer()
            }.zIndex(2)
            
            VStack(alignment: .leading) {
                ScrollView(.horizontal, showsIndicators: false) {
                    ScrollView(.vertical, showsIndicators: false) {
                        Spacer().frame(height:52)
                        ForEach(self.bodyElements.array, id: \.id) { bodyElement in
                            HStack {
                                self.viewForBodyElement(bodyElement)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                        }
                        .padding(EdgeInsets(top: 0, leading: 36, bottom: 30, trailing: 16))
                        Spacer()
                    }
                }
            }.background(Rectangle().fill(
                Color(UIColor(red: 54/255.0, green: 103/255.0, blue: 194/255.0, alpha: 1))
            ))
        }.edgesIgnoringSafeArea(.bottom)
    }
    
    func viewForBodyElement(_ bodyElement: Tutorial.Evaluator.Page.Body) -> AnyView {
        switch bodyElement {
        case .text(let text):
            return AnyView(
                Text(text)
                    .font(Font.system(size: 16, weight: .medium))
                    .lineSpacing(5)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, 14)
            )
        case .code(let code):
            return AnyView(
                Text(code)
                    .font(Font.system(size: 12, weight: .semibold, design: .monospaced))
                    .lineSpacing(5)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 14, trailing: -15))
            )
            
        case .smallCode(let code):
            return AnyView(
                Text(code)
                    .font(Font.system(size: 11.5, weight: .semibold, design: .monospaced))
                    .lineSpacing(5)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 14, trailing: -20))
            )
            
        case .extraSmallCode(let code):
            return AnyView(
                Text(code)
                    .font(Font.system(size: 10, weight: .semibold, design: .monospaced))
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 14, trailing: -20))
            )
        }
    }
}

struct TutorialBodyView: View {
    @ObservedObject var bodyElements: ObservableArray<Tutorial.Evaluator.Page.Body>
    @Binding var isTouching: Bool
    
    let bottomPadding: CGFloat = 16
    
    var body: some View {
        VStack {
            ForEach(bodyElements.array, id: \.id) { bodyElement in
                HStack {
                    self.viewForBodyElement(bodyElement)
                    Spacer()
                }
            }
            Spacer()
        }.padding(EdgeInsets(top: 26, leading: 26, bottom: -bottomPadding, trailing: 26))
    }
    
    func viewForBodyElement(_ bodyElement: Tutorial.Evaluator.Page.Body) -> AnyView {
        switch bodyElement {
        case .text(let text):
            return AnyView(
                Text(text)
                    .font(Font.body)
                    .lineSpacing(5)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, 16)
                    .opacity(self.isTouching ? 0.33 : 1)
            )
        case .code(let code):
            return AnyView(
                Text(code)
                    .font(Font.system(size: 13, weight: .regular, design: .monospaced))
                    .lineSpacing(5)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: bottomPadding, trailing: -25))
                    .opacity(self.isTouching ? 0.33 : 1)
            )
            
        case .smallCode(let code):
            return AnyView(
                Text(code)
                    .font(Font.system(size: 11.5, weight: .regular, design: .monospaced))
                    .lineSpacing(5)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: bottomPadding, trailing: -25))
                    .opacity(self.isTouching ? 0.33 : 1)
            )
            
        case .extraSmallCode(let code):
            return AnyView(
                Text(code)
                    .font(Font.system(size: 10.5, weight: .regular, design: .monospaced))
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: bottomPadding, trailing: -25))
                    .opacity(self.isTouching ? 0.33 : 1)
            )
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
    let boxSize: CGFloat
    
    var body: some View {
        GeometryReader() { geometry in
            VStack {
                Image.numberCircleFill(self.number.int)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .opacity(self.shouldShowNumber.bool ? 1 : 0)
                ObservingTextView(self.text, alignment: .center, kerning: -0.05)
                    .font(Font.system(size: 24, weight: .semibold).monospacedDigit())
                    .padding(.top, 5)
            }
            .offset(x: 0, y: self.isFocused.bool ? 0 : -((self.boxSize / 2.0) + 52))
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
