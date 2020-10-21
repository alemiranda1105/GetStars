//
//  FamousItems.swift
//  GetStars
//
//  Created by Alejandro Miranda on 24/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import StoreKit

struct FamousItems: View {
    @EnvironmentObject var session: SessionStore
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var item: String
    @Binding var person: Person
    
    @State var product = [Product]()
    @State var sk = [SKProduct]()
    @State var url = URL(string: "https://google.com/")!
    
    @State var loading = true
    
    private func getSkProducts() {
        DispatchQueue.main.async {
            IAPManager.shared.getProducts { result in
                DispatchQueue.main.sync {
                    switch result {
                    case.success(let products):
                        self.sk.append(contentsOf: products)
                    case.failure(let error):
                        print(error.localizedDescription)
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private func searchSk(name: String) -> SKProduct {
        for i in self.sk {
            let n = i.productIdentifier
            if n == name {
                return i
            }
        }
        self.presentationMode.wrappedValue.dismiss()
        return SKProduct()
    }
    
    private func getAutografo() {
        self.getSkProducts()
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
                // var autPrice = db.getPrice()
                // self.product.append(Product(price: autPrice, name: "Autógrafo", description: "Autógrafo de prueba", image: self.url, owner: self.person, isDedicated: false, productType: .autografo))
                
                db.getProductPrice(product: "autDed", key: self.person.getKey(), dg: dg)
                dg.notify(queue: DispatchQueue.global(qos: .userInitiated)) {
                    // autPrice = db.getPrice()
                    let product = searchSk(name: "autDed")
                    let p = Product(price: Double(truncating: product.price), name: product.localizedTitle, description: product.localizedDescription, image: self.url, owner: self.person, isDedicated: true, productType: .autografoDedicado)
                    p.setSkProduct(sk: product)
                    
                    self.product.append(p)
                    
                    self.loading = false
                    
                }
            }
        }
    }
    
    private func getFoto() {
        self.getSkProducts()
        self.product = [Product]()
        let st = StarsST()
        let db = StarsDB()
        let dg = DispatchGroup()
        st.getAutPhoto(key: self.person.getKey(), dg: dg)
        dg.notify(queue: DispatchQueue.global(qos: .background)) {
            let url = st.getPhoUrl()
            self.url = url
            
            db.getProductPrice(product: "fot", key: self.person.getKey(), dg: dg)
            dg.notify(queue: DispatchQueue.global(qos: .background)) {
                //var autPrice = db.getPrice()
                
                var product = searchSk(name: "fotAut")
                var p = Product(price: Double(truncating: product.price), name: product.localizedTitle, description: product.localizedDescription, image: self.url, owner: self.person, isDedicated: false, productType: .fotoConAutografo)
                p.setSkProduct(sk: product)
                self.product.append(p)
                
                db.getProductPrice(product: "fotDed", key: self.person.getKey(), dg: dg)
                dg.notify(queue: DispatchQueue.global(qos: .userInitiated)) {
                    //autPrice = db.getPrice()
                    
                    product = searchSk(name: "fotDed")
                    p = Product(price: Double(truncating: product.price), name: product.localizedTitle, description: product.localizedDescription, image: self.url, owner: self.person, isDedicated: true, productType: .fotoDedicada)
                    p.setSkProduct(sk: product)
                    
                    self.product.append(p)
                    
                    product = SKProduct()
                    p = Product()
                    
                    // foto con mensaje custom
                    product = searchSk(name: "dedPhoCustom")
                    p = Product(price: Double(truncating: product.price), name: product.localizedTitle, description: product.localizedDescription, image: self.url, owner: self.person, isDedicated: true, productType: .fotoDedicadaCustom)
                    p.setSkProduct(sk: product)
                    
                    self.product.append(p)
                    
                    self.loading = false
                    print("HOla")
                    
                }
            }
        }
    }
    
    var body: some View {
        Group {
            if self.loading {
                ActivityIndicator(isAnimating: .constant(true), style: .large)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
                    .onAppear(perform: {
                        if self.item == "aut" {
                            self.getAutografo()
                        } else {
                            self.getFoto()
                        }
                    })
            } else {
                if self.item == "aut" {
                    AutView(url: self.$url, product: self.$product, loading: self.$loading).environmentObject(self.session)
                        .navigationBarTitle(Text("Autograph"), displayMode: .inline)
                        .navigationBarHidden(false)
                } else if self.item == "foto" {
                    PhotoView(url: self.$url, product: self.$product, loading: self.$loading).environmentObject(self.session)
                        .navigationBarTitle(Text("Photos"), displayMode: .inline)
                        .navigationBarHidden(false)
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
