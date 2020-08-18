//
//  SubastaProductView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 17/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

struct SubastaProductView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @Binding var product: Product
    
    @State var price: Double = 0.0
    @State var expanded: Bool = false
    @State var error = ""
    
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
                        Image(self.product.image).resizable().scaledToFill()
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
                
                
                Text("Precio actual: \(self.product.price.dollarString)€")
                    .cornerRadius(15)
                    .font(.system(size: 32, weight: .medium))
                
                
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
                            self.price += 1.0
                            self.error = ""
                        }, onDecrement: {
                            if self.price <= self.product.price {
                                self.error = "No se puede pujar por debajo"
                            } else {
                                self.price -= 1.0
                            }
                            
                        })
                        
                        if error != "" {
                            Text(error)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.red)
                                .padding()
                        }
                        
                        Button(action: {
                            self.product.price = self.price
                        }){
                            HStack {
                                Image(systemName: self.colorScheme == .dark ? "cart": "cart.fill")
                                
                                Text("Añadir Puja (\(self.price.dollarString)€)")
                                    .font(.system(size: 18, weight: .bold))
                            }
                            
                        }.frame(minWidth: 0, maxWidth: .infinity)
                        .padding(15)
                        .background(Color("gris"))
                        .foregroundColor(self.colorScheme == .dark ? Color.white: Color("naranja"))
                        .cornerRadius(8)
                    }
                    
                    NavigationLink(destination: ProductView(product: self.$product.owner)){
                        HStack {
                            Image(systemName: self.colorScheme == .dark ? "person.crop.circle": "person.crop.circle.fill")
                            Text("Ver perfil de \(self.product.owner.name)")
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
            self.price = self.product.price
        }
    }
}

#if DEBUG
struct SubastaProductView_Previews: PreviewProvider {
    static var previews: some View {
        SubastaProductView(product: .constant(Product(price: 99, name: "Test", description: "Casco usado por un piloto de carreras en una carrera en la que corrieron muchos corredores", image: "pr2", owner: Person(name: "Piloto 1", description: "Piloto de carreras", image: "p1"))))
    }
}
#endif
