//
//  UserLivePlayerView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 22/09/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI
import AVKit
import Photos

struct UserLivePlayerView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var session: SessionStore
    
    @Binding var video: URL
    @State var show = false
    
    var body: some View {
        VStack {
            CustomLivePlayerView(url: self.video)
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: 400, alignment: .center)
            
            Spacer()
            
            /*Button(action: {
                // Añadir código para descargar el live
                let library: PHPhotoLibrary = PHPhotoLibrary.shared()
                library.saveVideo(video: self.video, albumName: "GetStars")
            }){
                HStack {
                    Image(systemName: self.colorScheme == .dark ? "square.and.arrow.down": "square.and.arrow.down.fill")
                    
                    Text("Download live")
                        .font(.system(size: 18, weight: .bold))
                }.padding(15)
                
            }.frame(minWidth: 0, maxWidth: .infinity)
                .background(Color("gris"))
                .foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
                .cornerRadius(8)
                .padding(15)*/
        }
    }
}
