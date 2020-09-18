//
//  DetailProductView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 17/09/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct DetailProductView: View {
    @EnvironmentObject var session: SessionStore
    
    @Binding var product: String
    
    @State var url = URL(fileReferenceLiteralResourceName: "")
    
    private func loadProduct() {
        // let db = StarsDB()
        // let st = StarsST()
        
        if self.product == "autFot" {
            
        } else if self.product == "fotDed" {
            
        } else if self.product == "aut" {
            
        } else if self.product == "autDed" {
            
        }
        
    }
    var body: some View {
        GeometryReader { g in
            VStack {
                WebImage(url: self.url)
                    .resizable()
                    .placeholder(Image(systemName: "photo"))
                    .placeholder {
                        Rectangle().foregroundColor(Color("gris"))
                    }
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .cornerRadius(15)
                    .overlay(RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.clear, lineWidth: 1))
                    .scaledToFit()
                    .frame(width: g.size.width/2, height: g.size.height/2, alignment: .center)
                
                Spacer()
                
                Button(action: {
                    // Editar imagen
                    
                }) {
                    Text("Editar imagen")
                }
                
                Button(action: {
                    // Cambiar precio
                    
                }) {
                    Text("Cambiar precio")
                }
            }.onAppear(perform: self.loadProduct)
        }
    }
}
