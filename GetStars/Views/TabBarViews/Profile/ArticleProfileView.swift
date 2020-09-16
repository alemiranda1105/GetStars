//
//  ArticleProfileView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 13/09/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct ArticleProfileView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var session: SessionStore
    
    @Binding var type: String
    @State var urls: [UrlLoader] = [UrlLoader]()
    @State var loading = false
    @State var error = ""
    
    private func loadAut() {
        let dg = DispatchGroup()
        let st = StarsST()
        
        var n = 0
        for i in (self.session.data?.compras["aut"])! {
            st.getAut(key: i, dg: dg)
            
            dg.notify(queue: DispatchQueue.global(qos: .background)) {
                for i in st.getUrlCompras() {
                    let url = UrlLoader(url: i, id: n)
                    
                    if url.isContained(array: self.urls, url: url) {break}
                    
                    self.urls.append(url)
                    n += 1
                }
                
            }
            
        }
        self.loading = false
        
    }
    
    private func loadPhoto() {
        let dg = DispatchGroup()
        let st = StarsST()
        
        var n = 0
        for i in (self.session.data?.compras["autFot"])! {
            st.getAutPhoto(key: i, dg: dg)
            
            dg.notify(queue: DispatchQueue.global(qos: .background)) {
                for i in st.getUrlCompras() {
                    let url = UrlLoader(url: i, id: n)
                    
                    if url.isContained(array: self.urls, url: url) {break}
                    
                    self.urls.append(url)
                    n += 1
                }
                
            }
            
        }
        self.loading = false
    }
    
    private func loadItems() {
        if self.session.data?.compras[self.type]?.count ?? 0 <= 0 {
            print("no hay compras bruh")
            self.error = "Parece que no has comprado ningún artículo de este tipo, visita nuestra sección de compra para poder conectar con las estrellas"
            self.loading = false
            return
        } else if type == "aut" {
            self.loadAut()
        } else if type == "autFot" {
            self.loadPhoto()
        }
        
        DispatchQueue.main.async {
            self.urls = self.urls.sorted {
                $0.id < $1.id
            }
        }
        
    }
    
    var body: some View {
        VStack {
            if self.loading {
                ActivityIndicator(isAnimating: .constant(true), style: .large)
            } else {
                Text(self.type)
                Text("\(self.urls.count)")
                GridStack(minCellWidth: 125, spacing: 5, numItems: (self.session.data?.compras[type]?.count) ?? 0){ i, width in
                    NavigationLink(destination: Text("\(self.session.data?.compras[self.type]?[i] ?? "nope")")) {
                        WebImage(url: URL(string: self.session.data?.compras[self.type]?[i] ?? "")!)
                        .resizable()
                        .placeholder(Image(systemName: "photo"))
                        .placeholder {
                            Rectangle().foregroundColor(.gray)
                        }
                        .indicator(.activity)
                        .transition(.fade(duration: 0.5))
                        .frame(width: width, height: width, alignment: .center)
                        .border(Color.black, width: 1)
                    }.buttonStyle(PlainButtonStyle()).padding(.vertical, 5)
                }
            }
        }//.onAppear(perform: self.loadItems)
    }
}

struct ArticleProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleProfileView(type: .constant("debug"))
    }
}
