//
//  LivePlayerView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 11/09/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI
import AVKit

struct LivePlayerView: View {
    @EnvironmentObject var session: SessionStore
    
    @Binding var recorded: Bool
    
    @ObservedObject var cameraObject = CameraController.shared
    
    @State var video = URL(fileURLWithPath: "")
    
    // Usuario
    @Binding var email: String
    @Binding var mensaje: String
    
    // Video
    @State var mute = false
    @State var play = true
    
    @State var subido = false
    @State var subiendo = true
    
    private func uploadVideoToUser() {
        self.subiendo = false
        let dg = DispatchGroup()
        let st = StarsST()
        let db = StarsDB()
        
        st.uploadLiveToUser(key: self.session.data?.getUserKey() ?? "", email: self.email, url: self.video, dg: dg)
        dg.notify(queue: DispatchQueue.global(qos: .background)) {
            print("Video subido a la cuenta del usuario")
            db.eliminarUsuarioLive(key: self.session.data?.getUserKey() ?? "", email: self.email, mensaje: self.mensaje)
            db.añadirLiveSubido(key: self.session.data?.getUserKey() ?? "", email: self.email)
            print("Base de datos live actualizado")
            self.subiendo = false
            self.subido = true
        }
    }
    
    private func getVideoURL() {
        let st = StarsST()
        let dg = DispatchGroup()
        
        st.downloadTempLive(key: self.session.data?.getUserKey() ?? "", dg: dg)
        dg.notify(queue: DispatchQueue.global(qos: .background)) {
            print("URL del live obtenido")
            self.video = st.getLiveURL()
            self.subiendo = false
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
                    
                    VStack {
                        CustomLivePlayerView(url: self.video)
                            .scaledToFill()
                            .frame(width: g.size.width, height: 400, alignment: .center)
                        
                        Spacer()
                        
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
                                self.uploadVideoToUser()
                            }) {
                                Image(systemName: "square.and.arrow.up")
                                .resizable()
                                .frame(width: 30, height: 30, alignment: .center)
                            }
                            
                        }.padding()
                        
                    }.frame(width: g.size.width, alignment: .center)
                        
                }
            }
        }.onAppear(perform: self.getVideoURL)
    }
}
