//
//  Chapter_PassableState.swift
//  Poet
//
//  Created by Steve Cotner on 5/26/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

extension Tutorial.PageStore {
    var chapter_PassableState: Chapter {
        return Chapter(
            "Passable State",
            pages:
            Page([
                .demo(.showSomething),
                .text("If you tap the button that says “Show Something,” you'll see a very simple screen pop up. Try it and come back when you're done (pull down to dismiss the screen)."),
                .text("How did our evaluator, translator, and view layer work together to present that?"),
                .text("They relied on what we can call passable state. More specifically, they made use of a PassthroughSubject to publish (and receive) our intent to show the screen."),
                .text("PassthroughSubjects are a tiny bit demanding to think about, so we've wrapped one inside a type we call PassablePlease:"),
                .code(
                    """
                    class PassablePlease {
                      var subject =
                        PassthroughSubject<Any?, Never>()
                      func please() {
                        subject.send(nil)
                      }
                    }
                    """
                ),
                .text("When our evaluator hears that we've triggered a Action named “showSomething,” it says to the translator directly:"),
                .code("translator.showSomething.please()"),
                .text("Why talk to the translator directly? We're presenting a modal, and everything on our current screen will remain unchanged underneath the modal. So it would feel superfluous to modify our own business state by changing our current step."),
                .text("Inside the translator, saying “please” works because we hold onto a PassablePlease object:"),
                .code(
                    """
                    var showSomething = PassablePlease()
                    """
                ),
            
                .text("The view layer is listening for that word. Whenever it hears please, it shows the screen by toggling a @State property that a sheet (or modal) holds onto as a binding. But we've made that something that's easy to think about, too."),
                
                // MARK: Presenter
                
                .title("Presenter"),
                .text("In the view layer, the entire code for presenting the Something screen looks like this:"),
                .code(
                    """
                    Presenter(self.translator.showSomething) {
                        Text("Something")
                    }
                    """
                ),
            
                .text("You could add a whole bunch of modals to a screen, each listening for a different please, by using that Presenter type. And in fact that's what this Tutorial does. So what does Presenter do under the hood?"),
                .text("Presenter is a view takes a PassablePlease and some view content as arguments. Here's its body:"),
                .code(
                    """
                    var body: some View {
                      Spacer()
                        .sheet(
                          isPresented: self.$isShowing)
                          { self.content() }
                        .onReceive(passablePlease.subject)
                          { _ in self.isShowing.toggle() }
                    }
                    """
                ),
                .file("Presenter"),
                .text("The job of a Presenter is to notice when a new “please” comes through and to toggle its own isShowing property. When that property toggles to true, the sheet will present the content."),
                .text("If we had needed to do some more translating before passing our please to the view layer, our evaluator could have called a method directly on the translator, something like this:"),
                .code("translator.showSomethingScreen()"),
                .text("The translator then would do whatever extra translating it had in mind before calling please() on its own property."),
                .text("And that's how we pass state imperatively. We keep a rigorous separation of our different layers, but we also link them up with minimal code that's easy to follow."),
                
                // MARK: Presenter with String
                
                .title("Presenter with String"),
                .text("Coming soon…"),
                
                // MARK: Alert Presenter
                
                .title("Alert Presenter"),
                .text("Coming soon…"),
                
                // MARK: Bezel Presenter
                
                .title("Bezel Presenter"),
                .text("Coming soon…"),
                
                // MARK: Presenter with Passable Value
                
                .title("Presenter with Passable Value"),
                .text("Coming soon…")
                
                
            ])
        )
    }
}
