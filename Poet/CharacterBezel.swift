//
//  CharacterBezel.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/24/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine
import SwiftUI

struct CharacterBezel: View {
    
    let configuration: Configuration
    
    class Configuration {
        private var behavior: AnyCancellable?
        
        struct Observable {
            var character = ObservableString()
            var opacity = ObservableDouble(0.0)
        }
        var observable = Observable()
        
        enum Layout {
            static var fullOpacity = 1.0
            static var zeroOpacity = 0.0
            static var fadeInDuration = 0.125
            static var fadeOutWaitInMilliseconds = Int(fadeInDuration * 1000.0) + 500
            static var fadeOutDuration = 0.7
        }
        
        init(character: PassableString) {
            self.behavior = character.subject.sink { value in
                self.observable.character.string = value ?? ""
                withAnimation(.linear(duration: Layout.fadeInDuration)) {
                    self.observable.opacity.double = Layout.fullOpacity
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now().advanced(by: .milliseconds(Layout.fadeOutWaitInMilliseconds))) {
                    withAnimation(.linear(duration: Layout.fadeOutDuration)) {
                        self.observable.opacity.double = Layout.zeroOpacity
                    }
                }
            }
        }
    }
    
    var body: some View {
        CharacterBezelWrapped(
            character: configuration.observable.character,
            opacity: configuration.observable.opacity)
    }
}

struct CharacterBezelWrapped: View {
    @ObservedObject var character: ObservableString
    @ObservedObject var opacity: ObservableDouble
    
    enum Layout {
        static var verticalPadding: CGFloat = 30
        static var horizontalPadding: CGFloat = 38
        static var characterFontSize: CGFloat = 128
        static var bezelCornerRadius: CGFloat = 10
        static var bezelBlurRadius: CGFloat = 12
    }
    
    var body: some View {
        VStack {
            Text(character.string)
                .font(Font.system(size: Layout.characterFontSize))
                .padding(EdgeInsets(
                    top: Layout.verticalPadding,
                    leading: Layout.horizontalPadding,
                    bottom: Layout.verticalPadding,
                    trailing: Layout.horizontalPadding))
        }
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.black.opacity(0.05))
                    .padding(10)
                BlurView()
                .mask(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .padding(10))
                .opacity(0.95)
            })
        
        .opacity(opacity.double)
    }
}

struct CharacterBezel_Previews: PreviewProvider {
    static var previews: some View {
        CharacterBezel(configuration: CharacterBezel.Configuration(character: PassableString()))
    }
}


struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemThinMaterial
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
