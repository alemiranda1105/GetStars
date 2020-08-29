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
    @Binding var product: Product
    @State var cart: [Product] = [Product]()
    
    @State var paid: Bool = false
    
    private func readCart() {
        cart.append(self.product)
    }
    
    var body: some View {
        Group {
            if self.paid {
                
                if product.isDedicated {
                    DedicatoriaView().environmentObject(self.session)
                } else {
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
                }
                
            } else {
                VStack {
                    Text("Total a pagar: \(self.product.price.dollarString)€")
                        .cornerRadius(16)
                        .font(.system(size: 32, weight: .bold))
                    
                    Text("Productos en la cesta:")
                        .font(.system(size: 24, weight: .semibold))
                    
                    CartView(cart: self.$cart).onAppear(perform: self.readCart)
                    
                    HStack {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Cancelar pago")
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
        }
    }
}

struct CartView: View {
    @Binding var cart: [Product]
    
    var body: some View {
        List(self.cart) { product in
            HStack(spacing: 8) {
                VStack {
                    Text(product.name)
                        .padding()
                        .font(.system(size: 18, weight: .regular))
                    Text(product.owner.name)
                        .font(.system(size: 12, weight: .light))
                }
                
                WebImage(url: URL(string: product.image))
                    .resizable()
                    .placeholder(Image(systemName: "photo"))
                    .placeholder {
                        Rectangle().foregroundColor(.gray)
                    }
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .frame(width: 48, height: 48, alignment: .center)
                
                Spacer()
                
                Text(product.price.dollarString + "€")
                    .padding()
                    .font(.system(size: 18, weight: .regular))
            }
        }
    }
    
}

#if DEBUG
struct PaymentView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentView(product: .constant(Product(price: 29.99, name: "Preview", description: "Preview", image: "", owner: Person(name: "Preview owner", description: "Preview owner", image: "", key: "preview"), isDedicated: false))).environmentObject(SessionStore())
    }
}
#endif
