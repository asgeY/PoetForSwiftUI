//
//  HelloWorld-Store.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/16/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

extension HelloWorld {
    
    // Types
    
    struct CelestialBody: Decodable {
        let name: String
        let images: [String]
        let foreground: CelestialBodyColor
        let background: CelestialBodyColor
        let id: UUID
        
        enum CodingKeys: String, CodingKey {
            case name
            case images
            case foreground
            case background
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            name = try values.decode(String.self, forKey: .name)
            images = try values.decode([String].self, forKey: .images)
            foreground = try values.decode(CelestialBodyColor.self, forKey: .foreground)
            background = try values.decode(CelestialBodyColor.self, forKey: .background)
            id = UUID()
        }
        
        enum CelestialBodyColor: String, Decodable {
            case blue = "blue"
            case lightGreen = "lightGreen"
            case darkGreen = "darkGreen"
            case deepblue = "deepblue"
            case green = "green"
            case lightIndigoPink = "lightIndigoPink"
            case magenta = "magenta"
            case orange = "orange"
            case pink = "pink"
            case white = "white"
            case yellow = "yellow"
    
            var color: Color {
                switch self {
                case .blue:             return Color(UIColor.systemTeal)
                case .lightGreen:       return Color(UIColor(red: 166/255.0, green: 225/255.0, blue: 166/255.0, alpha: 1))
                case .darkGreen:        return Color(UIColor(red: 37/255.0, green: 107/255.0, blue: 51/255.0, alpha: 1))
                case .deepblue:         return Color(UIColor(red: 36/255.0, green: 85/255.0, blue: 116/255.0, alpha: 1))
                case .green:            return Color(UIColor.systemGreen)
                case .lightIndigoPink:  return Color(UIColor(red: 166/255.0, green: 139/255.0, blue: 204/255.0, alpha: 1))
                case .magenta:          return Color(UIColor.magenta)
                case .orange:           return Color(UIColor.systemOrange)
                case .pink:             return Color(UIColor(red: 248/255.0, green: 188/255.0, blue: 199/255.0, alpha: 1))
                case .white:            return Color.white
                case .yellow:           return Color(UIColor.systemYellow)
                }
            }
        }
    }
    
    // Store
    
    class Store {
        static let shared = Store()
        
        lazy var data: [CelestialBody] = {
            if let jsonData = json.data(using: .utf8) {
                let decoder = JSONDecoder()
                do {
                    let bodies = try decoder.decode([CelestialBody].self, from: jsonData)
                    return bodies
                } catch {
                    // eh, what are ya gonna do...
                    debugPrint("oops")
                }
            }
            return []
        }()
        
        let json: String =
"""
[
    {
    "name": "World",
    "images": [
        "world01",
        "world02",
        "world03",
        "world04",
        "world05",
        "world06"
    ],
    "foreground": "blue",
    "background": "lightGreen"
    },

    {
    "name": "Moon",
    "images": [
        "moon01",
        "moon02",
        "moon03",
        "moon04",
        "moon05",
        "moon06"
    ],
    "foreground": "lightIndigoPink",
    "background": "pink"
    },

    {
    "name": "Sun",
    "images": [
        "sun"
    ],
    "foreground": "yellow",
    "background": "orange"
    },

    {
    "name": "Comet",
    "images": [
        "comet01",
        "comet02",
        "comet03",
        "comet04",
        "comet05",
        "comet06"
    ],
    "foreground": "pink",
    "background": "deepblue"
    }
]

"""
    }
}

