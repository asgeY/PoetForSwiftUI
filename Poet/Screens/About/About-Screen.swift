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
            return GeometryReader() { geometry in
                ZStack {
                    VStack {
                        DismissButton(orientation: .right)
                            .zIndex(2)
                        Spacer()
                    }.zIndex(2)
                    
                    VStack {
                        
                        // MARK: Page Body
                        ObservingPageView(
                            sections: self.translator.sections,
                            viewMaker: StaticPageViewMaker(),
                            margin: 50)

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
            }.edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct About_Screen_Previews: PreviewProvider {
    static var previews: some View {
        About.Screen()
    }
}
