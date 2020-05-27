//
//  PassableAlert.swift
//  Poet
//
//  Created by Steve Cotner on 5/27/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine

class PassableAlert {
    var subject = PassthroughSubject<AlertConfiguration?, Never>()
    var alertConfiguration: AlertConfiguration? {
        willSet {
            subject.send(newValue)
        }
    }
    
    func withConfiguration(_ configuration: AlertConfiguration) {
        self.alertConfiguration = configuration
    }
    
    func withConfiguration(title: String, message: String) {
        self.alertConfiguration = AlertConfiguration(title: title, message: message)
    }
    
    func withConfiguration(title: String, message: String, alertAction: AlertAction) {
        self.alertConfiguration = AlertConfiguration(title: title, message: message, alertAction: alertAction)
    }
    
    func withConfiguration(title: String, message: String, primaryAlertAction: AlertAction, secondaryAlertAction: AlertAction) {
        self.alertConfiguration = AlertConfiguration(title: title, message: message, primaryAlertAction: primaryAlertAction, secondaryAlertAction: secondaryAlertAction)
    }
}

struct AlertConfiguration {
    var title: String
    var message: String
    var primaryAlertAction: AlertAction?
    var secondaryAlertAction: AlertAction?
    
    init(title: String, message: String) {
        self.title = title
        self.message = message
        self.primaryAlertAction = nil
        self.secondaryAlertAction = nil
    }
    
    init(title: String, message: String, alertAction: AlertAction) {
        self.title = title
        self.message = message
        self.primaryAlertAction = alertAction
        self.secondaryAlertAction = nil
    }
    
    init(title: String, message: String, primaryAlertAction: AlertAction, secondaryAlertAction: AlertAction) {
        self.title = title
        self.message = message
        self.primaryAlertAction = primaryAlertAction
        self.secondaryAlertAction = secondaryAlertAction
    }
}
