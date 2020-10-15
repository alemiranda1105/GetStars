//
//  SelectDedicatoryType.swift
//  GetStars
//
//  Created by Alejandro Miranda on 02/10/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI
import StoreKit

struct SelectDedicatoryType: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var session: SessionStore
    @State var product: Product
    
    private let types: [String] = ["def", "cumpleaños", "enfermedad", "fan"]
    private let typesText: [String] = ["Dedicated message", "Dedication for a birthday", "Dedication for someone sick", "Dedication for a fan"]
    @State var selectedType = ""
    
    @State var message = ""
    
    @State var showPayment = false
    
    @State var error = ""
    
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
        
//        if self.selectedType == "def" {
//            self.product.setPrice(newPrice: self.product.price - 2.0)
//        }
        
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
    
    private func purchase(product: SKProduct) -> Bool {
        if !IAPManager.shared.canMakePayments() {
            return false
        } else {
            IAPManager.shared.buy(product: product) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        print("Comprado")
                        self.product.setMessage(newMessage: self.message)
                        self.product.addProductToAccount(session: self.session)
                    case .failure(let error):
                        print(error.localizedDescription)
                        self.error = "The puchase has not been completed, please try again"
                    }
                }
            }
        }
        return true
    }
    
    var body: some View {
        Group {
            if self.showPayment {
                PaymentView(product: Product()).environmentObject(self.session)
            } else {
                VStack {
                    
                    if self.product.productType != .autografoDedicado {
                        Text("You have choosen a dedicated picture")
                            .font(.system(size: 22, weight: .bold))
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        if self.product.productType != .fotoDedicadaCustom {
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
                        }
                        
                        Spacer()
                        
                        if self.product.productType != .fotoDedicada {
                            Text("Custom message from the star:")
                                .font(.system(size: 22, weight: .bold))
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                        
                    } else {
                        Spacer()
                    }
                    
                    if self.product.productType != .fotoDedicada {
                        
                        if self.product.productType == .autografoDedicado {
                            Text("Select a custom message from the star:")
                                .font(.system(size: 22, weight: .bold))
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                        
                        ForEach(1 ..< self.typesText.count, id: \.self) { index in
                            Button(action: {
                                self.selectedType = self.types[index]
                                self.loadMessage(type: self.selectedType)
                            }) {
                                if self.selectedType == self.types[index] {
                                    Image(systemName: "checkmark.circle")
                                }
                                Text(LocalizedStringKey(self.typesText[index]))
                                    .font(.system(size: 20, weight: .thin))
                            }
                        }.padding()
                    }
                    
                    Spacer()
                    
                    if self.error != "" {
                        Text(LocalizedStringKey(self.error))
                            .font(.system(size: 18, weight: .bold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.red)
                            .padding()
                    }
                    
                    if self.selectedType != "" && self.message != "" {
                        
                        Button(action: {
                            
                            if self.purchase(product: self.product.skproduct) {
                                print("Holiiiis")
                            }
                            
                        }) {
                            Text("Buy")
                                .font(.system(size: 20, weight: .semibold))
                        }.padding()
                    }
                }
            }
        }
    }
}
