//
//  AlertTranslating.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/24/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine
import Foundation

// Alert

protocol AlertTranslating {
    var alertTranslator: AlertTranslator { get }
    func showAlert(title: String, message: String)
    func showAlert(title: String, message: String, alertAction: AlertAction)
    func showAlert(title: String, message: String, primaryAlertAction: AlertAction, secondaryAlertAction: AlertAction)
}

extension AlertTranslating {
    func showAlert(title: String, message: String) {
        alertTranslator.title.string = title
        alertTranslator.message.string = message
        alertTranslator.isAlertPresented.bool = true
        alertTranslator.primaryAlertAction.value = nil
        alertTranslator.secondaryAlertAction.value = nil
    }
    
    func showAlert(title: String, message: String, alertAction: AlertAction) {
        alertTranslator.title.string = title
        alertTranslator.message.string = message
        alertTranslator.primaryAlertAction.value = alertAction
        alertTranslator.secondaryAlertAction.value = nil
        alertTranslator.isAlertPresented.bool = true
    }
    
    func showAlert(title: String, message: String, primaryAlertAction: AlertAction, secondaryAlertAction: AlertAction) {
        alertTranslator.title.string = title
        alertTranslator.message.string = message
        alertTranslator.primaryAlertAction.value = primaryAlertAction
        alertTranslator.secondaryAlertAction.value = secondaryAlertAction
        alertTranslator.isAlertPresented.bool = true
    }
}

struct AlertTranslator {
    var title = ObservableString()
    var message = ObservableString()
    var primaryAlertAction = Observable<AlertAction?>(nil)
    var secondaryAlertAction = Observable<AlertAction?>(nil)
    var isAlertPresented = ObservableBool(false)
}

struct AlertAction {
    let title: String
    let style: AlertStyle
    let action: (() -> Void)?
    
    enum AlertStyle {
        case regular
        case cancel
        case destructive
    }
}
