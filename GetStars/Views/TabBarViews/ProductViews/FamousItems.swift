//
//  FamousItems.swift
//  GetStars
//
//  Created by Alejandro Miranda on 24/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI


struct FamousItems: View {
    @EnvironmentObject var session: SessionStore
    
    @Binding var item: String
    @Binding var person: Person
    
    @State var product = [Product]()
    @State var url = URL(string: "https://google.com/")!
    
    @State var loading = true
    
    private func getAutografo() {
        self.product = [Product]()
        let st = StarsST()
        let db = StarsDB()
        let dg = DispatchGroup()
        st.getAut(key: self.person.getKey(), dg: dg)
        dg.notify(queue: DispatchQueue.global(qos: .userInitiated)) {
            let url = st.getAutUrl()
            self.url = url
            
            db.getProductPrice(product: "aut", key: self.person.getKey(), dg: dg)
            dg.notify(queue: DispatchQueue.global(qos: .userInitiated)) {
                var autPrice = db.getPrice()
                //self.product.append(Product(price: autPrice, name: "Autógrafo", description: "Autógrafo de prueba", image: self.url, owner: self.person, isDedicated: false, productType: .autografo))
                
                db.getProductPrice(product: "autDed", key: self.person.getKey(), dg: dg)
                dg.notify(queue: DispatchQueue.global(qos: .userInitiated)) {
                    autPrice = db.getPrice()
                    self.product.append(Product(price: autPrice, name: "Autógrafo dedicado", description: "Autógrafo dedicado de prueba", image: self.url, owner: self.person, isDedicated: true, productType: .autografoDedicado))
                    
                    self.loading = false
                    
                }
            }
        }
    }
    
    private func getFoto() {
        self.product = [Product]()
        let st = StarsST()
        let db = StarsDB()
        let dg = DispatchGroup()
        st.getAutPhoto(key: self.person.getKey(), dg: dg)
        dg.notify(queue: DispatchQueue.global(qos: .userInitiated)) {
            let url = st.getPhoUrl()
            self.url = url
            
            db.getProductPrice(product: "fot", key: self.person.getKey(), dg: dg)
            dg.notify(queue: DispatchQueue.global(qos: .userInitiated)) {
                var autPrice = db.getPrice()
                self.product.append(Product(price: autPrice, name: "Foto con autógrafo", description: "Foto de prueba", image: self.url, owner: self.person, isDedicated: false, productType: .fotoConAutografo))
                
                db.getProductPrice(product: "fotDed", key: self.person.getKey(), dg: dg)
                dg.notify(queue: DispatchQueue.global(qos: .userInitiated)) {
                    autPrice = db.getPrice()
                    self.product.append(Product(price: autPrice, name: "Foto dedicada", description: "Foto dedicado de prueba", image: self.url, owner: self.person, isDedicated: true, productType: .fotoDedicada))
                    
                    self.loading = false
                    
                }
            }
        }
    }
    
    var body: some View {
        Group {
            if self.item == "aut" {
                AutView(url: self.$url, product: self.$product, loading: self.$loading).environmentObject(self.session).onAppear(perform: self.getAutografo)
                    .navigationBarTitle(Text("Autógrafo"), displayMode: .inline)
                    .navigationBarHidden(false)
            } else if self.item == "foto" {
                PhotoView(url: self.$url, product: self.$product, loading: self.$loading).environmentObject(self.session).onAppear(perform: self.getFoto)
                    .navigationBarTitle(Text("Fotos"), displayMode: .inline)
                    .navigationBarHidden(false)
            } else {
                VStack {
                    Text("Próximamente")
                        .padding()
                        .font(.system(size: 32, weight: .bold))
                    Text("Estamos trabajando para que puedas conectar con las estrellas de una manera en la que nunca lo habías hecho")
                        .padding()
                        .font(.system(size: 24, weight: .thin))
                        .multilineTextAlignment(.center)
                }
            }
        }.navigationBarHidden(false)
    }
}


#if DEBUG
struct FamousItems_Previews: PreviewProvider {
    static var previews: some View {
        FamousItems(item: .constant("aut"), person: .constant(Person(name: "DEbug", description: "Debug", image: "", key: "")))
    }
}
#endif
