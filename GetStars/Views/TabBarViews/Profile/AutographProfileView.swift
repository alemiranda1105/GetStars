//
//  AutographProfileView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 11/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct AutographProfileView: View {
    @EnvironmentObject var session: SessionStore
    let url: UrlLoader
    
    
    var body: some View {
        WebImage(url: self.url.url)
        .resizable()
        .placeholder(Image(systemName: "photo"))
        .placeholder {
            Rectangle().foregroundColor(.gray)
        }
        .indicator(.activity)
        .transition(.fade(duration: 0.5))
        .scaledToFit()
        .frame(width: 300, height: 300, alignment: .center)

    }
}
