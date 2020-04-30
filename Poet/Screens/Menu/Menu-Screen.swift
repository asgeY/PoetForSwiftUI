//
//  Menu-Screen.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/24/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct Menu {}

extension Menu {
    struct Screen: View {
        let evaluator: Menu.Evaluator
        let translator: Menu.Translator
        
        /*
         Why no @ObservedObjects here?
         If you assign any observed objects to the Screen,
         the whole screen will be reloaded each time that object changes.
         You don't want that.
         Instead, any of our views that want to observe an object must have one passed to them.
         e.g. ObservingTextView(text: translator.observable.stepName, font: Font.subheadline.monospacedDigit())
         Once I'm better at SwiftUI, I'll wrap a Text view better, so all of its view modifiers can be called on the wrapper.
         */
        
        init() {
            self.evaluator = Evaluator()
            self.translator = evaluator.translator
        }
        
        @State var isNavigationBarHidden: Bool = true
        
        var body: some View {
            NavigationView {
                VStack {
                    Spacer()
                        .frame(height: 20)
                    Text("The Poet Pattern\nfor SwiftUI")
                        .font(Font.system(size: 24, weight: .semibold, design: .default))
                        .multilineTextAlignment(.center)
                        .layoutPriority(2)
                    MenuItemList(items: translator.observable.items, evaluator: evaluator)
                        .layoutPriority(1)
                        .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30))
                        .onAppear {
                            UITableView.appearance().tableFooterView = UIView() // <-- this hides extra separators
                            UITableView.appearance().separatorStyle = .none
                    }
                    Spacer()
                }.onAppear() {
                    self.evaluator.viewDidAppear()
                    self.isNavigationBarHidden = true
                }
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarHidden(self.isNavigationBarHidden)
            }
        }
    }
}

struct Menu_Screen_Previews: PreviewProvider {
    static var previews: some View {
        Menu.Screen()
    }
}

struct MenuItemList: View {
    @ObservedObject var items: ObservableArray<ListEvaluatorItem>
    weak var evaluator: ListEvaluator?
    
    init(items: ObservableArray<ListEvaluatorItem>, evaluator: ListEvaluator?) {
        self.items = items
        self.evaluator = evaluator
    }
    
    var body: some View {
        List(items.array, id: \.id) { item in
            NavigationLink(destination: self.evaluator?.destination(for: item)) {
                Text(item.name)
                    .font(Font.headline)
            }
        }
    }
}

protocol ListEvaluatorItem {
    var id: String { get }
    var name: String { get }
}
    
protocol ListEvaluator: class {
    func destination(for item: ListEvaluatorItem) -> AnyView?
}
