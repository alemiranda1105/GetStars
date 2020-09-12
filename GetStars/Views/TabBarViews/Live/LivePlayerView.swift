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
    @Binding var recorded: Bool
    
    @ObservedObject var cameraObject = CameraController.shared
    
    @State var video = URL(fileURLWithPath: "")
    
    // Video
    @State var mute = false
    @State var play = true
    
    @State var subido = false
    @State var subiendo = false
    
    private func uploadVideoToUser() {
        self.subiendo = true
        let dg = DispatchGroup()
        let st = StarsST()
        
        st.uploadLiveToUser(key: "prueba", email: "amiranda110500@gmail.com", url: self.cameraObject.videoUrl!, dg: dg)
        dg.notify(queue: DispatchQueue.global(qos: .background)) {
            print("Video subido a la cuenta del usuario")
            self.subiendo = false
            self.subido = true
        }
    }
    
    var body: some View {
        Group {
            if self.subido {
                VStack {
                    Text("Live subido")
                        .padding()
                        .font(.system(size: 32, weight: .bold))
                    Text("El live realizado ya ha sido subido y el usuario podrá verlo en su cuenta, muchas gracias.")
                        .padding()
                        .font(.system(size: 24, weight: .thin))
                        .multilineTextAlignment(.center)
                    Spacer()
                    Button(action: {
                        self.recorded = false
                        self.subido = false
                    }) {
                        Text("Grabar otro live")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color("navyBlue"))
                        .foregroundColor(.white)
                        .cornerRadius(50)
                        .font(.system(size: 18, weight: .bold))
                    }.padding()
                }
            } else if self.subiendo {
                VStack {
                    Spacer()
                    ActivityIndicator(isAnimating: .constant(true), style: .large)
                    Spacer()
                }
            } else {
                GeometryReader { g in
                    
                    ZStack(alignment: .bottom) {
                        
                        VideoPlayer(url: self.cameraObject.videoUrl!, play: self.$play)
                        .autoReplay(true)
                        .mute(self.mute)
                        
                        HStack(spacing: 10) {
                            Button(action: {
                                self.recorded = false
                            }) {
                                Image(systemName: "trash")
                                .resizable()
                                .frame(width: 30, height: 30, alignment: .center)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                self.play.toggle()
                            }) {
                                Image(systemName: self.play ? "pause.fill": "play.fill")
                                .resizable()
                                .frame(width: 30, height: 30, alignment: .center)
                            }
                            
                            Button(action: {
                                self.mute.toggle()
                            }) {
                                Image(systemName: self.mute ? "speaker.fill": "speaker.slash.fill")
                                .resizable()
                                .frame(width: 30, height: 30, alignment: .center)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                self.uploadVideoToUser()
                            }) {
                                Image(systemName: "square.and.arrow.up")
                                .resizable()
                                .frame(width: 30, height: 30, alignment: .center)
                            }
                            
                        }.padding()
                        
                    }.frame(width: g.size.width, height: g.size.height * 0.9, alignment: .center)
                    .onDisappear {
                        VideoPlayer.cleanAllCache()
                    }
                        
                    Spacer()
                        
                    
                }
            }
        }
    }
}

struct LivePlayerView_Previews: PreviewProvider {
    static var previews: some View {
        LivePlayerView(recorded: .constant(true))
    }
}
