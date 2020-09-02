//
//  PaymentView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 26/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct PaymentView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var session: SessionStore
    @State var product: Product
    @State var cart: [Product] = [Product]()
    
    @State var total: Double = 0.0
    
    @State var editing: Bool = false
    @State var paid: Bool = false
    
    private func readCart() {
        self.session.cart = session.getCart()
        self.addProduct()
        for item in self.session.cart {
            total += item.price
        }
    }
    
    private func addProduct() {
        // Condición para llamadas sin añadir productos a la cesta
        if self.product.name == "" {
            return
        }
        for i in self.session.cart {
            if i.message == self.product.message && i.message != "" {
                return
            }
        }
        self.session.cart.append(self.product)
    }
    
    private func payment() {
        if self.session.cart.count <= 0 {
            self.paid = false
            return
        }
        for i in self.session.cart {
            if i.isDedicated {
                print("Dedicado ------ Subiendo a la nube para revisión")
                print(i.message)
            } else {
                print("No dedicado ------ Añadiendo a compras del usuario")
            }
        }
        self.paid = true
        self.session.cart.removeAll()
    }
    
    var body: some View {
        Group {
            if self.paid {
                VStack {
                    Text("Pago realizado, en breves momentos tus compras serán visibles")
                        .padding()
                        .font(.system(size: 32, weight: .bold))
                        .multilineTextAlignment(.center)
                    Text("Pulsa el botón para volver al inicio")
                        .padding()
                        .font(.system(size: 28, weight: .light))
                        .multilineTextAlignment(.center)
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Volver atrás")
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding(8)
                            .background(Color("naranja"))
                            .foregroundColor(.white)
                            .cornerRadius(50)
                            .font(.system(size: 18, weight: .bold))
                    }.padding()
                }
            } else {
                VStack {
                    Text("Total a pagar: \(self.total.dollarString)€")
                        .cornerRadius(16)
                        .font(.system(size: 32, weight: .bold))
                    
                    Text("Productos en la cesta:")
                        .font(.system(size: 24, weight: .semibold))
                    Spacer()
                    
                    CartView(editing: self.$editing).environmentObject(self.session)
                    
                    HStack {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Volver")
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .padding(8)
                                .background(Color("navyBlue"))
                                .foregroundColor(.white)
                                .cornerRadius(50)
                                .font(.system(size: 18, weight: .bold))
                        }
                        
                        Button(action: {
                            self.editing.toggle()
                        }) {
                            if self.editing {
                                Text("Hecho")
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .padding(8)
                                    .background(Color("gris"))
                                    .foregroundColor(self.colorScheme == .dark ? .white: .black)
                                    .cornerRadius(50)
                                    .font(.system(size: 18, weight: .bold))
                            } else {
                                Text("Editar")
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .padding(8)
                                    .background(Color("gris"))
                                    .foregroundColor(self.colorScheme == .dark ? .white: .black)
                                    .cornerRadius(50)
                                    .font(.system(size: 18, weight: .bold))
                            }
                        }
                        
                        Button(action: {
                            self.payment()
                        }) {
                            Text("Pagar")
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .padding(8)
                                .background(Color("naranja"))
                                .foregroundColor(.white)
                                .cornerRadius(50)
                                .font(.system(size: 18, weight: .bold))
                        }
                    }.padding()
                    
                }.padding()
            }
        }.onAppear(perform: self.readCart)
    }
}

#if DEBUG
struct PaymentView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentView(product: Product(price: 0, name: "", description: "", image: "", owner: Person(), isDedicated: false)).environmentObject(SessionStore())
    }
}
#endif
