//
//  CustomLivePlayer.swift
//  GetStars
//
//  Created by Alejandro Miranda on 18/09/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI
import AVKit
import AVFoundation

struct CustomLivePlayerView: View {
    @State var url: URL
    
    var body: some View {
        CustomLivePlayer(url: self.$url)
    }
}

struct CustomLivePlayer: UIViewControllerRepresentable {
    @Binding var url: URL
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CustomLivePlayer>) -> AVPlayerViewController {
        print(url.absoluteString)
        let controller = AVPlayerViewController()
        let player1 = AVPlayer(url: self.url)
        controller.player = player1
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: UIViewControllerRepresentableContext<CustomLivePlayer>) {
        
    }
}
