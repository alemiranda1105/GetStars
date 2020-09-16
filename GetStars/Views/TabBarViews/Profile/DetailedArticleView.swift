//
//  DetailedArticleView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 16/09/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import Photos

struct DetailedArticleView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var session: SessionStore
    
    @State var url: String
    
    
    var body: some View {
        GeometryReader { g in
            Group {
                ScrollView {
                    Spacer(minLength: 12)
                    
                    ZStack{
                        WebImage(url: URL(string: self.url))
                        .resizable()
                        .placeholder(Image(systemName: "photo"))
                        .placeholder {
                            Rectangle().foregroundColor(.gray)
                        }
                        .indicator(.activity)
                        .transition(.fade(duration: 0.5))
                        .scaledToFit()
                        
                        VStack {
                            Text(self.session.session?.email ?? "GetStars")
                            .font(.system(size: 18, weight: .light))
                            .foregroundColor(Color.black.opacity(0.35))
                            
                            Image("watermark")
                                .resizable()
                                .scaledToFit()
                                .opacity(0.35)
                        }.frame(width: g.size.width/1.8, height: g.size.height/2, alignment: .center)
                        
                    }.frame(width: g.size.width, height: g.size.height/1.25, alignment: .center)
                    
                    Spacer(minLength: 32)
                    
                    Button(action: {
                        // Añadir código para descargar la imagen
                    
                    }){
                        HStack {
                            Image(systemName: self.colorScheme == .dark ? "square.and.arrow.down": "square.and.arrow.down.fill")
                            
                            Text("Descargar autógrafo")
                                .font(.system(size: 18, weight: .bold))
                        }.padding(15)
                        
                    }.frame(minWidth: 0, maxWidth: g.size.width-15)
                        .background(Color("gris"))
                        .foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
                        .cornerRadius(8)
                }
            }
        }
    }
}
