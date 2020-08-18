//
//  AutographProfileView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 11/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct AutographProfileView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var session: SessionStore
    
    let url: UrlLoader
    
    
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
                    
                    Spacer(minLength: 8)
                    
                    Button(action: {
                        // Añadir código para eliminar la imagen
                        
                    }){
                        HStack {
                            Image(systemName: self.colorScheme == .dark ? "trash": "trash.fill")
                            
                            Text("Borrar autógrafo")
                                .font(.system(size: 18, weight: .bold))
                        }.padding(15)
                        
                    }.frame(minWidth: 0, maxWidth: g.size.width-15)
                        .background(Color("gris"))
                        .foregroundColor(Color.red)
                        .cornerRadius(8)
                }
            }
        }

    }
}
