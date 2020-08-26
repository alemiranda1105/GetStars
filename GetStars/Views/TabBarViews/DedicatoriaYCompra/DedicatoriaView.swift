//
//  DedicatoriaView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 26/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct DedicatoriaView: View {
    @State var url = URL(string: "https://firebasestorage.googleapis.com/v0/b/getstars-a36bb.appspot.com/o/creadores%2F93cnbY5xxelS73sSsWnm%2FprofileImage.jpg?alt=media&token=3391460d-5bc0-4975-bc3a-6b7cd4c39348")!
    
    // Opciones de texto
    @State var mensaje = ""
    
    @State var size: CGFloat = 12
    @State var posX: CGFloat = 0.0
    @State var posY: CGFloat = 0.0
    
    var body: some View {
        GeometryReader { g in
            VStack {
                ZStack {
                    WebImage(url: self.url)
                    .resizable()
                    .placeholder(Image(systemName: "photo"))
                    .placeholder {
                        Rectangle().foregroundColor(Color("gris"))
                    }
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .scaledToFit()
                    .frame(width: g.size.width, height: g.size.height/1.5, alignment: .center)
                    
                    Text(self.mensaje)
                        .font(.system(size: self.size))
                        .foregroundColor(.white).offset(x: self.posX, y: self.posY)
                        .frame(width: g.size.width/1.80, height: g.size.width/1.80)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                HStack {
                    HStack {
                        Button(action: {
                            let impactMed = UIImpactFeedbackGenerator(style: .rigid)
                            impactMed.impactOccurred()
                            if self.size >= 1.0 {
                                self.size -= 0.5
                            }
                        }) {
                            Image(systemName: "minus.square")
                                .frame(width: 25)
                                .padding(4)
                                .background(Color("navyBlue"))
                                .foregroundColor(.white)
                                .cornerRadius(2.5)
                        }
                        
                        Text("Tamaño")
                        
                        Button(action: {
                            let impactMed = UIImpactFeedbackGenerator(style: .rigid)
                            impactMed.impactOccurred()
                            self.size += 0.5
                        }) {
                            Image(systemName: "plus.square")
                                .frame(width: 25)
                                .padding(4)
                                .background(Color("navyBlue"))
                                .foregroundColor(.white)
                                .cornerRadius(2.5)
                        }
                    }.padding(.horizontal, 12)
                    Spacer()
                    
                    HStack {
                        Button(action: {
                            let impactMed = UIImpactFeedbackGenerator(style: .rigid)
                            impactMed.impactOccurred()
                            self.posX -= 2
                        }) {
                            Image(systemName: "chevron.left")
                                .frame(width: 25)
                                .padding(4)
                                .background(Color("navyBlue"))
                                .foregroundColor(.white)
                                .cornerRadius(2.5)
                        }
                        
                        VStack {
                            Button(action: {
                                let impactMed = UIImpactFeedbackGenerator(style: .rigid)
                                impactMed.impactOccurred()
                                self.posY -= 2
                            }) {
                                Image(systemName: "chevron.up")
                                    .frame(width: 25)
                                    .padding(4)
                                    .background(Color("navyBlue"))
                                    .foregroundColor(.white)
                                    .cornerRadius(2.5)
                            }
                            
                            Text("Posición")
                            
                            Button(action: {
                                let impactMed = UIImpactFeedbackGenerator(style: .rigid)
                                impactMed.impactOccurred()
                                self.posY += 2
                            }) {
                                Image(systemName: "chevron.down")
                                    .frame(width: 25)
                                    .padding(4)
                                    .background(Color("navyBlue"))
                                    .foregroundColor(.white)
                                    .cornerRadius(2.5)
                            }
                        }
                        
                        Button(action: {
                            let impactMed = UIImpactFeedbackGenerator(style: .rigid)
                            impactMed.impactOccurred()
                            self.posX += 2
                        }) {
                            Image(systemName: "chevron.right")
                                .frame(width: 25)
                                .padding(4)
                                .background(Color("navyBlue"))
                                .foregroundColor(.white)
                                .cornerRadius(2.5)
                        }
                    }
                }.padding(.horizontal, 12)
                
                TextField("Pulsa para editar la dedidcatoria", text: self.$mensaje)
                    .font(.system(size: 14))
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .strokeBorder(Color("naranja"), lineWidth: 1))
                    .frame(width: g.size.width-10)
                
                Spacer(minLength: 5)
            }
        }.navigationBarItems(trailing: HStack {
            NavigationLink(destination: PaymentView()) {
                Image(systemName: "cart.badge.plus")
                    .resizable()
                    .frame(width: 32, height: 28)
            }
        })
    }
}

struct DedicatoriaView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DedicatoriaView().previewDevice("iPhone 8")
            DedicatoriaView().previewDevice("iPhone 11")
        }
    }
}
