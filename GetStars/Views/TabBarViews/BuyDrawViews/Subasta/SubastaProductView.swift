//
//  SubastaProductView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 17/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseFirestore

struct SubastaProductView: View {
    private let langStr = Locale.current.languageCode
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var session: SessionStore
    
    @Binding var product: Product
    
    @State var price: Double = 0.0
    @State var expanded: Bool = false
    @State var error = ""
    
    private func readPrice() {
        let db = Firestore.firestore()
        db.collection("subastas").document(self.product.productID).getDocument { document, error in
            if error != nil {
                print("error leyendo el precio")
                print(error?.localizedDescription ?? "")
            } else {
                self.product.setPrice(newPrice: document?.data()!["precio"] as! Double)
                self.price = self.product.price
            }
        }
    }
    
    private func addPuja() {
        let db = Firestore.firestore()
        db.collection("subastas").document(self.product.productID).getDocument { document, error in
            if error != nil {
                print("error leyendo el precio")
                print(error?.localizedDescription ?? "")
            } else {
                self.product.setPrice(newPrice: document?.data()!["precio"] as! Double)
                if self.price <= self.product.price {
                    self.error = (self.langStr == "en" ? "The price must be higher than \(self.product.price)€": "El precio debe ser superior a \(self.product.price)€")
                    return
                }

                
                let lastParticipante = document?.data()!["ultimoParticipante"] as! String
                if lastParticipante == self.session.session?.email {
                    self.error = ("You have already participated in this bid and you cannot bid again until someone else bids")
                    return
                }
                self.price = Double(round(self.price*100)/100)
                let newPrice = self.price - self.product.price
                let email = self.session.session?.email!
                let documentRef = db.collection("subastas").document(self.product.productID)
                documentRef.updateData([
                    "precio": FieldValue.increment(newPrice),
                    "ultimoParticipante": email!
                ])
                self.product.setPrice(newPrice: self.price)
                self.expanded = false
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                ZStack {
                    HStack {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "multiply.circle.fill").resizable().frame(width: 28.0, height: 28.0)
                                .foregroundColor(Color.gray)
                        }.padding(16)
                            .padding(.bottom, 16)
                        Spacer()
                    }.zIndex(1000)
                    
                    GeometryReader { g in
                        WebImage(url: URL(string: self.product.image)).resizable()
                        .placeholder(Image(systemName: "photo"))
                        .placeholder {
                            Rectangle().foregroundColor(.gray)
                        }
                        .indicator(.activity)
                        .scaledToFill()
                        .frame(width: g.size.width, height: (g.size.height+165), alignment: .center)
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.clear, lineWidth: 1))
                    }.padding(.bottom, 16)
                        
                    VStack {
                        HStack(alignment: .lastTextBaseline) {
                            Text("\(self.product.name)")
                                .foregroundColor(Color.white)
                                .cornerRadius(16)
                                .font(.system(size: 32, weight: .bold))
                        }.shadow(color: Color.black.opacity(0.9), radius: 5, x: 2, y: 0)
                            .padding(.top, 280)
                    }
                    
                }.padding(.top, -140)
                .edgesIgnoringSafeArea(.top)
                .edgesIgnoringSafeArea(.horizontal)
                
                Text(self.product.description)
                    .font(.system(size: 16, weight: .regular))
                    .padding()
                    .padding(.top, 100)
                    .frame(width: 400, height: 300)
                    .multilineTextAlignment(.leading)
                
                HStack {
                    Text("Precio actual: ")
                        .cornerRadius(15)
                        .font(.system(size: 32, weight: .medium))
                    Text("\(self.product.price.dollarString)€")
                        .cornerRadius(15)
                        .font(.system(size: 32, weight: .medium))
                    Button(action: {
                        self.readPrice()
                    }) {
                        Image(systemName: "arrow.clockwise").resizable()
                            .foregroundColor(self.colorScheme == .dark ? .white: .black)
                    }.frame(width: 20, height: 20, alignment: .center)
                }
                
                
                VStack(spacing: 8) {
                    Button(action: {
                        self.expanded.toggle()
                    }){
                        HStack {
                            Image(systemName: self.colorScheme == .dark ? "plus.app": "plus.app.fill")
                            
                            Text("Pujar")
                                .font(.system(size: 18, weight: .bold))
                        }
                        
                    }.frame(minWidth: 0, maxWidth: .infinity)
                    .padding(15)
                    .background(Color("gris"))
                    .foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
                    .cornerRadius(8)
                    
                    if expanded {
                        Stepper("Pujar: ", onIncrement: {
                            self.price += 0.10
                            self.error = ""
                        }, onDecrement: {
                            if self.price <= self.product.price {
                                self.error =  (self.langStr == "en" ? "You cannot set a price under the actual one": "No se puede pujar por debajo")
                            } else {
                                self.price -= 0.10
                            }
                            
                        }).onAppear(perform: self.readPrice)
                        
                        if error != "" {
                            Text(LocalizedStringKey(self.error))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.red)
                                .padding()
                                .frame(width: 180, height: 100, alignment: .center)
                        }
                        
                        Button(action: {
                            if self.price <= self.product.price {
                                self.error = (self.langStr == "en" ? "The price must be higher than \(self.product.price)€": "El precio debe ser superior a \(self.product.price)€")
                            } else {
                                self.addPuja()
                                self.error = ""
                            }
                        }){
                            HStack {
                                Image(systemName: self.colorScheme == .dark ? "cart": "cart.fill")
                                
                                Text("Añadir Puja (\(self.price.dollarString)€)")
                                    .font(.system(size: 18, weight: .bold))
                            }
                            
                        }.frame(minWidth: 0, maxWidth: .infinity)
                        .padding(15)
                        .background(Color("gris"))
                        .foregroundColor(Color("naranja"))
                        .cornerRadius(8)
                    }
                    
                    NavigationLink(destination: PersonView(person: self.$product.owner)){
                        HStack {
                            Image(systemName: self.colorScheme == .dark ? "person.crop.circle": "person.crop.circle.fill")
                            Text("\(self.product.owner.name)")
                                .font(.system(size: 18, weight: .bold))
                        }
                        
                    }.frame(minWidth: 0, maxWidth: .infinity)
                    .padding(15)
                    .background(Color("gris"))
                    .foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
                    .cornerRadius(8)
                    
                }.padding(16)
                
            }
        }.navigationBarTitle("")
        .navigationBarHidden(true)
        .onAppear {
            self.readPrice()
        }
    }
}

#if DEBUG
struct SubastaProductView_Previews: PreviewProvider {
    static var previews: some View {
        SubastaProductView(product: .constant(Product(price: 99, name: "Test", description: "Casco usado por un corredor de carreras en una carrera en la que corrieron muchos corredores", image: "pr2", owner: Person(name: "Piloto 1", description: "Piloto de carreras", image: "p1", key: ""), isDedicated: false)))
    }
}
#endif
