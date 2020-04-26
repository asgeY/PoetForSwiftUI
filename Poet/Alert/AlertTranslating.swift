//
//  AlertTranslating.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/24/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine
import Foundation

protocol AlertTranslating {
    var alertTranslator: AlertTranslator { get }
    func showAlert(title: String, message: String)
}

extension AlertTranslating {
    func showAlert(title: String, message: String) {
        alertTranslator.alertTitle.string = title
        alertTranslator.alertMessage.string = message
        alertTranslator.isPresented.bool = true
    }
}

struct AlertTranslator {
    var alertTitle = ObservableString()
    var alertMessage = ObservableString()
    var isPresented = ObservableBool(false)
}
