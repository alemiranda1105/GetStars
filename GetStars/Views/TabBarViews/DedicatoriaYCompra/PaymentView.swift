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
    
    @State var paid: Bool = false
    
    private func readCart() {
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
        self.session.cart.append(self.product)
    }
    
    var body: some View {
        Group {
            if self.paid {
                
                Text("Pago realizado, en breves momentos tus compras serán visibles")
                    .padding()
                    .font(.system(size: 32, weight: .bold))
                    .multilineTextAlignment(.center)
                Text("Pulsa el botón para volver al inicio")
                    .padding()
                    .font(.system(size: 28, weight: .light))
                    .multilineTextAlignment(.leading)
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
                
            } else {
                VStack {
                    Text("Total a pagar: \(self.total.dollarString)€")
                        .cornerRadius(16)
                        .font(.system(size: 32, weight: .bold))
                    
                    Text("Productos en la cesta:")
                        .font(.system(size: 24, weight: .semibold))
                    
                    CartView().environmentObject(self.session)
                    
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
                            self.paid = true
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
