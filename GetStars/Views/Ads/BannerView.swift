//
//  BannerView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 09/10/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI
import GoogleMobileAds
import UIKit

final private class BannerVC: UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<BannerVC>) -> GADBannerView {
        let banner = GADBannerView(adSize: kGADAdSizeBanner)
        banner.backgroundColor = UIColor.clear
        banner.adUnitID = "ca-app-pub-2307684125945843/5270228735"
        #if DEBUG
        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        #endif
        banner.rootViewController = UIApplication.shared.windows.first?.rootViewController
        banner.load(GADRequest())
        
        return banner
    }
    
    func updateUIView(_ uiView: GADBannerView, context: UIViewRepresentableContext<BannerVC>) {
        
    }
}

struct Banner: View {
    var body: some View {
        BannerVC()
    }
}
