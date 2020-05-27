//
//  AlertPresenter.swift
//  Poet
//
//  Created by Steve Cotner on 5/27/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct AlertPresenter: View {
    let passableAlert: PassableAlert
    
    var title = ObservableString()
    var message = ObservableString()
    var primaryAlertAction = Observable<AlertAction?>(nil)
    var secondaryAlertAction = Observable<AlertAction?>(nil)
    var isAlertPresented = ObservableBool(false)
    
    @State var isShowing: Bool = false
    
    init(_ passableAlert: PassableAlert) {
        self.passableAlert = passableAlert
    }
    
    var body: some View {
        AlertView(
            title: title,
            message: message,
            primaryAlertAction: primaryAlertAction,
            secondaryAlertAction: secondaryAlertAction,
            isPresented: isAlertPresented)
            
        .onReceive(passableAlert.subject) { alertConfiguration in
            if let alertConfiguration = alertConfiguration {
                self.title.string = alertConfiguration.title
                self.message.string = alertConfiguration.message
                self.primaryAlertAction.value = alertConfiguration.primaryAlertAction
                self.secondaryAlertAction.value = alertConfiguration.secondaryAlertAction
                self.isAlertPresented.bool = true
            }
        }
    }
}
