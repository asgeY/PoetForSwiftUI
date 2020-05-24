//
//  BezelView.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/24/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine
import SwiftUI

struct BezelView: View {
    
    @State private var character: String = ""
    @State private var opacity: Double = 0
    
    // Observed
    @ObservedObject var textSize: Observable<TextSize>
    
    // Passed
    private var passableText: PassableString
    
    init(translator: BezelTranslating) {
        self.passableText = translator.bezelTranslator.text
        self.textSize = translator.bezelTranslator.textSize
    }
    
    init(passableText: PassableString, textSize: Observable<TextSize>) {
        self.passableText = passableText
        self.textSize = textSize
    }
    
    enum TextSize: CGFloat {
        case small = 20
        case medium = 32
        case big = 128
    }
    
    enum Layout {
        static var fullOpacity = 1.0
        static var zeroOpacity = 0.0
        static var fadeInDuration = 0.125
        static var fadeOutWaitInMilliseconds = Int(fadeInDuration * 1000.0) + 700
        static var fadeOutDuration = 0.75
        
        static var verticalPadding: CGFloat = 30
        static var horizontalPadding: CGFloat = 38
        static var bezelCornerRadius: CGFloat = 10
        static var bezelBlurRadius: CGFloat = 12
    }
    
    var body: some View {
        VStack {
            VStack {
                
                // Note: this will only display text on a single line unless the text contains line breaks
                
                Text(character)
                    .font(Font.system(size: textSize.value.rawValue))
                    .padding(EdgeInsets(
                        top: Layout.verticalPadding,
                        leading: Layout.horizontalPadding,
                        bottom: Layout.verticalPadding,
                        trailing: Layout.horizontalPadding))
                    .frame(minWidth: .zero, maxWidth: 340, minHeight: .zero, maxHeight: 340)
                    .fixedSize(horizontal: true, vertical: true)
            }
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color(UIColor.systemBackground).opacity(0.95))
                        .padding(10)
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.primary.opacity(0.12))
                        .padding(10)
                    .mask(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .padding(10)
                            .opacity(0.95)
                    )
                }
                
            )
        }
        .opacity(opacity)
            .onReceive(passableText.subject) { (newValue) in
                if let newValue = newValue {
                    self.character = newValue
                    withAnimation(.linear(duration: Layout.fadeInDuration)) {
                        self.opacity = Layout.fullOpacity
                    }
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now().advanced(by: .milliseconds(Layout.fadeOutWaitInMilliseconds))) {
                        withAnimation(.linear(duration: Layout.fadeOutDuration)) {
                            self.opacity = Layout.zeroOpacity
                        }
                    }
                }
        }
        .allowsHitTesting(false)
    }
}

struct BezelView_Previews: PreviewProvider {
    class Translator: BezelTranslating {
        var bezelTranslator = BezelTranslator()
    }
    
    static var previews: some View {
        BezelView(translator: Translator())
    }
}

/// Caution: I haven't yet found a way to disable user interaction on this blur view. "isUserInteractionEnabled,", even when applied to all subviews, seems to have no effect.
struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemThinMaterial
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
