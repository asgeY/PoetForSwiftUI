//
//  PagingTutorial-Translator.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/24/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine
import Foundation

extension PagingTutorial {
    
    class Translator: AlertTranslating, BezelTranslating {
        
        typealias Evaluator = PagingTutorial.Evaluator
        
        // Observable state
        var isLeftButtonEnabled = ObservableBool(true)
        var isRightButtonEnabled = ObservableBool(true)
        var pageBody = ObservableArray<Page.Element>([])
        var pageXofX = ObservableString()
        
        // Translating protocols
        var alertTranslator = AlertTranslator()
        var bezelTranslator = BezelTranslator()
        
        var behavior: Behavior?
        
        init(_ step: PassableStep<Evaluator.Step>) {
            behavior = step.subject.sink { value in
                self.translate(step: value)
            }
        }
    }
}

// MARK: Translating Methods

/*
 Here we translate the expressed intent of the evaluator
 into state that our views can listen to: observables and passables
 */

extension PagingTutorial.Translator {
    
    func translate(step: Evaluator.Step) {
        switch step {
        case .loading:
            showLoading()
        case .page(let configuration):
            showPage(configuration)
        }
    }
    
    func showLoading() {
        pageBody.array = []
        pageXofX.string = ""
        isLeftButtonEnabled.bool = false
        isRightButtonEnabled.bool = false
    }
    
    func showPage(_ configuration: Evaluator.PageConfiguration) {
        pageBody.array = configuration.page.body
        pageXofX.string = "\(configuration.pageNumber) / \(configuration.pageCount)"
        isLeftButtonEnabled.bool = configuration.pageNumber > 1
        isRightButtonEnabled.bool = configuration.pageNumber < configuration.pageCount
    }
}
