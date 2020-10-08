//
//  SelectDedicatoryType.swift
//  GetStars
//
//  Created by Alejandro Miranda on 02/10/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct SelectDedicatoryType: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var session: SessionStore
    @State var product: Product
    
    private let types: [String] = ["def", "cumpleaños", "enfermedad", "fan"]
    private let typesText: [String] = ["Mensaje dedicado", "Dedicatoria para un cumpleaños", "Dedicatoria para alguien enfermo", "Dedicatoria para un fan"]
    @State var selectedType = ""
    
    @State var message = ""
    
    @State var showPayment = false
    
    private func loadMessage(type: String) {
        // Leer mensaje predeterminado para ese tipo en la base de datos
        let db = StarsDB()
        let dg = DispatchGroup()
        
        db.readDefaultMessage(key: self.product.owner.getKey(), type: type, dg: dg)
        dg.notify(queue: DispatchQueue.global(qos: .background)) {
            print("Mensaje predeterminado leído")
            let m = db.getDefaultMessage()
            self.message = m.replacingOccurrences(of: "[name]", with: (self.session.data?.getName())!)
        }
    }
    
    private func addCart() {
        self.product.setMessage(newMessage: self.message)
        
        if self.selectedType == "def" {
            self.product.setPrice(newPrice: self.product.price - 2.0)
        }
        
        var n = 0
        for i in self.session.cart {
            if i.equals(product: self.product) {
                self.session.cart.remove(at: n)
                self.session.cart.insert(self.product, at: n)
            }
            n += 1
        }
        self.session.cart.append(self.product)
    }
    
    var body: some View {
        Group {
            if self.showPayment {
                PaymentView(product: Product()).environmentObject(self.session)
            } else {
                VStack {
                    
                    Text("Puedes elegir una foto dedicada:")
                        .font(.system(size: 22, weight: .bold))
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Button(action: {
                        self.selectedType = self.types[0]
                        self.loadMessage(type: self.selectedType)
                    }) {
                        if self.selectedType == self.types[0] {
                            Image(systemName: "checkmark.circle")
                        }
                        Text(self.typesText[0])
                            .font(.system(size: 20, weight: .thin))
                    }
                    
                    Spacer()
                    
                    Text("O que la estrella te dedique un mensaje especial:")
                        .font(.system(size: 22, weight: .bold))
                        .multilineTextAlignment(.center)
                        .padding()
                    ForEach(1 ..< self.typesText.count, id: \.self) { index in
                        Button(action: {
                            self.selectedType = self.types[index]
                            self.loadMessage(type: self.selectedType)
                        }) {
                            if self.selectedType == self.types[index] {
                                Image(systemName: "checkmark.circle")
                            }
                            Text(self.typesText[index])
                                .font(.system(size: 20, weight: .thin))
                        }
                    }.padding()
                    
                    Spacer()
                    
                    if self.selectedType != "" && self.message != "" {
    //                    NavigationLink(destination: DedicatoriaView(product: self.product, mensajePred: self.message).environmentObject(self.session)) {
    //                        Text("Continuar")
    //                            .font(.system(size: 20, weight: .semibold))
    //                    }.padding()
                        
                        Button(action: {
                            self.addCart()
                            self.showPayment = true
                        }) {
                            Text("Añadir al carrito")
                                .font(.system(size: 20, weight: .semibold))
                        }.padding()
                    }
                }
            }
        }
    }
}
