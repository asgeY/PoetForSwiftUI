//
//  TextObserver.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/24/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation
import SwiftUI

struct ObservingTextView: View {
    @ObservedObject var text: ObservableString
    let font: Font
    let alignment: TextAlignment
    
    var body: some View {
        return Text(self.text.string)
            .lineLimit(nil)
            .font(font)
            .multilineTextAlignment(alignment)
    }
}

struct ObservingTextView_Previews: PreviewProvider {
    static var previews: some View {
        ObservingTextView(text: ObservableString("Hello"), font: Font.body, alignment: .leading)
    }
}

