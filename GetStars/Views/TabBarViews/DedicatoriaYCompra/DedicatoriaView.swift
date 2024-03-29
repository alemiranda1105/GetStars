//
//  DedicatoriaView.swift
//  GetStars
//
//  Created by Alejandro Miranda on 26/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI
import UIKit
import SDWebImageSwiftUI
import ColorPickerRing
import Firebase

/*struct DedicatoriaView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var session: SessionStore
    @State var product: Product
    
    
    // Opciones de texto
    @State var mensaje = ""
    @State var mensajePred: String
    
    @State var color: Color = Color(hex: "FCA310")
    @State var uiColor = Color(hex: "FCA310").uiColor()
    
    @State var size: CGFloat = 12
    @State var posX: CGFloat = 0.0
    @State var posY: CGFloat = 0.0
    
    @State var frame: CGFloat = 0.0
    
    // Manejo de errores
    @State var error = ""
    @State var showError = false
    
    // Filtro palabras
    private let filtro: [String] = ["cabrón", "cabron", "puta", "putón", "puton", "zorro", "mierda", "desgraciado", "hostias", "subnormal", "inútil", "inutil", "puto"]
    
    @State var showPayment = false
    
    // ColorPicker
    @State var showColorMenu = false
    private let colors: [Color] = [.white, .black, .red, .blue, .green, .pink, .purple]
    
    private func checkDedicatoria() -> Bool {
        self.showError = false
        self.error = ""
        
        // Mensaje vacío
        /*if self.mensaje.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            self.error = "Escriba un mensaje, por favor"
            self.showError = true
            return false
        }*/
        
        //Longitud del mensaje
        /*if self.mensaje.count >= 80 {
            self.error = "El mensaje supera los 80 caracteres"
            self.showError = true
            return false
        }*/
        
        // Filtro de palabras ofensivas
        //let array = self.mensaje.split(separator: " ")
        let array = self.mensajePred.split(separator: " ")
        for m in array {
            for p in self.filtro {
                if m.lowercased() == p.lowercased() {
                    self.error = "No introduzca palabras ofensivas"
                    self.showError = true
                    return false
                }
            }
        }
        
        // Añade el producto al carrito de compra
        //self.product.setMessage(newMessage: self.mensaje)
        self.product.setMessage(newMessage: self.mensajePred)
        var n = 0
        for i in self.session.cart {
            if i.equals(product: self.product) {
                self.session.cart.remove(at: n)
                self.session.cart.insert(self.product, at: n)
            }
            n += 1
        }
        
        // Datos de la dedicatoria
        product.setDatosDedicatoria(pos: [self.posX, self.posY], color: self.uiColor, size: self.size)
        
        self.session.cart.append(self.product)
        
        return true
    }
    
    var body: some View {
        Group {
            if self.showPayment {
                PaymentView(product: Product()).environmentObject(self.session)
            } else {
                GeometryReader { g in
                    VStack {
                        ZStack {
                            WebImage(url: URL(string: self.product.image))
                            .resizable()
                            .placeholder(Image(systemName: "photo"))
                            .placeholder {
                                Rectangle().foregroundColor(Color("gris"))
                            }
                            .indicator(.activity)
                            .transition(.fade(duration: 0.5))
                            .scaledToFit()
                            .frame(width: g.size.width, height: g.size.height/1.5, alignment: .center)
                            
                            VStack {
                                Image("watermark")
                                    .resizable()
                                    .scaledToFit()
                                    .opacity(0.35)
                            }.frame(width: g.size.width/2, height: g.size.height/2, alignment: .center)
                            
                            //Text(self.mensaje)
                            Text(self.mensajePred)
                                .font(.system(size: self.size))
                                .foregroundColor(self.color)
                                .offset(x: self.posX, y: self.posY)
                                .frame(width: (g.size.width/1.80), height: g.size.width/1.80)
                                .multilineTextAlignment(.leading)
                        }.onAppear {
                            self.frame = g.size.width/1.80
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
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                self.showColorMenu.toggle()
                            }) {
                                Text("Color")
                                    .frame(width: 50)
                                    .padding(4)
                                    .background(Color("navyBlue"))
                                    .foregroundColor(.white)
                                    .cornerRadius(2.5)
                                
                            }
                            
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
                        }.padding().frame(width: g.size.width)
                        
                        HStack {
                            /*TextField("Pulsa para editar la dedicatoria", text: self.$mensaje)
                            .font(.system(size: 14))
                            .padding(10)
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .strokeBorder(Color("naranja"), lineWidth: 1))*/
                            
                            Button(action: {
                                withAnimation(.easeIn(duration: 0.25)) {
                                    self.showPayment = self.checkDedicatoria()
                                }
                            }) {
                                Image(systemName: "cart")
                                    .frame(minWidth: 0, maxWidth: 50)
                                    .padding(10)
                                    .background(Color("naranja"))
                                    .foregroundColor(.white)
                                    .cornerRadius(50)
                            }.alert(isPresented: self.$showError) {
                                Alert(title: Text("Error"), message: Text(LocalizedStringKey(self.error)), dismissButton: .default(Text("OK")))
                            }
                            
                        }.padding().frame(width: g.size.width)
                        
                        Spacer(minLength: 5)
                    }.sheet(isPresented: self.$showColorMenu) {
                        VStack {
                            Text("Seleccione un color:").font(.system(size: 32, weight: .bold)).padding()
                            
                            Spacer()
                            
                            ColorPickerRing(color: self.$uiColor, strokeWidth: 30)
                                .frame(width: 300, height: 300, alignment: .center)
                            
                            HStack(spacing: 30) {
                                Button(action: {
                                    self.uiColor = UIColor.black
                                    self.color = Color(self.uiColor)
                                    self.showColorMenu.toggle()
                                }) {
                                    Text("Negro")
                                        .font(.system(size: 14, weight: .semibold))
                                        .frame(minWidth: 0, maxWidth: 50)
                                        .padding(10)
                                        .background(Color.black)
                                        .foregroundColor(.white)
                                        .cornerRadius(50)
                                }
                                
                                Button(action: {
                                    self.uiColor = UIColor.white
                                    self.color = Color(self.uiColor)
                                    self.showColorMenu.toggle()
                                }) {
                                    Text("Blanco")
                                        .font(.system(size: 14, weight: .semibold))
                                        .frame(minWidth: 0, maxWidth: 50)
                                        .padding(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 50)
                                                .stroke(Color.black, lineWidth: 2)
                                        )
                                        .background(Color.white)
                                        .foregroundColor(.black)
                                        .border(Color.black)
                                        .cornerRadius(50)
                                }
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                self.color = Color(self.uiColor)
                                self.showColorMenu.toggle()
                            }) {
                                Text("Elegir color")
                                    .font(.system(size: 18, weight: .semibold))
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .padding(10)
                                    .background(Color(self.uiColor))
                                    .foregroundColor(.white)
                                    .cornerRadius(50)
                            }.padding()
                        }
                    }
                }.navigationBarTitle(Text("Edita la dedicatoria"))
            }
        }
    }
}*/
