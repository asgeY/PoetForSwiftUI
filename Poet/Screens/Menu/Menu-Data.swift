//
//  Menu-Data.swift
//  Poet
//
//  Created by Stephen E Cotner on 5/1/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

protocol MenuListItem {
    var name: String { get }
    var destination: () -> AnyView? { get }
    var type: MenuListItemType { get }
    var id: UUID { get }
}

enum MenuListItemType {
    case title
    case link
}

extension Menu {
    // Data Types
    
    struct Link: MenuListItem, Identifiable {
        var name: String
        var destination: () -> AnyView?
        var id: UUID = UUID()
        var type: MenuListItemType { return .link }
        
        init(_ name: String, destination: @escaping () -> AnyView?) {
            self.name = name
            self.destination = destination
        }
    }
    
    struct Title: MenuListItem {
        
        let name: String
        var id: UUID = UUID()
        var type: MenuListItemType { return .title }
        var destination: () -> AnyView? {{ nil }}
        
        init(_ name: String) {
            self.name = name
        }
    }
}

