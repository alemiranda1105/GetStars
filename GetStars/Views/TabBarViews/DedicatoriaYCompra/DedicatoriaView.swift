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
import MediaWatermark
import Firebase

struct DedicatoriaView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var session: SessionStore
    @State var product: Product
    
    
    // Opciones de texto
    @State var mensaje = ""
    
    @State var size: CGFloat = 12
    @State var posX: CGFloat = 0.0
    @State var posY: CGFloat = 0.0
    
    @State var frame: CGFloat = 0.0
    
    @State var error = ""
    
    // Filtro palabras
    private let filtro: [String] = ["cabrón", "cabron", "puta", "putón", "puton", "zorro", "mierda", "desgraciado", "hostias", "subnormal", "inútil", "inutil", "puto"]
    
    @State var showPayment = false
    
    private func checkDedicatoria() -> Bool {
        let array = self.mensaje.split(separator: " ")
        for m in array {
            for p in self.filtro {
                if m.lowercased() == p.lowercased() {
                    return false
                }
            }
        }
        return true
    }
    
    func createDedicatory() {
        // Descargar la imagen de Storage
        // Añadirle la dedicatoria
        // Enviarla a revisión
        
        let dg = DispatchGroup()
        let st = StarsST()
        
        st.downloadFile(key: "prueba", dg: dg)
        dg.notify(queue: DispatchQueue.global(qos: .userInitiated)) {
            
            let item = MediaItem(image: st.getImageFile())
            
            let proportion = (item.size.height/UIScreen.main.bounds.height) * (item.size.width/UIScreen.main.bounds.width)
            let center = [item.size.width/2, item.size.height/2]
            let pos = self.checkCenter(center: center, proportion: proportion)
            
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: self.size * proportion)]
            let attrStr  = NSAttributedString(string: self.mensaje, attributes: attributes)
            let mes = MediaElement(text: attrStr)
            
            mes.frame = CGRect(x: pos[0], y: pos[1], width: item.size.width, height: item.size.height)
            
            item.add(element: mes)
            
            let mediaProcessor = MediaProcessor()
            mediaProcessor.processElements(item: item) { (result, error) in
                let storage = Storage.storage()
                let path = "usuarios/" + "amiranda110500@gmail.com" + "/" + "autDed" + "/" + "1" + ".jpg"
                let storageRef = storage.reference()
                let imgRef =  storageRef.child(path)
                
                // Subida
                let data = result.image!.jpegData(compressionQuality: 0.8)!
                _ = imgRef.putData(data, metadata: nil) { (metadata, error) in
                    guard metadata != nil else {
                        print(error?.localizedDescription as Any)
                        return
                    }
                }
            }
        }
    }
    
    private func checkCenter(center: [CGFloat], proportion: CGFloat) -> [CGFloat] {
        // Comprobacion X
        let x = center[0]
        print(x)
        
        var newX: CGFloat = 0.0
        if x >= self.posX {
            newX = x + (self.posX * proportion)
        } else {
            newX = x + (self.posX * proportion)
        }
        print(newX)
        
        // Comprobacion Y
        let y = center[1]
        print(y)
        
        print("Pos de y \(self.posY)")
        
        var newY: CGFloat = 0.0
        if y >= self.posY {
            newY = y - (self.posY * proportion)
        } else {
            newY = y + (self.posY * proportion)
        }
        print(newY)
        
        return [newX, newY]
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
                            
                            Text(self.mensaje)
                                .font(.system(size: self.size))
                                .foregroundColor(.white).offset(x: self.posX, y: self.posY)
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
                            }.padding(.horizontal, 12)
                            
                            Spacer()
                            if self.error != "" {
                                Text(self.error)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.red)
                                    .padding()
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
                        }.padding(.horizontal, 12)
                        HStack {
                            TextField("Pulsa para editar la dedicatoria", text: self.$mensaje)
                            .font(.system(size: 14))
                            .padding(10)
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .strokeBorder(Color("naranja"), lineWidth: 1))
                            
                            Button(action: {
                                if !self.checkDedicatoria() {
                                    self.error = "No introduzca palabras ofensivas"
                                    return
                                }
                                if self.mensaje.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                                    self.error = "Escriba un mensaje, por favor"
                                    return
                                }
                                self.product.setMessage(newMessage: self.mensaje)
                                var n = 0
                                for i in self.session.cart {
                                    if i.equals(product: self.product) {
                                        self.session.cart.remove(at: n)
                                        self.session.cart.insert(self.product, at: n)
                                    }
                                    n += 1
                                }
                                self.session.cart.append(self.product)
                                withAnimation(.easeIn(duration: 0.25)) {
                                    self.showPayment = true
                                }
                            }) {
                                Image(systemName: "cart")
                                    .frame(minWidth: 0, maxWidth: 50)
                                    .padding(10)
                                    .background(Color("naranja"))
                                    .foregroundColor(.white)
                                    .cornerRadius(50)
                            }
                        }.padding().frame(width: g.size.width)
                        
                        Spacer(minLength: 5)
                    }
                }
            }
        }
    }
}

struct DedicatoriaView_Previews: PreviewProvider {
    var session = SessionStore()
    static var previews: some View {
        Group {
            DedicatoriaView(product: (Product(price: 2.99, name: "Preview", description: "Descripción de preview", image: "", owner: Person(name: "", description: "", image: "", key: ""), isDedicated: true))).environmentObject(SessionStore()).previewDevice("iPhone 8")
            DedicatoriaView(product: (Product(price: 2.99, name: "Preview", description: "Descripción de preview", image: "", owner: Person(name: "", description: "", image: "", key: ""), isDedicated: true))).environmentObject(SessionStore()).previewDevice("iPhone 11")
        }
    }
}
