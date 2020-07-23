//
//  PresenterWithPassedValue.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/23/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

protocol PresenterEvaluating {
    func presenterDidDismiss(elementName: EvaluatorElement?)
}

struct PresenterWithPassedValue<PassedType, Content>: View where Content : View {
    let passable: Passable<PassedType>
    let elementName: EvaluatorElement?
    var evaluator: PresenterEvaluating?
    var content: (PassedType) -> Content
    
    @ObservedObject var passedValue = Observable<PassedType?>(nil)
    @State var isShowing = false
    
    init(_ passable: Passable<PassedType>, elementName: EvaluatorElement? = nil, evaluator: PresenterEvaluating? = nil, @ViewBuilder content: @escaping (PassedType) -> Content) {
        self.passable = passable
        self.elementName = elementName
        self.evaluator = evaluator
        self.content = content
    }
    
    var body: some View {
        Spacer()
            .sheet(isPresented: self.$isShowing, onDismiss: {
                self.evaluator?.presenterDidDismiss(elementName: self.elementName)
            }, content: {
                Group {
                    if let passedValue = self.passedValue.value {
                        self.content(passedValue)
                    }
                }
                .onDisappear {
                    self.passable.value = nil
                    self.passedValue.value = nil
                }
            })
            
        .onReceive(passable.subject) { value in
            if let value = value {
                self.passedValue.value = value
                self.isShowing = true
            }
        }
    }
}
