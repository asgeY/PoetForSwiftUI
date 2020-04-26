//
//  Pager-Screen.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/24/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct Pager {}

extension Pager {
    struct Screen: View {
        let _evaluator: Pager.Evaluator
        weak var evaluator: Pager.Evaluator?
        let translator: Pager.Translator
        
        init() {
            debugPrint("init Pager Screen")
            _evaluator = Evaluator()
            evaluator = _evaluator
            translator = _evaluator.translator
        }
        
        @State var navBarHidden: Bool = true
        @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
        
        var body: some View {
            
            ZStack {
                ZStack {
                    VStack {
                        BackButton()
                        Spacer()
                    }
                    VStack {
                        Spacer().frame(height:10)
                        
                        // MARK: Screen Title
                        Text("The Poet Pattern\nfor SwiftUI")
                            .font(Font.subheadline.monospacedDigit().bold())
                            .layoutPriority(4)
                            .multilineTextAlignment(.center)
                        Spacer().frame(height:32)
                        
                        // MARK: Tappable Page Title
                        ButtonActionView(
                            action: evaluator?.titleAction,
                            content:
                                AnyView(
                                    ObservingTextView(
                                        text: translator.observable.pageTitle,
                                        font: Font.headline.monospacedDigit(),
                                        alignment: .center)
                                )
                        )
                        Spacer().frame(height:16)
                        
                        // MARK: Page Body
                        
//                                Spacer()
//                                    .frame(width:(geometry.size.width * 0.23).bounded(minimum: 72, maximum: 120))
                            PageBodyView(pageBody: self.translator.observable.pageBody)
                                .layoutPriority(10)
                                
//                                .frame(minWidth: geometry.size.width - (geometry.size.width * 0.23).bounded(minimum: 72, maximum: 120),
//                                       idealWidth: geometry.size.width - (geometry.size.width * 0.23).bounded(minimum: 72, maximum: 120),
//                                       maxWidth: geometry.size.width - (geometry.size.width * 0.23).bounded(minimum: 72, maximum: 120),
//                                       minHeight:geometry.size.height - 180,
//                                       idealHeight:geometry.size.height + 100,
//                                       maxHeight:.infinity)
//                                    .layoutPriority(3)
//                            .frame(height:geometry.size.height - 180)
//                                Spacer()
//                                    .frame(width:(geometry.size.width * 0.23).bounded(minimum: 72, maximum: 120))
                        
//                            .frame(width: geometry.size.width, alignment: .leading)
//                                .layoutPriority(3)
                        
                        Spacer()
                            .layoutPriority(1)
                    }
                }
                
                // MARK: Left and Right Buttons
                LeftAndRightButtonView(
                    leftAction: self.evaluator?.leftAction,
                    rightAction: self.evaluator?.rightAction,
                    leftButtonIsEnabled: self.translator.observable.isLeftButtonEnabled,
                    rightButtonIsEnabled: self.translator.observable.isRightButtonEnabled)
                
                // MARK: Character Bezel
                CharacterBezel(
                    configuration: .init(character: self.translator.passable.emoji))
                
                // MARK: Page Number
                VStack {
                    Spacer()
                    TappableTextCapsuleView(
                        action: evaluator?.pageNumberAction,
                        text: translator.observable.pageXofX)
                    Spacer().frame(height: 10)
                }
                
                // MARK: Alert View
                AlertView(
                    title: translator.alertTitle,
                    message: translator.alertMessage,
                    isPresented: translator.isAlertPresented)
            }
                
            // MARK: ViewCycle
            .onAppear {
                self.navBarHidden = true
                self.evaluator?.viewDidAppear()
                UITableView.appearance().separatorStyle = .none
            }
            .onDisappear {
                UITableView.appearance().separatorStyle = .singleLine
            }
            
            // MARK: Hide Navigation Bar
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                self.navBarHidden = true
            }.onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                self.navBarHidden = false
            }
            .navigationBarTitle("Pager", displayMode: .inline)
                .navigationBarHidden(self.navBarHidden)
        }
    }
}

struct Pager_Screen_Previews: PreviewProvider {
    static var previews: some View {
        Pager.Screen()
    }
}

struct TappableTextCapsuleView: View {
    let action: Action
    @ObservedObject var text: ObservableString
    
    var body: some View {
        ButtonActionView(
            action: action.evaluate,
            content: AnyView(
                ObservingTextView(text: text, font: Font.subheadline.monospacedDigit(), alignment: .center)
                .padding(EdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14))
            )
        )
        .background(
            ZStack {
                Capsule()
                    .fill(Color.black.opacity(0.01))
                BlurView()
                .mask(
                    Capsule())
            }
        )
    }
}

struct PageBodyView: View {
    @ObservedObject var pageBody: ObservableArray<Page.Element>
    
    init(pageBody: ObservableArray<Page.Element>) {
        self.pageBody = pageBody
    }
    
    func view(for element: Page.Element) -> AnyView {
        switch element.type {
            case .text:
                return AnyView(
                    Text(element.text)
                        .font(Font.body.monospacedDigit())
                        .padding(EdgeInsets(top: 0, leading: 36, bottom: 10, trailing: 36))
                )
                
            case .code:
                return AnyView(
                    
                        Text(element.text)
                            .font(Font.system(size: 12, design: .monospaced))
                            .padding(EdgeInsets(top: 12, leading: 36, bottom: 12, trailing: 36))
                            .background(
                                GeometryReader() { geometry in
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.black.opacity(0.035))
                                    .frame(width: geometry.size.width - 44, height: geometry.size.height)
                                })
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                )
                
            case .quote:
                return AnyView(
                    Text(element.text)
                        .font(Font.system(size: 14, design: .monospaced))
                        .lineSpacing(1)
                        .padding(EdgeInsets(top: 0, leading: 36, bottom: 10, trailing: 36))
                )
            
            case .footnote:
            return AnyView(
                VStack {
                    Divider()
                        .padding(EdgeInsets(top: 0, leading: 36, bottom: 10, trailing: 36))
                    Text(element.text)
                        .font(Font.footnote.monospacedDigit())
                        .padding(EdgeInsets(top: 0, leading: 36, bottom: 10, trailing: 36))
                }
            )
        }
    }
    
    var body: some View {
        if self.pageBody.array.isEmpty {
            return AnyView(EmptyView())
        } else {
            return AnyView(
                List(pageBody.array, id: \.id) { element in
                    VStack {
                        self.view(for: element)
                        if self.pageBody.array.firstIndex(of: element) == self.pageBody.array.count - 1 {
                            Spacer().frame(height:36)
                        }
                    }
                }
                .id(UUID()) // <-- this forces the list not to animate
            )
        }
//                .font(element.type == .text ? Font.body.monospacedDigit() : (element.type == .code ? Font.system(size: 12, design: .monospaced) : Font.system(size: 14, design: .monospaced)))
//            switch element.type {
                
                
                        
                                    
//                case .text:
//                    return AnyView(
//
//                            Text(element.text)
//                                .font(Font.body.monospacedDigit())
//                                .multilineTextAlignment(.leading)
//
////                                    .padding(EdgeInsets(top: 0, leading: 36, bottom: 0, trailing: 36))
////                                    .frame(width:320)
//                    )
//
//                case .code:
//                    return AnyView(
//                            Text(element.text)
//                                .layoutPriority(99)
//                                .font(.system(size: 12, design: .monospaced))
//                                .multilineTextAlignment(.leading)
//                                //                                      .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
//                                .background(
//                                    RoundedRectangle(cornerRadius: 10)
//                                        .fill(Color.black.opacity(0.03))
//                                )
//
//                    )
//
//
//                case .quote:
//                    return AnyView(
//                            Text(element.text)
//                                .layoutPriority(98)
//                                .font(Font.system(size: 14, design: .monospaced))
//                                .multilineTextAlignment(.leading)
////                                    .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
//
//                    )
    }
}
