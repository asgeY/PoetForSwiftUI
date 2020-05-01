//
//  ObservingPageView.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/29/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI
import Combine

protocol ObservingPageSection {
    var id: String { get }
}

protocol ObservingPageView_ViewMaker {
    func view(for: ObservingPageSection) -> AnyView
}

struct ObservingPageView: View {
    @ObservedObject var sections: ObservableArray<ObservingPageSection>
    var viewMaker: ObservingPageView_ViewMaker
    
    var body: some View {
        debugPrint("make Retail Tutorial Page View")
        if self.sections.array.isEmpty {
            return AnyView(EmptyView())
        } else {
            return AnyView(
                VStack() {
                    List(sections.array, id: \.id) { section in
                        VStack {
                            self.viewMaker.view(for: section)
                            if (self.sections.array.firstIndex(where: {
                                $0.id == section.id
                            })) == self.sections.array.count - 1 {
                                Spacer().frame(height:CGFloat(45))
                            }
                        }
                    }
                        .onAppear() {
                            UITableView.appearance().showsVerticalScrollIndicator = false
                            UITableView.appearance().separatorColor = .clear
                        }
                    Spacer()
                }
            )
        }
    }
}
