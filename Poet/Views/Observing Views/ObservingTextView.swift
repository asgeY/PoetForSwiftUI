//
//  TextObserver.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/24/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct ObservingTextView: View {
    @ObservedObject var text: ObservableString
    var alignment: TextAlignment
    var kerning: CGFloat
    
    init(_ text: ObservableString, alignment: TextAlignment = .leading, kerning: CGFloat = 0) {
        self.text = text
        self.alignment = alignment
        self.kerning = kerning
    }
    
    var body: some View {
        return Text(self.text.string)
            .kerning(kerning)
            .multilineTextAlignment(alignment)
    }
}

struct ObservingTextView_Previews: PreviewProvider {
    static var previews: some View {
        ObservingTextView(ObservableString("Hello"), alignment: .leading)
    }
}
