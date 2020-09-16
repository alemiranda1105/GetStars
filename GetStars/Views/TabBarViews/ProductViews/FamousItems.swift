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
            
            db.getProductPrice(product: "autografo", key: self.person.getKey(), dg: dg)
            dg.notify(queue: DispatchQueue.global(qos: .userInitiated)) {
                var autPrice = db.getPrice()
                self.product.append(Product(price: autPrice, name: "Autógrafo", description: "Autógrafo de prueba", image: self.url, owner: self.person, isDedicated: false, productType: .autografo))
                
                db.getProductPrice(product: "autografo ded", key: self.person.getKey(), dg: dg)
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
            
            db.getProductPrice(product: "foto", key: self.person.getKey(), dg: dg)
            dg.notify(queue: DispatchQueue.global(qos: .userInitiated)) {
                var autPrice = db.getPrice()
                self.product.append(Product(price: autPrice, name: "Foto", description: "Foto de prueba", image: self.url, owner: self.person, isDedicated: false, productType: .fotoConAutografo))
                
                db.getProductPrice(product: "foto ded", key: self.person.getKey(), dg: dg)
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
            } else if self.item == "foto" {
                PhotoView(url: self.$url, product: self.$product, loading: self.$loading).environmentObject(self.session).onAppear(perform: self.getFoto)
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
        }
    }
}

private struct AutView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var session: SessionStore
    
    @Binding var url: URL
    @Binding var product: [Product]
    
    @Binding var loading: Bool
    
    @State var showDedicatoryView = false
    @State var dedicatoryItem = Product()
    @State var showCart = false
    
    var body: some View {
        GeometryReader { g in
            Group {
                if self.showDedicatoryView {
                    DedicatoriaView(product: self.dedicatoryItem).environmentObject(self.session)
                } else if self.showCart {
                    PaymentView(product: Product()).environmentObject(self.session)
                } else {
                    ScrollView {
                        Spacer(minLength: 12)
                        
                        ZStack {
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
                            
                            VStack {
                                Image("watermark")
                                    .resizable()
                                    .scaledToFit()
                                    .opacity(0.35)
                            }.frame(width: g.size.width/3.6, height: g.size.height/2, alignment: .center)
                        }
                        
                        Spacer(minLength: 32)
                        
                        if self.loading {
                            ActivityIndicator(isAnimating: .constant(true), style: .medium).frame(width: g.size.width, height: g.size.height, alignment: .center)
                        } else {
                            ForEach(self.product, id: \.name) { item in
                                Button(action: {
                                    if item.isDedicated {
                                        withAnimation(.default) {
                                            self.dedicatoryItem = item
                                            self.showDedicatoryView = true
                                        }
                                    } else {
                                        withAnimation(.easeIn(duration: 0.25)) {
                                            self.session.cart.append(item)
                                            self.showCart = true
                                        }
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: self.colorScheme == .dark ? "hand.draw": "hand.draw.fill")

                                        Text("\(item.name): \(item.price.dollarString)€")
                                            .font(.system(size: 18, weight: .bold))
                                    }.padding(15)
                                }.frame(width: g.size.width-15)
                                .background(Color("gris"))
                                .foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
                                .cornerRadius(8)
                            }
                        }
                    }.navigationBarTitle(Text("Autógrafo"), displayMode: .inline)
                }
            }
        }
    }
}

private struct PhotoView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var session: SessionStore
    
    @Binding var url: URL
    @Binding var product: [Product]
    
    @Binding var loading: Bool
    
    @State var showDedicatoryView = false
    @State var dedicatoryItem = Product()
    @State var showCart = false
    
    var body: some View {
        GeometryReader { g in
            Group {
                if self.showDedicatoryView {
                    DedicatoriaView(product: self.dedicatoryItem).environmentObject(self.session)
                } else if self.showCart {
                    PaymentView(product: Product()).environmentObject(self.session)
                } else {
                    ScrollView {
                        Spacer(minLength: 12)
                        
                        ZStack {
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
                            
                            VStack {
                                Image("watermark")
                                    .resizable()
                                    .scaledToFit()
                                    .opacity(0.35)
                            }.frame(width: g.size.width/3.6, height: g.size.height/2, alignment: .center)
                        }
                        
                        Spacer(minLength: 32)
                        
                        if self.loading {
                            ActivityIndicator(isAnimating: .constant(true), style: .medium).frame(width: g.size.width, height: g.size.height, alignment: .center)
                        } else {
                            ForEach(self.product, id: \.name) { item in
                                Button(action: {
                                    if item.isDedicated {
                                        withAnimation(.default) {
                                            self.dedicatoryItem = item
                                            self.showDedicatoryView = true
                                        }
                                    } else {
                                        withAnimation(.easeIn(duration: 0.25)) {
                                            self.session.cart.append(item)
                                            self.showCart = true
                                        }
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: self.colorScheme == .dark ? "camera": "camera.fill")

                                        Text("\(item.name): \(item.price.dollarString)€")
                                            .font(.system(size: 18, weight: .bold))
                                    }.padding(15)
                                }.frame(width: g.size.width-15)
                                .background(Color("gris"))
                                .foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
                                .cornerRadius(8)
                            }
                        }
                    }.navigationBarTitle(Text("Fotos"), displayMode: .inline)
                }
            }
        }
    }
}

#if DEBUG
struct FamousItems_Previews: PreviewProvider {
    static var previews: some View {
        FamousItems(item: .constant("aut"), person: .constant(Person(name: "DEbug", description: "Debug", image: "", key: "")))
    }
}
#endif
