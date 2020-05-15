//
//  HelloWorld-Evaluator.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/15/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

extension HelloWorld {
    class Evaluator {
        
        // Translator
        lazy var translator: Translator = Translator(current)
        
        // Current Step
        var current = PassableStep(Step.loading)
        
    }
}

// Button Actions
extension HelloWorld.Evaluator {
    enum ButtonAction: EvaluatorAction {
        case advanceImage
        case showHelloWorld
        case showHelloMoon
        case showHelloSun
    }
}

// Steps and Step Configurations
extension HelloWorld.Evaluator {
    
    // Steps
    enum Step: EvaluatorStep {
        case loading
        case imageTapping(ImageTappingStepConfiguration)
    }
    
    // Configurations
    struct ImageTappingStepConfiguration {
        let title: String
        let images: [String]
        var currentImage: String
        let foreground: Color
        let background: Color
        let tapAction: ButtonAction?
        
        mutating func configurationForNextImage() -> ImageTappingStepConfiguration {
            if let index = images.firstIndex(of: currentImage) {
                let newImage: String = {
                    if index < images.count - 1 {
                        return images[index + 1]
                    } else {
                        return images[0]
                    }
                }()
                
                currentImage = newImage
            }
            
            return self
        }
    }
}

// View Cycle
extension HelloWorld.Evaluator: ViewCycleEvaluator {
    
    func viewDidAppear() {
        showHelloWorld()
    }
}

// Showing Steps
extension HelloWorld.Evaluator {
    
    // MARK: World
    
    func showHelloWorld() {
        let title = "Hello World!"
        
        let images = [
            "world01",
            "world02",
            "world03",
            "world04",
            "world05",
            "world06"
        ]
        
        let foreground = Color(UIColor.systemTeal)
        let background = Color.green.opacity(0.5)
        
        let tapAction = ButtonAction.advanceImage
        
        showTappableImagesWithTitle(images, title: title, foreground: foreground, background: background, tapAction: tapAction)
    }
    
    // MARK: Moon
    
    func showHelloMoon() {
        let title = "Hello Moon!"
        
        let images = [
            "moon-01-full",
            "moon-02-waning-gibbous",
            "moon-03-waning-crescent",
            "moon-04-new",
            "moon-05-waxing-crescent",
            "moon-06-waxing-gibbous"
        ]
        
        let foreground = Color(UIColor.systemIndigo).opacity(0.5)
        let background = Color(UIColor.systemPink).opacity(0.3)
        
        let tapAction = ButtonAction.advanceImage
        
        showTappableImagesWithTitle(images, title: title, foreground: foreground, background: background, tapAction: tapAction)
    }
    
    // MARK: Sun
    
    func showHelloSun() {
        let title = "Hello Sun!"
        
        let images = [
            "sun"
        ]
        
        let foreground = Color(UIColor.systemYellow)
        let background = Color(UIColor.systemOrange)
        
        showTappableImagesWithTitle(images, title: title, foreground: foreground, background: background, tapAction: nil)
    }
    
    func showTappableImagesWithTitle(_ images: [String], title: String, foreground: Color, background: Color, tapAction: ButtonAction?) {
        let configuration = ImageTappingStepConfiguration(
            title: title,
            images: images,
            currentImage: images.first ?? "",
            foreground: foreground,
            background: background,
            tapAction: tapAction
        )
        current.step = Step.imageTapping(configuration)
    }
}

// Button Evaluating
extension HelloWorld.Evaluator: ButtonEvaluator {
    func buttonTapped(action: EvaluatorAction?) {
        guard let action = action as? ButtonAction else { return }
        
        switch action {
            
        case .advanceImage:
            advanceImage()
            
        case .showHelloWorld:
            showHelloWorld()
            
        case .showHelloMoon:
            showHelloMoon()
            
        case .showHelloSun:
            showHelloSun()
        }
    }
    
    func advanceImage() {
        guard case var .imageTapping(configuration) = current.step else { return }
        
        current.step = .imageTapping(configuration.configurationForNextImage())
    }
}
