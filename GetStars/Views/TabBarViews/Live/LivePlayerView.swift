//
//  LivePlayerView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 11/09/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI
import AVKit
import VideoPlayer

struct LivePlayerView: View {
    @ObservedObject var cameraObject = CameraController.shared
    
    @State var video = URL(fileURLWithPath: "")
    
    // Video
    @State var mute = false
    @State var play = true
    
    private func getLive() {
        let st = StarsST()
        let dg = DispatchGroup()
        st.downloadLiveURL(key: "prueba", email: "amiranda110500@gmail.com", dg: dg)
        dg.notify(queue: DispatchQueue.global(qos: .background)) {
            self.video = st.getLiveURL()
        }
    }
    
    var body: some View {
        VStack {
            VideoPlayer(url: self.cameraObject.videoUrl!, play: $play)
            Button(action: {
                self.play.toggle()
            }) {
                Text("Pausar/Iniciar")
            }
        }.onAppear(perform: self.getLive)
    }
}

struct LivePlayerView_Previews: PreviewProvider {
    static var previews: some View {
        LivePlayerView()
    }
}
