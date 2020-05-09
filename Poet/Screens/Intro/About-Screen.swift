//
//  About-Screen.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/24/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI
import Combine

struct About {}

extension About {
    struct Screen: View {
        private let _evaluator: About.Evaluator
        weak var evaluator: About.Evaluator?
        let translator: About.Translator
        
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
                    VStack {
                        DismissButton()
                            .zIndex(2)
                        Spacer()
                    }.zIndex(2)
                    
                    VStack {
//                        Spacer().frame(height:10)
                        
                        // MARK: Page Body
                        PageBodyView(pageBody: self.translator.pageBody)

                        Spacer()
                    }.zIndex(1)
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

struct About_Screen_Previews: PreviewProvider {
    static var previews: some View {
        About.Screen()
    }
}

struct BackButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        HStack {
            Button(
                action: {
                    self.presentationMode.wrappedValue.dismiss()
            })
            {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color.primary)
                    .padding(EdgeInsets.init(top: 16, leading: 24, bottom: 16, trailing: 24))
            }
            
            Spacer()
        }
    }
}

struct DismissButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        HStack {
            Spacer()
            Button(
                action: {
                    self.presentationMode.wrappedValue.dismiss()
            })
            {
                Image(systemName: "xmark")
                    .foregroundColor(Color.primary)
                    .padding(EdgeInsets(top: 26, leading: 24, bottom: 24, trailing: 24))
                    .font(Font.system(size: 18, weight: .medium))
            }
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
