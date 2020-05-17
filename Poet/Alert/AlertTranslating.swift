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
        alertTranslator.alertTitle.string = title
        alertTranslator.alertMessage.string = message
        alertTranslator.isAlertPresented.bool = true
        alertTranslator.primaryAlertAction.alertAction = nil
        alertTranslator.secondaryAlertAction.alertAction = nil
    }
    
    func showAlert(title: String, message: String, alertAction: AlertAction) {
        alertTranslator.alertTitle.string = title
        alertTranslator.alertMessage.string = message
        alertTranslator.primaryAlertAction.alertAction = alertAction
        alertTranslator.secondaryAlertAction.alertAction = nil
        alertTranslator.isAlertPresented.bool = true
    }
    
    func showAlert(title: String, message: String, primaryAlertAction: AlertAction, secondaryAlertAction: AlertAction) {
        alertTranslator.alertTitle.string = title
        alertTranslator.alertMessage.string = message
        alertTranslator.primaryAlertAction.alertAction = primaryAlertAction
        alertTranslator.secondaryAlertAction.alertAction = secondaryAlertAction
        alertTranslator.isAlertPresented.bool = true
    }
}

struct AlertTranslator {
    var alertTitle = ObservableString()
    var alertMessage = ObservableString()
    var primaryAlertAction = ObservableAlertAction()
    var secondaryAlertAction = ObservableAlertAction()
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

// Bezel

protocol BezelTranslating {
    var bezelTranslator: BezelTranslator { get }
    func showBezel(character: String)
}

extension BezelTranslating {
    func showBezel(character: String) {
        bezelTranslator.character.string = character
    }
}

struct BezelTranslator {
    var character = PassableString()
}

protocol DismissTranslating {
    var dismissTranslator: DismissTranslator { get }
    func dismiss()
}

extension DismissTranslating {
    func dismiss() {
        dismissTranslator.dismiss.please()
    }
}

struct DismissTranslator {
    var dismiss = PassablePlease()
}
