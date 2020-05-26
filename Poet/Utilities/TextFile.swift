//
//  TextFile.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/26/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

struct TextFile {
    let title: String
    let body: String
    let id: UUID = UUID()
    
    static func fromFileName(_ fileName: String?) -> TextFile? {
        if let fileName = fileName {
            if let filepath = Bundle.main.path(forResource: fileName, ofType: "txt") {
                do {
                    let contents = try String(contentsOfFile: filepath)
                    return TextFile(title: fileName, body: contents)
                } catch {
                    debugPrint("file error: \(error)")
                }
            } else {
                debugPrint("no file of name: \(fileName) and type: txt")
            }
        }
        return nil
    }
}
