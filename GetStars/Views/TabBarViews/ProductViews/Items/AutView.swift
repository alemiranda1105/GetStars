//
//  AutView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 01/10/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct AutView: View {
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
                    //DedicatoriaView(product: self.dedicatoryItem).environmentObject(self.session)
                    SelectDedicatoryType(product: self.dedicatoryItem).environmentObject(self.session)
                } else if self.showCart {
                    PaymentView(product: Product()).environmentObject(self.session).navigationBarTitle("")
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
                    }
                }
            }.frame(width: g.size.width, height: g.size.height, alignment: .center)
        }
    }
}