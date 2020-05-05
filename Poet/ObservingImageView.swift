//
//  ObservingImageView.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/2/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct ObservingImageView: View {
    @ObservedObject var imageName: ObservableString
    
    init(_ imageName: ObservableString) {
        self.imageName = imageName
    }
    
    var body: some View {
        Image(imageName.string)
            .resizable()
    }
}

struct ObservingImageView_Previews: PreviewProvider {
    static var previews: some View {
        ObservingImageView(ObservableString(""))
    }
}
