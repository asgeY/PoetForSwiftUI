//
//  FontSystem.swift
//  Poet
//
//  Created by Steve Cotner on 5/22/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct FontSystem {
    
    // MARK: Fonts
    
    static let body: Font = {
        switch Device.current {
        case .small:
            return Font.system(size: 16, weight: .regular)
        case .medium:
            return Font.system(size: 17, weight: .regular)
        case .big:
            return Font.system(size: 18, weight: .regular)
        }
    }()
    
    static let title: Font = {
        switch Device.current {
        case .small:
            return Font.system(size: 22, weight: .semibold)
        case .medium:
            return Font.system(size: 24, weight: .semibold)
        case .big:
            return Font.system(size: 26, weight: .semibold)
        }
    }()
    
    static let code: Font = {
        switch Device.current {
        case .small:
            return Font.system(size: 13, weight: .regular, design: .monospaced)
        case .medium:
            return Font.system(size: 14, weight: .regular, design: .monospaced)
        case .big:
            return Font.system(size: 15, weight: .regular, design: .monospaced)
        }
    }()
    
    static let codeSmall: Font = {
        switch Device.current {
        case .small:
            return Font.system(size: 12, weight: .regular, design: .monospaced)
        case .medium:
            return Font.system(size: 13, weight: .regular, design: .monospaced)
        case .big:
            return Font.system(size: 14, weight: .regular, design: .monospaced)
        }
    }()
    
    static let codeExtraSmall: Font = {
        switch Device.current {
        case .small:
            return Font.system(size: 11, weight: .regular, design: .monospaced)
        case .medium:
            return Font.system(size: 12, weight: .regular, design: .monospaced)
        case .big:
            return Font.system(size: 13, weight: .regular, design: .monospaced)
        }
    }()
    
    // MARK: Spacing
    
    struct Spacing {
        static let body: CGFloat = {
            switch Device.current {
            case .small, .medium:
                return 5
            case .big:
                return 6
            }
        }()
        
        static let code: CGFloat = {
            switch Device.current {
            case .small, .medium:
                return 5
            case .big:
                return 6
            }
        }()
        
        static let codeExtraSmall: CGFloat = {
            switch Device.current {
            case .small, .medium:
                return 4
            case .big:
                return 5
            }
        }()
    }
    
    // MARK: Kerning
    
    struct Kerning {
        static let code: CGFloat = {
            switch Device.current {
            case .small, .medium:
                return -0.1
            case .big:
                return 0
            }
        }()
        
        static let codeSmall: CGFloat = {
            switch Device.current {
            case .small, .medium:
                return -0.2
            case .big:
                return 0
            }
        }()
    }
}
