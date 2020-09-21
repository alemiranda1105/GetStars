//
//  CustomLivePlayer.swift
//  GetStars
//
//  Created by Alejandro Miranda on 18/09/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI
import AVKit

struct CustomLivePlayerView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct CustomLivePlayer_Previews: PreviewProvider {
    static var previews: some View {
        CustomLivePlayerView()
    }
}

struct player: UIViewControllerRepresentable {
    @Binding var url: String
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<player>) -> AVPlayerViewController {
        
        let controller = AVPlayerViewController()
        let player1 = AVPlayer(url: URL(string: self.url)!)
        controller.player = player1
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: UIViewControllerRepresentableContext<player>) {
        
    }
}
