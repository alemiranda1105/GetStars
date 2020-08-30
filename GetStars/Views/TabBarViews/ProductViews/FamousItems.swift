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
                self.product.append(Product(price: autPrice, name: "Autógrafo", description: "Autógrafo de prueba", image: self.url, owner: self.person, isDedicated: false))
                
                db.getProductPrice(product: "autografo ded", key: self.person.getKey(), dg: dg)
                dg.notify(queue: DispatchQueue.global(qos: .userInitiated)) {
                    autPrice = db.getPrice()
                    self.product.append(Product(price: autPrice, name: "Autógrafo dedicado", description: "Autógrafo dedicado de prueba", image: self.url, owner: self.person, isDedicated: true))
                    
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
        st.getPhoto(key: self.person.getKey(), dg: dg)
        dg.notify(queue: DispatchQueue.global(qos: .userInitiated)) {
            let url = st.getPhoUrl()
            self.url = url
            
            db.getProductPrice(product: "foto", key: self.person.getKey(), dg: dg)
            dg.notify(queue: DispatchQueue.global(qos: .userInitiated)) {
                var autPrice = db.getPrice()
                self.product.append(Product(price: autPrice, name: "Foto", description: "Foto de prueba", image: self.url, owner: self.person, isDedicated: false))
                
                db.getProductPrice(product: "foto ded", key: self.person.getKey(), dg: dg)
                dg.notify(queue: DispatchQueue.global(qos: .userInitiated)) {
                    autPrice = db.getPrice()
                    self.product.append(Product(price: autPrice, name: "Foto dedicada", description: "Foto dedicado de prueba", image: self.url, owner: self.person, isDedicated: true))
                    
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

    var body: some View {
        GeometryReader { g in
            Group {
                ScrollView {
                    Spacer(minLength: 12)
                    
                    WebImage(url: self.url)
                        .resizable()
                        .placeholder(Image(systemName: "photo"))
                        .placeholder {
                            Rectangle().foregroundColor(Color("gris"))
                        }
                        .indicator(.activity)
                        .transition(.fade(duration: 0.5))
                        .scaledToFit()
                        .frame(width: g.size.width/2, height: g.size.height/2, alignment: .center)
                        .cornerRadius(15)
                        .overlay(RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.clear, lineWidth: 1))
                    
                    Spacer(minLength: 32)
                    
                    if self.loading {
                        ActivityIndicator(isAnimating: .constant(true), style: .medium).frame(width: g.size.width, height: g.size.height, alignment: .center)
                    } else {
                        ForEach(self.product, id: \.name) { item in
                            NavigationLink(destination: PaymentView(product: item).environmentObject(self.session)) {
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
    
    var body: some View {
        GeometryReader { g in
            Group {
                ScrollView {
                    Spacer(minLength: 12)
                    
                    WebImage(url: self.url)
                        .resizable()
                        .placeholder(Image(systemName: "photo"))
                        .placeholder {
                            Rectangle().foregroundColor(Color("gris"))
                        }
                        .indicator(.activity)
                        .transition(.fade(duration: 0.5))
                        .scaledToFit()
                        .frame(width: g.size.width/2, height: g.size.height/2, alignment: .center)
                        .cornerRadius(15)
                        .overlay(RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.clear, lineWidth: 1))
                    
                    Spacer(minLength: 32)
                    
                    if self.loading {
                        ActivityIndicator(isAnimating: .constant(true), style: .medium).frame(width: g.size.width, height: g.size.height, alignment: .center)
                    } else {
                        ForEach(self.product, id: \.name) { item in
                            NavigationLink(destination: PaymentView(product: item).environmentObject(self.session)) {
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
