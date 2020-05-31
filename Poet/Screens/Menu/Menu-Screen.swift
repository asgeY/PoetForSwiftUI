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
        
        let evaluator: Evaluator
        let translator: Translator
        
        init() {
            evaluator = Evaluator()
            translator = evaluator.translator
        }
        
        /*
         Why no @ObservedObjects here?
         If you assign any observed objects to the Screen,
         the whole screen will be reloaded each time that object changes.
         You don't want that.
         Instead, any of our views that want to observe an object must have one passed to them.
         e.g. ObservingTextView(text: translator.observable.stepName, font: Font.subheadline.monospacedDigit())
         Once I'm better at SwiftUI, I'll wrap a Text view better, so all of its view modifiers can be called on the wrapper.
         */
        
        @State var isNavigationBarHidden: Bool = true
        
        var body: some View {
            NavigationView {
                VStack(alignment: .leading) {
                    Spacer()
                        .frame(height: 32)
                    
                    // Title
                    
                    Text("The Poet Pattern\nfor SwiftUI")
                        .font(Font.system(size: 32, weight: .bold, design: .default))
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .padding(EdgeInsets(top: 0, leading: 40, bottom: 6, trailing: 40))
                        .layoutPriority(20)
                    
                    // List
                    
                    MenuItemList(items: translator.items)
                        .layoutPriority(1)
                        .padding(EdgeInsets(top: 0, leading: 22, bottom: 0, trailing: 20))
                        .onAppear {
                            debugPrint("menu list did appear")
                    }
                    Spacer()
                }.onAppear() {
                    debugPrint("menu did appear")
                    UITableView.appearance().tableFooterView = UIView() // <-- this hides extra separators
                    UITableView.appearance().separatorColor = .clear
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
    @ObservedObject var items: ObservableArray<MenuListItem>
    
    var body: some View {
        if self.items.array.isEmpty {
            return AnyView(EmptyView())
        } else {
            return AnyView(
                VStack {
                    List(self.items.array, id: \.id) { item in
                        return self.view(for: item)
                    }
                }
            )
        }
    }
    
    func view(for item: MenuListItem) -> AnyView {
        switch item.type {
        case .title:
            return AnyView(
                Text(item.name)
                    .font(Font.headline.bold())
                    .opacity(0.33)
                    .padding(EdgeInsets(top: 26, leading: 0, bottom: 6, trailing: 0))
            )
        
        case .link:
            return AnyView(
                NavigationLink(destination: item.destination()) {
                    Text(item.name)
                        .font(Font.headline)
                }
            )
        }
    }
}
