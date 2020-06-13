//
//  ViewDemoing.swift
//  Poet
//
//  Created by Steve Cotner on 6/6/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

protocol ViewDemoing {
    static var demoProvider: DemoProvider { get }
    static var namedDemoProvider: NamedDemoProvider { get }
}

extension ViewDemoing {
    static var namedDemoProvider: NamedDemoProvider {
        return NamedDemoProvider(
            title: String(describing: Self.self).splitAtCapitalLetters(),
            demoProvider: self.demoProvider)
    }
}

extension String {
    func splitAtCapitalLetters() -> String {
        var splitString = ""
        for char in self {
            if Character(extendedGraphemeClusterLiteral: char).isUppercase {
                splitString.append(" \(char)")
            } else {
                splitString.append("\(char)")
            }
        }
        return splitString
    }
}

