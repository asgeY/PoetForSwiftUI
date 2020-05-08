//
//  Intro-Screen.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/24/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI
import Combine

struct Intro {}

extension Intro {
    struct Screen: View {
        private let _evaluator: Intro.Evaluator
        weak var evaluator: Intro.Evaluator?
        let translator: Intro.Translator
        
        init() {
            _evaluator = Evaluator()
            evaluator = _evaluator
            translator = _evaluator.translator
        }
        
        @State var navBarHidden: Bool = true
        
        var body: some View {
            debugPrint("Intro body")
            return GeometryReader() { geometry in
                ZStack {
                    VStack {
                        BackButton()
                        Spacer()
                    }.zIndex(2)
                    VStack {
//                        Spacer().frame(height:12)
                        
                        // MARK: Screen Title
//                        Text("About")
//                            .font(Font.subheadline.monospacedDigit().bold())
//                            .multilineTextAlignment(.center)
//                            .layoutPriority(10)
                        
                        Spacer().frame(height:1)
                        
                        // MARK: Page Body
                        PageBodyView(pageBody: self.translator.pageBody)
                            .layoutPriority(10)

                        Spacer()
                            .layoutPriority(1)
                    }
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
                }.onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    self.navBarHidden = false
                }
                .navigationBarTitle("Pager", displayMode: .inline)
                    .navigationBarHidden(self.navBarHidden)
            }
        }
    }
}

struct Intro_Screen_Previews: PreviewProvider {
    static var previews: some View {
        Intro.Screen()
    }
}

struct BackButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        HStack {
            Button(
                action: { self.presentationMode.wrappedValue.dismiss() })
            {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color.black)
            }.padding(EdgeInsets.init(top: 16, leading: 24, bottom: 16, trailing: 22))
            Spacer()
        }
    }
}

struct DismissReceiver: View {
    var translator: DismissTranslator
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        Spacer().frame(width: 0.5, height: 0.5)
            .onReceive(translator.dismiss.subject) { _ in
                self.presentationMode.wrappedValue.dismiss()
        }
    }
}
