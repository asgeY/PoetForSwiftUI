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
            case brightblue = "brightblue"
            case lightgreen = "lightgreen"
            case darkgreen = "darkgreen"
            case deepblue = "deepblue"
            case green = "green"
            case hotpink = "hotpink"
            case indigopink = "indigopink"
            case ivory = "ivory"
            case orange = "orange"
            case pink = "pink"
            case purple = "purple"
            case salmon = "salmon"
            case seafoam = "seafoam"
            case white = "white"
            case yellow = "yellow"
    
            var color: Color {
                switch self {
                case .blue:             return Color(UIColor.systemTeal)
                case .brightblue:       return Color(UIColor(red: 73/255.0, green: 190/255.0, blue: 222/255.0, alpha: 1))
                case .lightgreen:       return Color(UIColor(red: 166/255.0, green: 225/255.0, blue: 166/255.0, alpha: 1))
                case .darkgreen:        return Color(UIColor(red: 37/255.0, green: 107/255.0, blue: 51/255.0, alpha: 1))
                case .deepblue:         return Color(UIColor(red: 41/255.0, green: 42/255.0, blue: 51/255.0, alpha: 1))
                case .green:            return Color(UIColor.systemGreen)
                case .hotpink:          return Color(UIColor(red: 249/255.0, green: 124/255.0, blue: 177/255.0, alpha: 1))
                case .indigopink:       return Color(UIColor(red: 166/255.0, green: 139/255.0, blue: 204/255.0, alpha: 1))
                case .ivory:            return Color(UIColor(red: 233/255.0, green: 233/255.0, blue: 224/255.0, alpha: 1))
                case .orange:           return Color(UIColor.systemOrange)
                case .pink:             return Color(UIColor(red: 248/255.0, green: 188/255.0, blue: 199/255.0, alpha: 1))
                case .purple:           return Color(UIColor(red: 175/255.0, green: 134/255.0, blue: 232/255.0, alpha: 1))
                case .salmon:           return Color(UIColor(red: 235/255.0, green: 123/255.0, blue: 110/255.0, alpha: 1))
                case .seafoam:          return Color(UIColor(red: 123/255.0, green: 190/255.0, blue: 176/255.0, alpha: 1))
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
    "background": "lightgreen"
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
    "foreground": "indigopink",
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
    "foreground": "salmon",
    "background": "deepblue"
    }
]

"""
    }
}

