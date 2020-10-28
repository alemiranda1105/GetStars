//
//  BannerCardView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 09/10/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI
import GoogleMobileAds

struct BannerCardView: View {
    var body: some View {
        VStack {
            ZStack {
                Banner()
                    .frame(width: 350, height: 350, alignment: .center)
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.clear, lineWidth: 1))
            }.shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
            
            Spacer(minLength: 16)
        }
    }
}

struct BannerCardView_Previews: PreviewProvider {
    static var previews: some View {
        BannerCardView()
    }
}
