//
//  HelloSolarSystem-Evaluator.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/15/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

extension HelloSolarSystem {
    class Evaluator {
        
        typealias CelestialBody = HelloSolarSystem.CelestialBody
        
        // Translator
        lazy var translator: Translator = Translator(current)
        
        // Current Step
        var current = PassableStep(Step.initial)
    }
}

// MARK: Button Actions
extension HelloSolarSystem.Evaluator {
    enum ButtonAction: EvaluatorActionWithIconAndID {
        case advanceImage
        case showCelestialBody(CelestialBody)
        
        /*
         Our ButtonActions conform to TabButtonConfiguration,
         which requires an icon and a unique id,
         so each Celestial Body button can be treated as a tab on screen.
         We can just ignore these properties for any button actions that don't want to be a tab.
         */
        
        var icon: String {
            switch self {
                
            case .showCelestialBody(let body):
                return body.images.first ?? ""
                
            default:
                return ""
            }
        }
        
        var id: String {
            switch self {
                
            case .showCelestialBody(let body):
                return String(body.id.uuidString)
                
            default:
                return ""
            }
        }
    }
}

// MARK: Steps and Step Configurations
extension HelloSolarSystem.Evaluator {
    
    enum Step: EvaluatorStep {
        case initial
        case celestialBody(CelestialBodyStepConfiguration)
    }
    
    struct CelestialBodyStepConfiguration {
        let celestialBodies: [CelestialBody]
        let currentCelestialBody: CelestialBody
        let currentImageIndex: Int
        let tapAction: ButtonAction?
        
        func configurationForNextImage() -> CelestialBodyStepConfiguration {
            let newIndex: Int = {
                if currentImageIndex < currentCelestialBody.images.count - 1 {
                    return currentImageIndex + 1
                } else {
                    return 0
                }
            }()
            
            let newConfiguration = CelestialBodyStepConfiguration(
                celestialBodies: celestialBodies,
                currentCelestialBody: currentCelestialBody,
                currentImageIndex: newIndex,
                tapAction: tapAction)
            
            return newConfiguration
        }
    }
}

// MARK: View Cycle
extension HelloSolarSystem.Evaluator: ViewCycleEvaluating {
    
    /**
     On viewDidAppear(), we fetch data from a Store. Then we make (and assign) a CelestialBodyStepConfiguration that contains our fetched data.
     */
    func viewDidAppear() {
        let data = HelloSolarSystem.Store.shared.data
        
        if let first = data.first {
            
            // On viewDidAppear,
            
            let configuration = CelestialBodyStepConfiguration(
                celestialBodies: data,
                currentCelestialBody: first,
                currentImageIndex: 0,
                tapAction: first.images.count > 1 ? .advanceImage : nil)
            
            current.step = .celestialBody(configuration)
        }
    }
}

// MARK: Button Evaluating
extension HelloSolarSystem.Evaluator: ButtonEvaluating {
    func buttonTapped(action: EvaluatorAction?) {
        guard let action = action as? ButtonAction else { return }
        
        switch action {
            
        case .advanceImage:
            advanceImage()
            
        case .showCelestialBody(let body):
            showCelestialBody(body)
        }
    }
    
    /**
    advanceImage(:) makes (and assigns) a new CelestialBodyStepConfiguration using the next image index.
    */
    func advanceImage() {
        guard case let .celestialBody(configuration) = current.step else { return }
        current.step = .celestialBody(configuration.configurationForNextImage())
    }
    
    /**
     showCelestialBody(:) makes (and assigns) a new CelestialBodyStepConfiguration using the chosen celestial body.
     It carries over the `celestialBodies` data from the previous configuration.
     */
    func showCelestialBody(_ body: CelestialBody) {
        guard case let .celestialBody(configuration) = current.step else { return }
        
        let newConfiguration = CelestialBodyStepConfiguration(
            celestialBodies: configuration.celestialBodies,
            currentCelestialBody: body,
            currentImageIndex: 0,
            tapAction: body.images.count > 1 ? .advanceImage : nil)
        
        current.step = .celestialBody(newConfiguration)
    }
}
