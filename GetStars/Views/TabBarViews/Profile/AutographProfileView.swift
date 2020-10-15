//
//  AutographProfileView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 11/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

import CoreGraphics
import Photos

struct AutographProfileView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var session: SessionStore
    
    let url: UrlLoader
    
    private func deleteImage() {
        self.session.st.deleteFile(userType: "usuarios", email: self.session.session?.email ?? "", name: "\(self.url.name).jpg", type: "AutMan")
        self.session.data?.autMan -= 1
        //self.session.articles["AutMan"] = self.session.data?.autMan
        let defaults = UserDefaults.standard
        defaults.set(self.session.data!.autMan, forKey: "AutMan")
        defaults.synchronize()
        self.session.db.updateAutManDB(session: self.session)
        var p = 0
        for i in self.session.url {
            if i.id == self.url.id {
                self.session.url.remove(at: p)
            }
            p += 1
        }
        print("Eliminada la imagen")
        self.presentationMode.wrappedValue.dismiss()
        
    }
    
    
    var body: some View {
        GeometryReader { g in
            Group {
                ScrollView {
                    Spacer(minLength: 12)
                    
                    WebImage(url: self.url.url)
                        .resizable()
                        .placeholder(Image(systemName: "photo"))
                        .placeholder {
                            Rectangle().foregroundColor(.gray)
                        }
                        .indicator(.activity)
                        .transition(.fade(duration: 0.5))
                        .scaledToFit()
                    .frame(width: g.size.width, height: g.size.height/1.25, alignment: .center)
                    
                    Spacer(minLength: 32)
                    
                    Button(action: {
                        // Añadir código para descargar la imagen
                        let dg = DispatchGroup()
                        self.session.st.downloadFile(session: self.session, type: "AutMan", index: self.url.name, dg: dg)
                        dg.notify(queue: DispatchQueue.global(qos: .userInitiated)) {
                            let img = self.session.st.getDownloadImg()
                            let library: PHPhotoLibrary = PHPhotoLibrary.shared()
                            library.savePhoto(image: img, albumName: "GetStars")
                        }
                        
                    }){
                        HStack {
                            Image(systemName: self.colorScheme == .dark ? "square.and.arrow.down": "square.and.arrow.down.fill")
                            
                            Text("Download autograph")
                                .font(.system(size: 18, weight: .bold))
                        }.padding(15)
                        
                    }.frame(minWidth: 0, maxWidth: .infinity)
                        .background(Color("gris"))
                        .foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
                        .cornerRadius(8)
                        .padding(15)
                    
                    Spacer(minLength: 8)
                    
                    Button(action: {
                        self.deleteImage()
                    }){
                        HStack {
                            Image(systemName: self.colorScheme == .dark ? "trash": "trash.fill")
                            
                            Text("Delete autograph")
                                .font(.system(size: 18, weight: .bold))
                        }.padding(15)
                        
                    }.frame(minWidth: 0, maxWidth: .infinity)
                        .background(Color("gris"))
                        .foregroundColor(Color.red)
                        .cornerRadius(8)
                        .padding(15)
                }
            }
        }

    }
}
